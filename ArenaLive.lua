local addonName, L = ...;
local ArenaLive = ArenaLive;

assert(DeliUnitFrames, "ArenaLive requires DeliUnitFrames.");

--[[**
  * Initializes the addon, setting script handlers, registering
  * necessary events and creating required class instances.
]]
function ArenaLive:init()
  self:SetScript("OnEvent", self.onEvent);
  self:RegisterEvent("ADDON_LOADED");
  self.UnitFrameManager = DeliUnitFrames.classes.UnitFrameManager:new();

  local ufm = self.UnitFrameManager;
  self.HealthBar = DeliUnitFrames.classes.HealthBar:new(ufm);
  self.PowerBar = DeliUnitFrames.classes.PowerBar:new(ufm);
  self.ClassIcon = DeliUnitFrames.classes.ClassIcon:new(ufm);
  self.BuffFrame = DeliUnitFrames.classes.BuffFrame:new(ufm);
  self.DebuffFrame = DeliUnitFrames.classes.DebuffFrame:new(ufm);
  self.CastBar = DeliUnitFrames.classes.CastBar:new(ufm, nil);
end

--[[**
  * OnEvent script handler for ArenaLive.
  *
  * @param event (string) the name of the event that fired.
  * @param ... (mixed) an arbitrary number of arguments accompanying
  * the event.
]]
function ArenaLive:onEvent(event, ...)
  local arg1 = ...;
  if (event == "ADDON_LOADED" and arg1 == addonName) then
    self:onAddonLoaded();
  end
end

--[[**
  * Sets up ArenaLive after its saved variables have been loaded by
  * the World of Warcraft client.
]]
function ArenaLive:onAddonLoaded()
  if (not ArenaLiveDB) then
    ArenaLiveDB = ArenaLive.defaults;
  end

  self.db = ArenaLiveDB;

  -- Create a test frame
  local frame = self.UnitFrame:new("left", nil, "ArenaLiveTestFrame",
    self, "ArenaLiveUnitFrameTemplate", "target");
  self.UnitFrameManager:addFrame(frame);
  self.ClassIcon:addToFrame(frame);
  self.HealthBar:addToFrame(frame);
  self.PowerBar:addToFrame(frame);
  self.BuffFrame:addToFrame(frame);
  self.DebuffFrame:addToFrame(frame);
  self.CastBar:addToFrame(frame);
end

ArenaLive:init();
