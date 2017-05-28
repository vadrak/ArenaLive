local HideUIButton = ArenaLiveHideUIButton;

--[[**
  * Initializes the button to hide the regular user interface.
  *
]]
function HideUIButton:init()
  local name = self:GetName();
  local text = _G[name .. "Text"];
  text:SetText("Hide UI");

  local width = text:GetWidth() + 30;
  self:SetWidth(width);

  self:RegisterForClicks("LeftButtonUp");
  self:SetScript("OnClick", self.onClick);
end

--[[**
  * Enables the hide UI button, showing it on the regular user
  * interface.
]]
function HideUIButton:enable()
  self:Enable();
  self:Show();
end
--[[**
  * Disables the hide UI button, hiding it from the regular user
  * interface.
]]
function HideUIButton:disable()
  self:Disable();
  self:Hide();
end

--[[**
  * Button's OnClick script callback.
]]
function HideUIButton:onClick(button, down)
  UIParent:Hide();
end
