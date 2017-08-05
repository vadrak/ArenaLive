local UnitFrame = DeliUnitFrames:newClass("ArenaLiveUnitFrame",
  "AbstractUnitFrame");
ArenaLive.UnitFrame = UnitFrame;

local onEvent; -- private functions

--[[**
  * @Override
  * Initializes this ArenaLiveUnitFrame object.
  *
  * @param id (number) the unit frame's id. This will be used to determine
  * its position on the user interface.
]]
function UnitFrame:init(id, group, frameType, name, parent, template, unit)
  self.id = id;
  self:getSuper().init(self, group, frameType, name, parent, template, unit);
  if (group == "left") then
    ArenaLive.leftFrames[id] = self;
  elseif (group == "right") then
    ArenaLive.rightFrames[id] = self;
  else
    error("Error in ArenaLiveUnitFrame:init(): Invalid frame group " ..
      group .. ".");
  end
  self.frame:SetScript("OnEvent",
    function(frame, event, ...) onEvent(self, event,...)end);
  self.frame:RegisterEvent("PLAYER_TARGET_CHANGED");
end


--[[**
  * @Override
  *
  * @see AbstractUnitFrame
]]
function UnitFrame:getDatabase()
  return ArenaLive.db.unitFrames;
end

--[[**
  * @Override
  * Updates this unit frame's appearance according to its settings.
]]
function UnitFrame:updateAppearance()
  self:getSuper().updateAppearance(self);
  local settings = self:getSettings();
  local anchor = settings.anchor;

  --[[
    * We have to reanchor frames, since DeliUnitFrames currently
    * anchors all frames with the same group at the exact same
    * position.
  ]]
  if (self.id <= 1) then
    return; -- The first frame is already anchored correctly.
  end

  self.frame:ClearAllPoints();
  local relativeTo;
  if (self.group == "left") then
    relativeTo = ArenaLive.leftFrames[self.id - 1].frame;
  else
    relativeTo = ArenaLive.rightFrames[self.id - 1].frame;
  end
  self.frame:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, -64);
end

--[[
  * ArenaLive's unit frame OnEvent script callback. We use this to
  * reduce a unit frame's alpha, if it is not the spectator's target.
]]
function onEvent(unitFrame, event, ...)
  if (event == "PLAYER_TARGET_CHANGED") then
    if (not unitFrame.enabled) then
      return;
    end
    if (UnitIsUnit(unitFrame.unit, "target")) then
      unitFrame.frame:SetAlpha(1);
    else
      unitFrame.frame:SetAlpha(0.65);
    end
  end
end
