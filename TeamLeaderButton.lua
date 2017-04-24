local addonName, L = ...;
ArenaLiveTeamLeaderButton = {};
local TeamLeaderButton  = ArenaLiveTeamLeaderButton;

--[[**
  * Initializes btn as team leader button.
  *
  * @param btn (Button) the button that is going to be initialized
  * as a team leader button.
]]
function TeamLeaderButton.init(btn)
  btn.title:SetText("Team Leader:");

  btn:RegisterForClicks("LeftButtonUp");
  btn:RegisterForDrag("LeftButton");

  btn:SetScript("OnClick", onClick);
  btn:SetScript("OnDragStart", onDragStart);
end

--[[**
  * Updates btn to show the player's data.
  *
  * @param btn (Button) the team leader button that is going to be
  * updated.
  * @param bTag (string) BattleTag of the player whose data will be
  * shown on the team leader button.
]]
function TeamLeaderButton.setPlayer(btn, bTag)
  local pInfo = ArenaLiveWarGameMenu:getPlayerByBattleTag(bTag);
  if (not pInfo) then
    TeamLeaderButton.reset(btn);
    return;
  end
  btn.bTag = bTag;
  btn.icon:SeTexture(pInfo.texture);
  btn.name:SetTexture(pInfo.name);
  btn.name:SetTextColor(0, 1, 0, 1);
  btn.info:SetText(pInfo.text);
  btn.bg:SetColorTexture(0, 1, 0, 0.05);
end

function TeamLeaderButton.reset(btn)
  btn.bTag = nil;
  btn.icon:SetTexture();
  btn.name:SetText("Choose a Player");
  btn.name:SetTextColor(1, 0, 0, 1);
  btn.info:SetText("Drag and Drop here.");
  btn.bg:SetColorTexture(1, 0, 0, 0.05);
end

--[[**
  * Team leader button OnClick script callback.
  *
  * self (Button) reference to the button that was clicked.
  * button (string) name of the mouse button responsible for the
  * click.
]]
onClick = function(self, button, down)
  local pInfo = ArenaLiveWarGameMenu:getCursorData();

  if (pInfo) then
    if (self.bTag) then
      ArenaLiveWarGameMenu:setCursorData(self.bTag);
    else
      ArenaLiveWarGameMenu:setCursorData(nil);
    end
    TeamLeaderButton.setPlayer(self, pInfo.bTag);
  end
end

--[[**
  * Team leader button OnDragStart script callback.
  *
  * self (Button) reference to the button that was dragged.
  * button (string) name of the mouse button responsible for the drag.
]]
onDragStart = function(self, button)
  if (self.bTag) then
    ArenaLiveWarGameMenu:setCursorData(bTag);
    TeamLeaderButton.reset(self);
  end
end
