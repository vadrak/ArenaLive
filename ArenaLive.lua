--[[**
  * ArenaLive is a user interface for starting and spectating arena
  * war games.
  *
  * Copyright (c) 2017 Harald Böhm

  * Permission is hereby granted, free of charge, to any person
  * obtaining a copy of this software and associated documentation
  * files (the "Software"),to deal in the Software without restriction,
  * including without limitation the rights to use, copy, modify,
  * merge, publish, distribute, sublicense, and/or sell copies of the
  * Software, and to permit persons to whom the Software is furnished
  * to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be
  * included in all copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
]]
local addonName, L = ...;
local ArenaLive = ArenaLive;
ArenaLive.MAX_PLAYERS = 3;

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
  * Returns ArenaLive's saved variables table.
  *
  * @return (table) ArenaLive's saved variable table.
]]
function ArenaLive:getDatabase()
  return self.db;
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

  --[[
    * We have to change the name text's parent, otherwise it
    * would be hidden behind the player's health bar.
    ]]
  local nt = frame.components.NameText;
  nt:SetParent(frame.components.HealthBar);
end

ArenaLive:init();
