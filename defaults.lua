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
      width = 202,
      height = 68,
      anchor = {
        point = "TOPLEFT",
        relativeTo="ArenaLiveLeftFrames",
        relativePoint = "TOPLEFT",
        x = 0,
        y = 0,
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
            x = 6,
            y = 0,
          },
          width = 128,
          height = 38,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          colorMode = DeliUnitFrames.classes.HealthBar.ColorModes.CLASS,
        },
        PowerBar = {
          enabled = true,
          anchor = {
            relativeTo = "HealthBar",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = 0,
            y = -6,
          },
          width = 128,
          height = 20,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
        },
        ClassIcon = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPLEFT",
            relativePoint = "TOPLEFT",
            x = 2,
            y = -2,
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
            x = 0,
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
            x = 22,
            y = 26,
          },
          width = 63,
          height = 21,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          font = "GameFontNormalSmall",
          hideTradeSkills = true,
        },
        NameText = {
          enabled = true,
          realmMode = DeliUnitFrames.classes.NameText.RealmModes.NONE,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPLEFT",
            relativePoint = "TOPLEFT",
            x = 74,
            y = -4,
          },
          width = 128,
          height = 12,
          font = "GameFontNormal",
        },
      },
    },
    right = {
      enabled = true,
      configMode = false,
      width = 202,
      height = 68,
      anchor = {
        point = "TOPLEFT",
        relativeTo="ArenaLiveRightFrames",
        relativePoint = "TOPLEFT",
        x = 0,
        y = 0,
      },
      tooltip = DeliUnitFrames.classes.AbstractUnitFrame.TooltipModes.NEVER,
      leftClick = "target",
      rightClick = "togglemenu",
      components = {
        HealthBar = {
          enabled = true,
          anchor = {
            relativeTo = "ClassIcon",
            point = "TOPRIGHT",
            relativePoint = "TOPLEFT",
            x = -6,
            y = 0,
          },
          width = 128,
          height = 38,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          colorMode = DeliUnitFrames.classes.HealthBar.ColorModes.CLASS,
        },
        PowerBar = {
          enabled = true,
          anchor = {
            relativeTo = "HealthBar",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = 0,
            y = -6,
          },
          width = 128,
          height = 20,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
        },
        ClassIcon = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPRIGHT",
            relativePoint = "TOPRIGHT",
            x = -2,
            y = -2,
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
            x = 0,
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
            x = 22,
            y = 26,
          },
          width = 63,
          height = 21,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          font = "GameFontNormalSmall",
          hideTradeSkills = true,
        },
        NameText = {
          enabled = true,
          realmMode = DeliUnitFrames.classes.NameText.RealmModes.NONE,
          anchor = {
            relativeTo = "UnitFrame",
            point = "TOPRIGHT",
            relativePoint = "TOPRIGHT",
            x = -74,
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
