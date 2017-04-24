local addonName, L = ...;
local MAP_BUTTON_HEIGHT = 40;
local PLAYER_BUTTON_HEIGHT = 32;

-- private variables:
local SELECTED_MAP; 
local PLAYER_LIST = {};

-- private functions:
local updatePlayerData, getPlayerByBattleTag, arenaWarGameIterator,
  updateTeamLeaderButton;

--[[**
  * Initializes ArenaLive's war game menu frame.
]]
function ArenaLiveWarGameMenu:init()
  SetPortraitToTexture(self.portrait, "Interface\\PVPFrame\\RandomPVPIcon");
  ArenaLiveWarGameMenuTitleText:SetText("Spectated War Games");

  local text = _G[self.tournModeButton:GetName() .. "Text"];
  text:SetText("Tournament Mode");

  self.players.scrollBar.doNotHide = true;
  self.maps.scrollBar.doNotHide = true;
  HybridScrollFrame_CreateButtons(self.maps, "ArenaLiveMapButtonTemplate", 2,
    -1);
  HybridScrollFrame_CreateButtons(self.players,
    "ArenaLivePlayerButtonTemplate", 0, -2);

  self.lLeadBtn.title:SetText("Team Leader:");
  self.rLeadBtn.title:SetText("Team Leader:");

  self:SetScript("OnShow", self.onShow);
  self:SetScript("OnEvent", self.onEvent);
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
    updateTeamLeaderButton(self.lLeadBtn, db.teams.left);
    updateTeamLeaderButton(self.rLeadBtn, db.teams.right);
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
  for i = 1, numButtons, 1 do
    button = buttons[i];
    index = i + offset;

    if (index <= #PLAYER_LIST) then
      ArenaLivePlayerButton.setPlayer(button, PLAYER_LIST[index]);
    else
      ArenaLivePlayerButton.reset(button);
    end
  end

  local totalHeight = #PLAYER_LIST * PLAYER_BUTTON_HEIGHT;
  HybridScrollFrame_Update(self, totalHeight, self:GetHeight());
end

--[[**
  * Updates the war game maps scroll frame's buttons to display the
  * maps at the current cursor position.
]]
function ArenaLiveWarGameMenuMapsScrollFrame:update()
  local numWarGameTypes = GetNumWarGameTypes();
  local arenas = {};
  for index, n, _, _, _, _, _, isRandom in arenaWarGameIterator, 0 do
    table.insert(arenas, index);
    if (not SELECTED_MAP and isRandom) then
      SELECTED_MAP = index;
    end
  end

  local offset = HybridScrollFrame_GetOffset(self);
  local buttons = self.buttons;
  local numButtons = #buttons;
  local selMap = ArenaLive:getDatabase().map;
  for i = 1, numButtons, 1 do
    local button = buttons[i];
    local index = offset + i;
    if (index <= #arenas) then
      ArenaLiveMapButton.setMap(button, arenas[index]);
    else
      ArenaLiveMapButton.reset(button);
    end
  end

  local totalHeight = #arenas * MAP_BUTTON_HEIGHT;
  HybridScrollFrame_Update(self, totalHeight, self:GetHeight());
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
  ArenaLiveWarGameMenuMapsScrollFrame:update();
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
  * Returns Battle.net friend data of the user with the BattleTag btag,
  * or nil, if no user with that BattleTag exists.
  *
  * @param bTag (string) the BattleTag of the player, whose
  * Battle.net friend data should be returned.
  * @return (table) the player's data table in PLAYER_LIST.
]]
getPlayerByBattleTag = function(bTag)
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
  * Updates the team leader button btn to display the currently saved
  * team leader in db.
  *
  * @param btn (Button) Team leader button that is going to be
  * updated.
  * @param db (table) Respective team's saved variables table.
]]
updateTeamLeaderButton = function (btn, db)
  local pInfo = getPlayerByBattleTag(db.leader);
  if (pInfo) then
    btn.pID = pInfo.id;
    btn.icon:SetTexture(pInfo.texture);
    btn.name:SetTexture(pInfo.name);
    btn.name:SetTextColor(0, 1, 0, 1);
    btn.info:SetText(pInfo.text);
    btn.bg:SetColorTexture(0, 1, 0, 0.05);
  else
    btn.pID = nil;
    btn.icon:SetTexture();
    btn.name:SetText("Choose a Player");
    btn.name:SetTextColor(1, 0, 0, 1);
    btn.info:SetText("Drag and Drop here.");
    btn.bg:SetColorTexture(1.0, 0, 0, 0.05);
  end
end
