assert(DeliUnitFrames, "ArenaLive requires DeliUnitFrames.");

local addonName, L = ...;
local ArenaLive = ArenaLive;

--[[**
  * Initializes the addon's base frame, setting script handlers and
  * registering all necessary events.
]]
function ArenaLive:init()
  self:SetScript("OnEvent", self.onEvent);
  self:RegisterEvent("ADDON_LOADED");

end

--[[**
  * OnEvent script handler for ArenaLive.
  *
  * @param event (string) the name of the event that fired.
  * @param ... (mixed) a arbitrary number of arguments accompanying
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
    ArenaLiveDB = {};
  end

  self.db = ArenaLiveDB;
end

ArenaLive:init();
