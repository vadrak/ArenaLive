local addonName, L = ...;
local MAP_BUTTON_HEIGHT = 40;
local PLAYER_BUTTON_HEIGHT = 32;

-- private variables:
local SELECTED_MAP;
local CURSOR_DATA;
local PLAYER_LIST = {};

-- private functions:
local updatePlayerData, arenaWarGameIterator, tournMode_OnClick;

--[[**
  * Initializes ArenaLive's war game menu frame.
]]
function ArenaLiveWarGameMenu:init()
  local db = ArenaLive:getDatabase();

  SetPortraitToTexture(self.portrait, "Interface\\PVPFrame\\RandomPVPIcon");
  ArenaLiveWarGameMenuTitleText:SetText("Spectated War Games");

  local text = _G[self.tournModeBtn:GetName() .. "Text"];
  text:SetText("Tournament Mode");

  self.players.scrollBar.doNotHide = true;
  self.maps.scrollBar.doNotHide = true;
  HybridScrollFrame_CreateButtons(self.maps, "ArenaLiveMapButtonTemplate", 2,
    -1);
  HybridScrollFrame_CreateButtons(self.players,
    "ArenaLivePlayerButtonTemplate", 0, -2);

  ArenaLiveTeamLeaderButton.init(self.lLeadBtn, "left");
  ArenaLiveTeamLeaderButton.init(self.rLeadBtn, "right");

  --[[
    * We increase the team leader buttons' frame level here, because
    * otherwise they would be below the map scroll frame.
  ]]
  self.lLeadBtn:SetFrameLevel(self.lLeadBtn:GetFrameLevel() + 3);
  self.rLeadBtn:SetFrameLevel(self.rLeadBtn:GetFrameLevel() + 3);

  self.tournModeBtn:SetChecked(db.tournamentMode)
  self:RegisterForClicks("LeftButtonDown");
  self:SetScript("OnShow", self.onShow);
  self:SetScript("OnEvent", self.onEvent);
  self:SetScript("OnClick", self.onClick);
  self.startBtn:SetScript("OnClick", self.startWarGame);
end

--[[**
  * OnShow callback of ArenaLive's war game menu.
]]
function ArenaLiveWarGameMenu:onShow()
  self:updatePlayerList();
  self:updateMapsList();
  self:updateTeamLeaderButtons();
end

--[[**
  * OnEvent callback of ArenaLive's war game menu.
  *
  * @param event (string) the event's name that fired.
  * @param ... (mixed) a number of arguments accompanying the event.
]]
function ArenaLiveWarGameMenu:onEvent(event, ...)
  if (event == "BN_FRIEND_INFO_CHANGED"
      or event == "BN_FRIEND_LIST_SIZE_CHANGED") then
    self:updatePlayerList();
  end
end

--[[**
  * OnClick callback of ArenaLive's war game menu. This is used
  * to reset the cursor's data.
]]
function ArenaLiveWarGameMenu:onClick(button, down)
  if (CURSOR_DATA) then
    self:setCursorData(nil);
  end
end
--[[**
  * Updates the war game menu's player list.
]]
function ArenaLiveWarGameMenu:updatePlayerList()
  if (self:IsShown()) then
    updatePlayerData();
    ArenaLiveWarGameMenuPlayerListScrollFrame:update();
  end
end

--[[**
  * Updates the war game menu's map scroll frame.
]]
function ArenaLiveWarGameMenu:updateMapsList()
  if (self:IsShown()) then
    UpdateWarGamesList();
    ArenaLiveWarGameMenuMapsScrollFrame:update();
  end
end

--[[**
  * Updates the war game menu's two leader buttons.
]]
function ArenaLiveWarGameMenu:updateTeamLeaderButtons()
  if (self:IsShown()) then
    local db = ArenaLive:getDatabase();
    ArenaLiveTeamLeaderButton.setPlayer(self.lLeadBtn, db.teams.left.leader);
    ArenaLiveTeamLeaderButton.setPlayer(self.rLeadBtn, db.teams.right.leader);
  end
end

--[[**
  * Updates the player list scroll frame's buttons to display the
  * players at the current cursor position.
]]
function ArenaLiveWarGameMenuPlayerListScrollFrame:update()
  local offset = HybridScrollFrame_GetOffset(self);
  local buttons = self.buttons;
  local numButtons = #buttons;
  local button, index;
  local height = 0;
  for i = 1, numButtons, 1 do
    button = buttons[i];
    index = i + offset;

    if (index <= #PLAYER_LIST) then
      ArenaLivePlayerButton.setPlayer(button, PLAYER_LIST[index]);
      height = height + MAP_BUTTON_HEIGHT;
    else
      ArenaLivePlayerButton.reset(button);
    end
  end

  local totalHeight = #PLAYER_LIST * PLAYER_BUTTON_HEIGHT;
  HybridScrollFrame_Update(self, totalHeight, height);
end

--[[**
  * Updates the war game maps scroll frame's buttons to display the
  * maps at the current cursor position.
]]
function ArenaLiveWarGameMenuMapsScrollFrame:update()
  local numWarGameTypes = GetNumWarGameTypes();
  local arenas = {};
  for index, _, _, _, _, _, _, isRandom in arenaWarGameIterator, 0 do
    table.insert(arenas, index);
    if (not SELECTED_MAP and isRandom) then
      SELECTED_MAP = index;
    end
  end

  local offset = HybridScrollFrame_GetOffset(self);
  local buttons = self.buttons;
  local numButtons = #buttons;
  local selMap = ArenaLive:getDatabase().map;
  local height = 0;
  for i = 1, numButtons, 1 do
    local button = buttons[i];
    local index = offset + i;
    if (index <= #arenas) then
      ArenaLiveMapButton.setMap(button, arenas[index]);
      height = height + MAP_BUTTON_HEIGHT;
    else
      ArenaLiveMapButton.reset(button);
    end
  end

  local totalHeight = #arenas * MAP_BUTTON_HEIGHT;
  HybridScrollFrame_Update(self, totalHeight, height);
end

--[[**
  * Returns the currently selected map's id.
  *
  * @return (number) the current value of SELECTED_MAP.
]]
function ArenaLiveWarGameMenu:getMap()
  return SELECTED_MAP;
end

--[[**
  * Sets the currently selected map to id.
  *
  * @param id (number) the index of the map that should be selected,
  * as forwarded to GetWarGameTypeInfo().
]]
function ArenaLiveWarGameMenu:setMap(id)
  SELECTED_MAP = id;
  local db = ArenaLive:getDatabase();
  local name, _, _, _, _, _, isRandom = GetWarGameTypeInfo(id);
  if (isRandom) then
    db.map = nil;
  else
    db.map = name;
  end
  ArenaLiveWarGameMenuMapsScrollFrame:update();
end

--[[**
  * Returns Battle.net friend data of the player with the BattleTag
  * btag, or nil, if no user with that BattleTag exists.
  *
  * @param bTag (string) the BattleTag of the player, whose
  * Battle.net friend data should be returned.
  * @return (table) the player's data table in PLAYER_LIST or nil, if
  * no entry with bTag exists or bTag is nil.
]]
function ArenaLiveWarGameMenu:getPlayerByBattleTag(bTag)
  if (not bTag) then
    return nil;
  end

  for index, pInfo in pairs(PLAYER_LIST) do
    if (pInfo.bTag == bTag) then
      return pInfo;
    end
  end

  return nil;
end

--[[**
  * Returns a reference to the player data table that the cursor
  * currently holds or nil, if the cursor does not hold any data at
  * the moment.
  *
  * @return (table) reference to the player data table that the
  * cursor currently holds.
]]
function ArenaLiveWarGameMenu:getCursorData()
  return CURSOR_DATA;
end

--[[**
  * Sets the cursor to hold the player data pointed to by bTag.
  * To reset the cursor, call this function with nil as bTag.
  *
  * @param bTag (string) BattleTag of the player that the cursor
  * should hold.
]]
function ArenaLiveWarGameMenu:setCursorData(bTag)
  CURSOR_DATA = self:getPlayerByBattleTag(bTag);
  if (CURSOR_DATA) then
    SetCursor("Interface\\FriendsFrame\\Battlenet-Battleneticon");
    PlaySound("INTERFACESOUND_CURSORGRABOBJECT");
  else
    ResetCursor();
    PlaySound("INTERFACESOUND_CURSORDROPOBJECT");
  end
end

--[[**
  * Starts a spectated war game with the currently selected settings.
]]
function ArenaLiveWarGameMenu.startWarGame() 
  local db = ArenaLive:getDatabase();
  local l = ArenaLiveWarGameMenu:getPlayerByBattleTag(db.teams.left.leader);
  local r = ArenaLiveWarGameMenu:getPlayerByBattleTag(db.teams.right.leader);
  local tm = db.tournamentMode;
  if (l and r) then
    StartSpectatorWarGame(l.id, r.id, 3, db.map, tm);
  else
    print("Cannot start spectated war game, as at least one team leader has not yet been set.");
  end
end

--[[**
  * Updates the table PLAYER_LIST to reflect the current status of
  * the player's Battle.net friend list.
]]
updatePlayerData = function()
  local numFriends, onlineFriends = BNGetNumFriends();
  local numPlayers = 0;

  table.wipe(PLAYER_LIST);
  for i = 1, numFriends do
    local pID, pName, bTag, _, _, gameAccID, client,
      online = BNGetFriendInfo(i);
    local texture = BNet_GetClientTexture(client);
    if (bTag) then
      numPlayers = numPlayers + 1;
      local pText;
      local name, realm;
      if (gameAccID) then
        _, name, _, realm = BNGetGameAccountInfo(gameAccID);
        if (client == BNET_CLIENT_WOW) then
          realm = realm or GetRealmName();
          pText = name .. "-" .. realm;
        else
          pText = name;
        end
      elseif (not online) then
        pText = "Offline";
      end

      local pTable = {};
      pTable.id = pID;
      pTable.name = pName;
      pTable.bTag = bTag;
      pTable.texture = texture;
      pTable.text = pText;
      pTable.gameAccID = gameAccID;
      pTable.client = client;
      pTable.online = online;

      PLAYER_LIST[numPlayers] = pTable;
    end
  end
end

--[[**
  * War Game map list iterator, which returns only arena maps.
  * This may be used in a generic for-loop.
  *
  * @param start (number) The first map index at which the iterator
  * will start (invariant state). 
  * @param last (number) The last value that the iterator returned
  * (control variable).
  * @return (mixed) War game information of the next arena map.
]]
arenaWarGameIterator = function(start, last)
  last = last or start;
  local numMaps = GetNumWarGameTypes();
  for i = last+1, numMaps, 1 do
    local name, pvpType, collapsed, id, minPlayers, maxPlayers, isRandom,
      iconTexture, shortDescription, longDescription = GetWarGameTypeInfo(i);
    if (name ~= "header" and pvpType == INSTANCE_TYPE_ARENA) then
      return i, name, pvpType, collapsed, id, minPlayers, maxPlayers,
        isRandom, iconTexture, shortDescription, longDescription;
    end
  end

  -- No match
  return nil;
end

--[[**
  * Tournament mode check button OnClick script callback.
  *
  * @param self (CheckButton) reference to the tournament mode check
  * button.
  * @param button (string) name of the mouse button responsible for
  * the click.
  * @param down (boolean) true, if the mouse button was clicked down,
  * false otherwise.
]]
tournMode_OnClick = function(self, button, down)
  local db = ArenaLive.getDatabase();
  db.tournamentMode = ValueToBoolean(self:GetChecked());
end
