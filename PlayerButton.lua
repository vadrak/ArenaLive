local addonName, L = ...;
ArenaLivePlayerButton = {};
local PlayerButton = ArenaLivePlayerButton;
local onDragStart; -- private functions

--[[**
  * Initializes the player button btn.
  *
  * btn (Button) reference to an UI button that is going to be
  * initialized as a player button.
]]
function PlayerButton.init(btn)
  btn:RegisterForDrag("LeftButton");
  btn:SetScript("OnDragStart", onDragStart);
end

--[[**
  * Changes the appearance of btn according to the player data in
  * pInfo, or hiding it, if playerInfo is nil.
  *
  * @param btn (PlayerButton) the player button which's player data
  * is going to be set.
  * @param pInfo (table) a single player data entry from the war
  * game menu's PLAYER_LIST table.
  * @see WarGameMenu.lua
]]
function PlayerButton.setPlayer(btn, pInfo)
  btn.bTag = pInfo.bTag;
  btn.name:SetText(pInfo.name);
  btn.info:SetText(pInfo.text);
  btn.icon:SetTexture(pInfo.texture);
  if (pInfo.online) then
    btn.bg:SetColorTexture(0, 0.694, 0.941, 0.05);
  else
    btn.bg:SetColorTexture(0.5, 0.5, 0.5, 0.05);
  end
  btn:Show();
end

--[[**
  * Resets the player button btn's player data, removing all texts,
  * textures and hiding it.
  *
  * @param btn (PlayerButton) the player button object that is going
  * to be reset.
]]
function PlayerButton.reset(btn)
  btn.bTag = nil;
  btn.name:SetText("");
  btn.info:SetText("");
  btn.icon:SetTexture();
  btn:Hide();
end

--[[**
  * OnDragStart script callback.
  *
  * @param button (string) mouse button that was used to click this
  * player button.
]]
onDragStart = function (btn)
  ArenaLiveWarGameMenu:setCursorData(btn.bTag);
end
