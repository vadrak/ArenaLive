--[[**
  * Contains all functions to implement ArenaLive's slash commands.
  *
  * @author Harald Böhm <harald@boehm.agency>
]]
local addonName, L = ...;
SLASH_ARENALIVE1, SLASH_ARENALIVE2 = "/alive", "/arenalive";
function SlashCmdList.ARENALIVE(msg, editBox)
  if (not msg or msg == "") then
    ArenaLiveWarGameMenu:Show();
  end
end
