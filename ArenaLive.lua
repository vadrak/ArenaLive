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
local DEBUG_UNITS = {
  "player",
  "target",
  "focus",
}
assert(DeliUnitFrames, "ArenaLive requires DeliUnitFrames.");

--[[**
  * Initializes the addon, setting script handlers, registering
  * necessary events and creating required class instances.
]]
function ArenaLive:init()
  self:SetScript("OnEvent", self.onEvent);
  self:RegisterEvent("ADDON_LOADED");
  self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
  self:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");

  self.timeFrame:init();
  ArenaLiveHideUIButton:init();
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
  elseif (event == "COMMENTATOR_PLAYER_UPDATE") then
    --[[
      * This event does not mean that all relevant player information
      * has been loaded, but just that the commentator system has
      * added a new player. That is why we use a timer callback here,
      * this should give the client enough time to load all data we
      * need to update our unit frames correctly.
    ]]
    C_Timer.After(2, function() self:updateUnitFrames()end);
  elseif (event == "PLAYER_TARGET_CHANGED") then
    C_Commentator.FollowUnit("target");
  elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
    local status = GetBattlefieldStatus(arg1);
    local winner = GetBattlefieldWinner();
    local inInstance, instanceType = IsInInstance();
    local spectator = (C_Commentator.GetMode() > 0
      and instanceType == "arena");

    if ((status == "active" and arg1 == self.bfSID and winner)
        or (status == "none" and arg1 == self.bfSID)) then
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

  local ufm = DeliUnitFrames.classes.UnitFrameManager:new();
  self.UnitFrameManager = ufm;
  self.HealthBar = DeliUnitFrames.classes.HealthBar:new(ufm);
  self.PowerBar = DeliUnitFrames.classes.PowerBar:new(ufm);
  self.ClassIcon = DeliUnitFrames.classes.ClassIcon:new(ufm);
  self.BuffFrame = DeliUnitFrames.classes.BuffFrame:new(ufm);
  self.DebuffFrame = DeliUnitFrames.classes.DebuffFrame:new(ufm,
    "ArenaLiveDebuffTemplate");
  self.CastBar = DeliUnitFrames.classes.CastBar:new(ufm,
    "ArenaLiveCastBarTemplate");
  self.CastHistory = DeliUnitFrames.classes.ArenaLiveCastHistory:new(ufm);
  self.CCIcon = DeliUnitFrames.classes.ArenaLiveCrowdControlIcon:new(ufm);
  self.NameText = DeliUnitFrames.classes.NameText:new(ufm);

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
  self.bfSID = bfSID;

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
  ArenaLiveHideUIButton:enable();
  self:Show();
  local db = self:getDatabase();

  C_Commentator.SetUseSmartCamera(db.useSmartCamera);
  C_Commentator.SetSmartCameraLocked(db.useSmartCamera);
  self.enabled = true;
  self:RegisterEvent("PLAYER_TARGET_CHANGED");
end

--[[**
  * Toggles ArenaLive's debug mode, activating/deactivating the
  * spectator interface outside of spectated war games and setting
  * all unit frames to display either the player, target or focus.
]]
function ArenaLive:debug()
  if (not self.debugEnabled) then
    for i = 1, self.MAX_PLAYERS, 1 do
      local frame = self.leftFrames[i];
      frame:enable();
      frame:setUnit(DEBUG_UNITS[i]);

      frame = self.rightFrames[i];
      frame:enable();
      frame:setUnit(DEBUG_UNITS[i]);
    end

    ArenaLiveHideUIButton:enable();
    UIParent:Hide();
    self:Show();
    self.debugEnabled = true;
  else
    self:disable();
    self.debugEnabled = false;
  end
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
  ArenaLiveHideUIButton:disable();
  UIParent:Show();
  self:UnregisterEvent("PLAYER_TARGET_CHANGED");
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
  self.CCIcon:addToFrame(frame);
  self.HealthBar:addToFrame(frame);
  self.PowerBar:addToFrame(frame);
  self.BuffFrame:addToFrame(frame);
  self.DebuffFrame:addToFrame(frame);
  self.CastBar:addToFrame(frame);
  self.CastHistory:addToFrame(frame);
  self.NameText:addToFrame(frame);

  --[[
    * We have to change the name text's parent, otherwise it
    * would be hidden behind the player's health bar.
    ]]
  local nt = frame.components.NameText.element;
  nt:SetParent(frame.components.HealthBar.element);
end

--[[**
  * Updates all of ArenaLive's unit frames.
]]
function ArenaLive:updateUnitFrames()
  for i = 1, self.MAX_PLAYERS, 1 do
    self.leftFrames[i]:update();
    self.rightFrames[i]:update();
  end
end
ArenaLive:init();
