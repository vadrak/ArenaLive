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
  self.NameText = DeliUnitFrames.classes.NameText:new(ufm);
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

  ArenaLiveWarGameMenu:init();

  for i = 1, self.MAX_PLAYERS, 1 do
    self:createUnitFrame(i, "left");
    self:createUnitFrame(i, "right");
  end

end

--[[**
  * Creates a single unit frame with the given id on the given side.
  *
  * @param id (number) the frame's id on its side.
  * @param side (string) the side to which the frame is added, may be
  * "left" or "right".
]]
function ArenaLive:createUnitFrame(id, side)
  local parent;
  if (side == "left") then
    parent = self.leftFrames;
  else
    parent = self.rightFrames;
  end
  local name = parent:GetName() .. "Frame" .. tostring(id);
  local frame = self.UnitFrame:new(id, side, "Button", name, parent,
  "ArenaLiveUnitFrameTemplate", "player");

  self.UnitFrameManager:addFrame(frame);
  self.ClassIcon:addToFrame(frame);
  self.HealthBar:addToFrame(frame);
  self.PowerBar:addToFrame(frame);
  self.BuffFrame:addToFrame(frame);
  self.DebuffFrame:addToFrame(frame);
  self.CastBar:addToFrame(frame);
  self.NameText:addToFrame(frame);

  local nt = frame.components.NameText;
  nt:SetParent(ArenaLiveTestFrameBorder:GetParent());
end

--[[**
  * Returns ArenaLive's saved variables table.
  *
  * @return (table) ArenaLive's saved variable table.
]]
function ArenaLive:getDatabase()
  return self.db;
end

ArenaLive:init();
