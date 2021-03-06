ArenaLive.defaults = {
  map = nil,
  tournamentMode = true,
  useSmartCamera = false,
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
          showAbsorbs = true,
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
        CastBar = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "BOTTOMLEFT",
            relativePoint = "BOTTOMRIGHT",
            x = 34,
            y = 28,
          },
          width = 72,
          height = 24,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          font = "GameFontNormalSmall",
          hideTradeSkills = true,
        },
        ArenaLiveCastHistory = {
          enabled = true,
          anchor = {
            relativeTo = "CastBar",
            point = "TOPLEFT",
            relativePoint = "BOTTOMLEFT",
            x = -34,
            y = -4,
          },
          direction =
            DeliUnitFrames.classes.ArenaLiveCastHistory.Directions.RIGHT,
          duration = 7,
          iconSize = 24,
          height = 1,
          width = 1,
          numIcons = 4,
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
        ArenaLiveCrowdControlIcon = {
          enabled = true,
          anchor = {
            relativeTo = "ClassIcon",
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = 0,
          },
          size = 64,
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
          columns = 9,
          maxIndicators = 9,
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
          columns = 9,
          maxIndicators = 18,
          offset = 2,
          filter = "",
          iconSize = 20,
          showCooldownText = false,
        },
        NameText = {
          colorMode = DeliUnitFrames.classes.NameText.ColorModes.NONE,
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
          showAbsorbs = true,
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
        ArenaLiveCastHistory = {
          enabled = true,
          anchor = {
            relativeTo = "CastBar",
            point = "TOPRIGHT",
            relativePoint = "BOTTOMRIGHT",
            x = 0,
            y = -4,
          },
          direction =
            DeliUnitFrames.classes.ArenaLiveCastHistory.Directions.LEFT,
          duration = 7,
          iconSize = 24,
          height = 1,
          width = 1,
          numIcons = 4,
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
          columns = 9,
          maxIndicators = 9,
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
          columns = 9,
          maxIndicators = 18,
          offset = 2,
          filter = "",
          iconSize = 20,
          showCooldownText = false,
        },
        CastBar = {
          enabled = true,
          anchor = {
            relativeTo = "UnitFrame",
            point = "BOTTOMRIGHT",
            relativePoint = "BOTTOMLEFT",
            x = -4,
            y = 28,
          },
          width = 72,
          height = 24,
          texture = "Interface\\AddOns\\ArenaLive\\textures\\StatusBar",
          font = "GameFontNormalSmall",
          hideTradeSkills = true,
        },
        ArenaLiveCrowdControlIcon = {
          enabled = true,
          anchor = {
            relativeTo = "ClassIcon",
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = 0,
          },
          size = 64,
        },
        NameText = {
          colorMode = DeliUnitFrames.classes.NameText.ColorModes.NONE,
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
