--[[**
  * Stores and displays up to the last ten spells that a unit cast.
  *
  * TODO: Automatically update version number on commit.
]]
local addonName, L = ...;
local version = 20170617;
local CastHistory = DeliUnitFrames:getClass("ArenaLiveCastHistory");
if (CastHistory and CastHistory.version >= version) then
  -- A more recent version has been loaded already.
  return; 
end
CastHistory = DeliUnitFrames:newClass("ArenaLiveCastHistory",
  "AbstractScriptComponent");

local MAX_CACHE_SIZE = 10;
local newCacheEntry, resetCacheEntry, castIterator, fadeAnimationOnFinish; -- private functions
CastHistory.version = version;
CastHistory.Directions = { -- Enum for directions
  UPWARDS = 1,
  RIGHT = 2,
  DOWNWARDS = 3,
  LEFT = 4,
};
CastHistory.defaults = {
  direction = CastHistory.Directions.RIGHT;
  iconSize = 20,
  numIcons = 4,
  duration = 7,
};

--[[**
  * Initializes this cast history component handler. Registering
  * necessary scripts and events, aswell as adding basic attributes.
  *
  * @param manager (UnitFrameManager) the unit frame manager object
  * that is used to access all unit frames which's cast histories
  * will be managed by this cast history instance.
  * @see AbstractScriptComponent.
]]
function CastHistory:init(manager)
  CastHistory:getSuper().init(self, manager);

  self.cache = {};
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
  self:RegisterEvent("UNIT_NAME_UPDATE");
  self:RegisterEvent("PLAYER_TARGET_CHANGED");
  self:RegisterEvent("PLAYER_FOCUS_CHANGED");
  self:SetScript("OnEvent");
end

--[[**
  * Returns a new cast history UI instance that is then added to
  * unitFrame.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame to which
  * the cast history is going to be added.
  * @return (CastHistory) a new cast history.
]]
function CastHistory:newUIElement(unitFrame)
  local settings = self:getSettings(unitFrame);
  local name = unitFrame.frame:GetName() or tostring(unitFrame);
  name = name .. self:getType();
  local history = CreateFrame("Frame", name, unitFrame.frame);
  history.icons = {};

  return history;
end

--[[**
  * Updates the unitFrame's cast history to show the last casts of
  * the unit that unitFrame currently displays.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame that's cast
  * history is going to be updated.
]]
function CastHistory:update(unitFrame)
  local settings = self:getSettings(unitFrame);
  local history = self:getUIElement(unitFrame);
  if (not history) then
    return;
  elseif (not unitFrame.unit) then
    self:reset(unitFrame);
    return;
  end
  local index = 1;
  local curTime = GetTime();
  for id, spellID, texture, timeCast in self:getIterator(unitFrame.unit) do
    local icon = history.icons[id];
    local remDuration = (timeCast + settings.duration) - curTime;
    if (id > settings.numIcons) then
      break;
    elseif (remDuration <= 0) then
      break;
    end

    icon.fadeOutAnim:Stop();
    icon.spellID = spellID;
    icon.texture:SetTexture(texture);
    icon:Show();
    icon.fadeOutAnim.alpha:SetStartDelay(remDuration);
    icon.fadeOutAnim:Play();
    index = index + 1;
  end

  while (index <= #history.icons) do
    local icon = history.icons[index];
    icon:Hide();
    index = index + 1;
  end
end

--[[**
  * Updates unitFrame's cast history according to its current saved
  * variable settings.
  *
  * @param unitFrame (AbstractUnitFrame) the unit frame that's cast
  * history is going to be updated.
]]
function CastHistory:updateAppearance(unitFrame)
  self:getSuper().updateAppearance(self, unitFrame);

  local history = self:getUIElement(unitFrame);
  local settings = self:getSettings(unitFrame);
  if (settings.direction == CastHistory.Directions.UPWARDS
    or CastHistory.Directions.DOWNWARDS) then
    history:SetSize((settings.iconSize + 2) * settings.numIcons,
      settings.iconSize);
  else
    history:SetSize(settings.iconSize,
      (settings.iconSize + 2) * settings.numIcons);
  end

  local prefix = history:GetName();
  for i = 1, settings.numIcons, 1 do
    local icon = history.icons[i];
    if (not icon) then
      icon = CreateFrame("Button", prefix .. "Button" .. i,
        history, "ArenaLiveCastHistoryIconTemplate");

      icon.fadeOutAnim:SetScript("OnFinished", fadeAnimationOnFinish);
      history.icons[i] = icon;
    end

    icon:SetSize(settings.iconSize, settings.iconSize);
    icon:ClearAllPoints();
    local point, relativeTo, relativePoint, x, y;
    relativeTo = history.icons[i-1];
    if (settings.direction == CastHistory.Directions.UPWARDS) then
      point = "BOTTOM";
      relativePoint = "TOP";
      x = 0;
      y = 2;
    elseif (settings.direction == CastHistory.Directions.RIGHT) then
      point = "LEFT";
      relativePoint = "RIGHT";
      x = 2;
      y = 0;
    elseif (settings.direction == CastHistory.Directions.DOWNWARDS) then
      point = "TOP";
      relativePoint = "BOTTOM";
      x = 0;
      y = -2;
    else
      point = "RIGHT";
      relativePoint = "LEFT";
      x = -2;
      y = 0;
    end
    if (i == 1) then
      relativeTo = history;
      relativePoint = point;
    end
    icon:SetPoint(point, relativeTo, relativePoint, x, y);
  end

  for i = settings.numIcons+1, #history.icons, 1 do
    history.icons[i]:Hide();
  end
end

--[[**
  * Reset unitFrame's cast history, hiding all icons.
  *
  * @param AbstractUnitFrame (UnitFrame) The unit frame that's cast
  * history is going to be reset.
]]
function CastHistory:reset(unitFrame)
  local history = self:getUIElement(unitFrame);
  if (not history) then
    return;
  end
  for i = 1, #history.icons, 1 do
    local icon = history.icons[i];
    icon.fadeOutAnim:Stop();
    icon:Hide();
  end
end

--[[**
  * Returns a stateless iterator that may be used in a generic for
  * loop to traverse all recently cast spells by unit.
  *
  * @param unit (string) name of the unit which's recently cast
  * spells will be returned.
  * @return (iterator, table, nil) an stateless iterator function that
  * may be used to traverse unit's recent spell casts.
]]
function CastHistory:getIterator(unit)
  if (not self.cache[unit]) then
    return castIterator, nil, nil;
  end

  return castIterator, self.cache[unit], nil;
end

--[[**
  * OnEvent script callback.
  *
  * @param event (string) name of the event that was triggered.
  * @param ... (mixed) a number of arguments accompanying the event.
]]
function CastHistory:OnEvent(event, ...)
  local unit, _, _, _, spellID = ...;
  if (event == "UNIT_SPELLCAST_SUCCEEDED") then
    self:addCast(unit, spellID);
  else
    if (event == "PLAYER_TARGET_CHANGED") then
      unit = "target";
    elseif (event == "PLAYER_FOCUS_CHANGED") then
      unit = "focus";
    end

    resetCacheEntry(self.cache, unit);
  end

  for unitFrame in self.manager:getUnitIterator(unit) do
    self:update(unitFrame);
  end
end

--[[**
  * Adds the given cast to unit's cache entry of this cast history's
  * cache.
  *
  * @param unit (string) the unit id to which's cache entry the cast
  * is being written.
  * @param spellID (number) the spellID of the cast that is going to
  * be added to unit's cache entry.
]]
function CastHistory:addCast(unit, spellID)
  local name, _, texture = GetSpellInfo(spellID);
  if (not name) then
    return; -- Ignore invalid spells.
  end

  local entry = self.cache[unit];
  if (not entry) then
    entry = newCacheEntry(self.cache, unit);
  end

  if (not entry[entry.writeIndex]) then
    entry[entry.writeIndex] = {};
  end

  local spell = entry[entry.writeIndex];
  spell.ID = spellID;
  spell.texture = texture;
  spell.time = GetTime();

  entry.writeIndex = (entry.writeIndex + 1) % MAX_CACHE_SIZE;
end

--[[**
  * Creates and returns unit's cast history cache entry in cache.
  * If there already exists a cache entry for the given unit, the
  * already existing table is returned instead and no cache entry is
  * created.
  *
  * @param cache (table) the cache table to which a new entry is
  * being added.
  * @param unit (string) the unit ID for which a new cache entry is
  * being added to cache.
]]
function newCacheEntry(cache, unit)
  if (not cache[unit]) then
    cache[unit] = {
      writeIndex = 0;
    };
  end

  return cache[unit];
end

--[[**
  * Resets unit's cache entry in cache, removing all spell data from
  * the entry's sub tables.
  *
  * @param cache (table) the cache table of the affected CastHistory
  * object.
  * @param unit (string) unit id of the player who's cache data is
  * going to be reset.
]]
function resetCacheEntry(cache, unit)
  local ent = cache[unit];
  if (not ent) then
    return;
  end

  for i = 1, MAX_CACHE_SIZE, 1 do
    local spell = ent[i];
    if (spell) then
      spell.ID = nil;
      spell.texture = nil;
      spell.time = nil;
    end
  end
  ent.writeIndex = 0;
end

--[[**
  * Iterates all entries in casts, ordered in descending order by the
  * time they were cast, that is, the youngest cast is returned first
  * and the oldest cast is returned last.
  *
  * @param casts (table) a cast history cache entry of a specific 
  * player.
  * @param lastID (number) the last cache entry's id that was returned.
  * return (number, number, string, number) the current cache entries
  * id, the cast's spellID, the cast's texture and the time the spell
  * was cast.
]]
function castIterator(casts, lastID)
  if (not casts) then
    return nil;
  end
  local id;
  if (not lastID) then
    id = 1;
  else
    id = lastID + 1;
  end

  if (id >= MAX_CACHE_SIZE) then
    return nil;
  end

  local index = casts.writeIndex - id;
  if (index < 0) then
    index = MAX_CACHE_SIZE + index;
  end

  local spell = casts[index];
  if (not spell or not spell.ID) then
    return nil;
  end

  return id, spell.ID, spell.texture, spell.time;
end

function fadeAnimationOnFinish(animGroup, requested)
  local icon = animGroup:GetParent();
  icon:Hide();
end
