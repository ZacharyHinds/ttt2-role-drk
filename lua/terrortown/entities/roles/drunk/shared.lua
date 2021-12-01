CreateConVar("ttt2_drk_delay_max", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_delay_min", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_drk.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(214, 159, 30, 255)

  self.abbr = "drk" -- abbreviation
  self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 1 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
  self.unknownTeam = true -- player don't know their teammates

  self.defaultTeam = TEAM_NONE -- the team name: roles with same team name are working together
  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment

  self.conVarData = {
    pct = 0.15, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
  }
end

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    form:MakeSlider({
      serverConvar = "ttt2_drk_delay_min",
      label = "label_ttt2_drk_delay_min",
      min = 1,
      max = 60,
      decimal = 0
    })

    form:MakeSlider({
      serverConvar = "ttt2_drk_delay_max",
      label = "label_ttt2_drk_delay_max",
      min = 1,
      max = 60,
      decimal = 0
    })

  end
end