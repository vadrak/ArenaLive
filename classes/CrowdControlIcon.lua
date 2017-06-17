--[[**
  * Displays a player's crowd control spells.
]]
local addonName, L = ...;
local version = 20170616;
local CCIcon = DeliUnitFrames:getClass("ArenaLiveCrowdControlIcon");
if (CCIcon and version >= CCIcon.version) then
  return; -- More recent version has been loaded already
end
CCIcon = CCIcon or DeliUnitFrames:newClass("ArenaLiveCrowdControlIcon",
  "AbstractComponent");
CCIcon.defaults = {
  size = 64,
};
local DeliCrowdControl = DeliCrowdControl;
local CC_TYPES = DeliCrowdControl.Types;
local CC_PRIORITIES = {
  CC_TYPES.DEFENSE,
  CC_TYPES.STUN,
  CC_TYPES.CC,
  CC_TYPES.SILENCE,
  CC_TYPES.ROOT,
  CC_TYPES.EMPOWER,
}

local onEvent; -- private functions

--[[**
  * Initializes this CCIcon object registering it for necessary
  * callbacks.
  *
  * @param manager (UnitFrameManager) unit frame manager that is used
  * to access all unit frames which should be managed by this crowd
  * control icon instance.
]]
function CCIcon.init(self, manager)
  self:getSuper().init(self, manager);

  DeliCrowdControl.registerCallback(self, onEvent);
end

--[[**
  * Creates and returns a user interface crowd control icon that will
  * be attached to unitFrame.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame to which the
  * newly constructed crowd control icon is going to be attached.
]]
function CCIcon.newUIElement(self, unitFrame)
  local name = unitFrame.frame:GetName() or tostring(unitFrame);
  name = name .. self:getType();

  local icon = CreateFrame("Frame", name, unitFrame.frame,
    "ArenaLiveCrowdControlIconTemplate");

  return icon;
end

--[[**
  * Updates unitFrame's crowd control icon to display the players
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame that's crowd
  * control icon is going to be updated.
]]
function CCIcon.update(self, unitFrame)
  local icon = self:getUIElement(unitFrame);
  local unit = unitFrame.unit;
  if (not icon) then
    return;
  elseif (not unit) then
    self:reset(unitFrame);
    return;
  end

  local ccData = DeliCrowdControl.getUnitCC(unit);
  if (not ccData) then
    self:reset(unitFrame);
    return;
  end
  local _, spellID, texture, duration, expires;
  for _, ccType in ipairs(CC_PRIORITIES) do
    _, spellID, texture, duration, expires = ccData:getCC(ccType);
    if (spellID) then
      break;
    end
  end
  if (spellID) then
    icon.cd:SetCooldown(expires-duration, duration);
    icon.texture:SetTexture(texture);
    icon:Show();
  else
    self:reset(unitFrame);
  end
end
--[[**
  * Updates unitFrame's crowd control icon's display to reflect the
  * current saved variable settings.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame that's crowd
  * control icon's appearance is going to be updated.
]]
function CCIcon.updateAppearance(self, unitFrame)
  local icon = self:getUIElement(unitFrame);
  if (not icon) then
    return;
  end

  self:getSuper().updateAppearance(self, unitFrame);

  local settings = self:getSettings(unitFrame);
  icon:SetSize(settings.size, settings.size);
end

--[[**
  * Reset unitFrame's crowd control icon, hiding it.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame that's crowd
  * control icon is going to be reset.
]]
function CCIcon.reset(self, unitFrame)
  local icon = self:getUIElement(unitFrame);
  if (not icon) then
    return;
  end

  icon.cd:SetCooldown(0,0);
  icon.texture:SetTexture();
  icon:Hide();
end

--[[**
  * Callback function for DeliCrowdControl's callback handler.
  *
  * @param ccIcon (ArenaLiveCrowdControlIcon) the ccIcon object for
  * which the function is called.
  * @param event (string) name of the event that fired.
  * @param unit (string) unit id of the player for which the callback
  * was triggered.
]]
function onEvent(ccIcon, event, unit)
  for unitFrame in ccIcon.manager:getUnitIterator(unit) do
    ccIcon:update(unitFrame);
  end
end
