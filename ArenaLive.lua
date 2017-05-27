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
  self:RegisterEvent("UPADTE_BATTLEFIELD_STATUS");
  self.UnitFrameManager = DeliUnitFrames.classes.UnitFrameManager:new();

  local ufm = self.UnitFrameManager;
  self.HealthBar = DeliUnitFrames.classes.HealthBar:new(ufm);
  self.PowerBar = DeliUnitFrames.classes.PowerBar:new(ufm);
  self.ClassIcon = DeliUnitFrames.classes.ClassIcon:new(ufm);
  self.BuffFrame = DeliUnitFrames.classes.BuffFrame:new(ufm);
  self.DebuffFrame = DeliUnitFrames.classes.DebuffFrame:new(ufm);
  self.CastBar = DeliUnitFrames.classes.CastBar:new(ufm, nil);
  self.NameText = DeliUnitFrames.classes.NameText:new(ufm);

  self.timeFrame:init();
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
  elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
    local status = GetBattlefieldStatus(arg1);
    local winner = GetBattlefieldWinner();
    local inInstance, instanceType = IsInInstance();
    local spectator = (C_Commentator.GetMode() > 0
      and instanceType == "arena");

    if (status == "active" and arg1 == self.bfSID and winner) then
      self:disable();
    elseif (status == "active" and spectator) then
        self:enable(arg1);
    elseif (status == "none" and arg1 == self.bfSID) then
      self:disable();
    end
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

  self:disable();
end

--[[**
  * Enables the spectator user interface, hiding all regular UI
  * elements.
  *
  * @param bfSID (number) the battlefield status ID of the currently
  * spectated arena.
]]
function ArenaLive:enable(bfSID)
  self.bfSID = bfID;

  UIParent:Hide();
  for i = 1, self.MAX_PLAYERS, 1 do
    local frame = self.leftFrames[i];
    frame:enable();
    frame:setUnit("spectateda" .. i);

    frame = self.rightFrames[i];
    frame:enable();
    frame:setUnit("spectatedb" .. i);
  end
  self.timeFrame:enable();
  self:Show();
  local db = self:getDatabase();

  C_Commentator.SetUseSmartCamera(db.useSmartCamera);
  C_Commentator.SetSmartCameraLocked(db.useSmartCamera);
  self.enabled = true;
end
--[[**
  * Disables the spectator user interface and show all regular UI
  * elements instead.
]]
function ArenaLive:disable()
  for i = 1, self.MAX_PLAYERS, 1 do
    self.leftFrames[i]:disable();
    self.rightFrames[i]:disable();
  end

  self:Hide();
  self.timeFrame:disable();
  UIParent:Show();
  self.enabled = false;
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
  local template;
  local unit;
  if (side == "left") then
    parent = self.leftFrames;
    template = "ArenaLiveLeftUnitFrameTemplate";
    unit = "spectateda" .. id;
  else
    parent = self.rightFrames;
    template = "ArenaLiveRightUnitFrameTemplate";
    unit = "spectatedb" .. id;
  end
  local name = parent:GetName() .. "Frame" .. tostring(id);
  local frame = self.UnitFrame:new(id, side, "Button", name, parent,
    template, unit);

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
