local addonName, L = ...;
ArenaLiveMapButton = {};
local MapButton = ArenaLiveMapButton;
local onClick; -- private functions

--[[**
  * Map button OnLoad event callback. Initializes btn to be used as a
  * map button.
  *
  * @param (Button) the map button that is going to be initialized.
]]
function MapButton.init(btn)
  btn:SetScript("OnClick", onClick);
  btn:RegisterForClicks("LeftButtonUp");
end

--[[**
  * Sets btn up to display the war game map with the given id.
  *
  * @param btn (Button) the button object that is going to be set up.
  * @param id (number) the map's id that is used as argument to
  * GetWarGameTypeInfo() in order to retrieve the map's information.
]]
function MapButton.setMap(btn, id)
  local name, _, _, _, _, _, _, texture = GetWarGameTypeInfo(id);
  btn.id = id;
  btn.name:SetText(name);
  btn.icon:SetTexture(texture);
  if (id == ArenaLiveWarGameMenu:getMap()) then
    btn.selectedTexture:Show();
  else
    btn.selectedTexture:Hide();
  end
  btn:Show();
end

--[[**
  * Resets btn, removing all map data it curently displays and
  * hiding it.
  *
  * @param btn (Button) the map button that is going to be reset.
]]
function MapButton.reset(btn)
  btn.id = nil;
  btn.name:SetText("");
  btn.icon:SetTexture();
  btn.selectedTexture:Hide();
  btn:Hide();
end

--[[**
  * Map button OnClick event callback.
  *
  * @param self (Button) the button object that was clicked.
  * @param button (string) name of the mouse button responsible for
  * the click.
  * @param down (boolean) true, if the button was pushed down, false
  * otherwise.
]]
onClick = function(self, button, down)
  if (not self.id) then
    return;
  end

  ArenaLiveWarGameMenu:setMap(self.id);
end
