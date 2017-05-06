local UnitFrame = DeliUnitFrames:newClass("ArenaLiveUnitFrame",
  "AbstractUnitFrame");
ArenaLive.UnitFrame = UnitFrame;

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
    error(
      "Error in ArenaLiveUnitFrame:init(): Invalid frame group "
      .. group .. ".");
  end
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
