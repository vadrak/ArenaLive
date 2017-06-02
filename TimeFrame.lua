local TimeFrame = ArenaLiveTimeFrame;

--[[**
  * Initializes the timer frame, registering it for callbacks etc.
]]
function TimeFrame:init()
  self:SetScript("OnEvent", self.onEvent);
end
--[[**
  * Enables the time frame at the top of the screen.
]]
function TimeFrame:enable()
  self:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE");
end
--[[**
  * Disables the timer frame at the top of the screen.
]]
function TimeFrame:disable()
  self:UnregisterEvent("WORLD_STATE_UI_TIMER_UPDATE");
  self.text:SetText("00:00");
  self.index = nil;
end

--[[**
  * Time frame OnEvent script callback.
  *
  * @param event (string) the name of the event that was fired.
  * ... (mixed) an arbitrary amount of arguments accompanying the
  * event.
]]
function TimeFrame:onEvent(event, ...)
  if (not self.index) then
    self:updateTimerIndex();
  end

  local _, _, _, text = GetWorldStateUIInfo(self.index);
  text = string.match(text, "([0-9]+:[0-9]+)");
  self.text:SetText(text);
end

--[[**
  * Updates the timer's world state UI index variable.
]]
function TimeFrame:updateTimerIndex()
  local numStates = GetNumWorldStateUI();
  for i = 1, numStates, 1 do
    local uiType = GetWorldStateUIInfo(i);
    -- An UI type of 3 indicates timer frames.
    if (uiType == 3) then
      self.index = i;
      break;
    end
  end
end
