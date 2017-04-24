ArenaLive.defaults = {
  map = nil,
  tournamentMode = true,
  teams = {
    left = {
      leader = nil,
      name = "Left Team",
      score = 0,
    },
    right = {
      leader = nil,
      name = "Right Team",
      score = 0,
    },
  },
  unitFrames = {
    left = {
      enabled = true,
      configMode = false,
      width = 182,
      height = 72,
      anchor = {
        point = "TOPLEFT",
        relativePoint = "TOPLEFT",
        x = 0,
        y = -46,
      },
      tooltip = DeliUnitFrames.classes.AbstractUnitFrame.TooltipModes.NEVER,
      leftClick = "target",
      rightClick = "togglemenu",
      components = {
        HealthBar = {
          enabled = true,
          anchor = {
            relativeTo = "ClassIcon",
            point = "TOPLEFT",
            relativePoint = "TOPRIGHT",
            x = 0,
            y = -16,
          },
          width = 110,
          height = 32,
          texture = "Interface\\TargetingFrame\\UI-StatusBar",
          colorMode = DeliUnitFrames.classes.HealthBar.ColorModes.CLASS,
        },
        PowerBar = {
          enabled = true,
          anchor = {
            relativeTo = "HealthBar",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = 0,
            y = 0,
          },
          width = 110,
          height = 16,
          texture = "Interface\\TargetingFrame\\UI-StatusBar",
        },
        ClassIcon = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPLEFT",
            relativePoint = "TOPLEFT",
            x = 4,
            y = -4,
          },
          width = 64,
          height = 64,
        },
        BuffFrame = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = 3,
            y = -3,
          },
          columns = 8,
          maxIndicators = 8,
          offset = 2,
          filter = "",
          iconSize = 20,
          showCooldownText = false,
        },
        DebuffFrame = {
          enabled = true,
          anchor = {
            relativeTo = "BuffFrame",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = 0,
            y = -2,
          },
          columns = 8,
          maxIndicators = 16,
          offset = 2,
          filter = "",
          iconSize = 20,
          showCooldownText = false,
        },
        CastBar = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "BOTTOMLEFT",
            relativePoint = "BOTTOMRIGHT",
            x = 26,
            y = 22,
          },
          width = 63,
          height = 21,
          texture = "Interface\\TargetingFrame\\UI-StatusBar",
          font = "GameFontNormalSmall",
          hideTradeSkills = true,
        },
        NameText = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPLEFT",
            relativePoint = "TOPLEFT",
            x = 72,
            y = -4,
          },
          width = 128,
          height = 12,
          font = "GameFontNormal",
        },
      },
    },
  },
};
