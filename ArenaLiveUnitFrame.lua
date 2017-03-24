local UnitFrame = DeliUnitFrames:newClass("ArenaLiveUnitFrame",
  "AbstractUnitFrame");
ArenaLive.UnitFrame = UnitFrame;

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
end
