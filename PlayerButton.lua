local addonName, L = ...;
ArenaLivePlayerButton = {};
local PlayerButton = ArenaLivePlayerButton;

--[[**
  * Initializes a player button btn, essentially making it an object
  * of this class's type.
  *
  * btn (Button) reference to an UI button that is going to be
  * initialized as a player button.
]]
function PlayerButton:init(btn)
  --[[
    * Meta tables would be way more elegant here, but since btn is an
    * UI element, it already has a meta table associated with it, so
    * we copy all methods of this class to btn instead.
  ]]
  for key, val in pairs(self) do
    btn[key] = val;
  end
  btn:SetScript("OnDragStart", btn.onDragStart);
end

--[[**
  * OnDragStart script callback.
  *
  * @param button (string) mouse button that was used to click this
  * player button.
]]
function PlayerButton:onDragStart(button)
end

--[[**
  * Changes the appearance of this player button according to the
  * player data in pInfo, or hiding it, if playerInfo is nil.
  *
  * @param pInfo (table) a single player data entry from the war
  * game menu's PLAYER_LIST table.
  * @see WarGameMenu.lua
]]
function PlayerButton:setPlayer(pInfo)
  self.pID = pInfo.id;
  self.name:SetText(pInfo.name);
  self.info:SetText(pInfo.text);
  self.icon:SetTexture(pInfo.texture);
  if (pInfo.online) then
    self.bg:SetColorTexture(0, 0.694, 0.941, 0.05);
  else
    self.bg:SetColorTexture(0.5, 0.5, 0.5, 0.05);
  end
  self:Show();
end

--[[**
  * Resets this player button's player data, removing all texts,
  * textures and hiding it.
]]
function PlayerButton:reset()
  self.pID = nil;
  self.name:SetText("");
  self.info:SetText("");
  self.icon:SetTexture();
  self:Hide();
end
