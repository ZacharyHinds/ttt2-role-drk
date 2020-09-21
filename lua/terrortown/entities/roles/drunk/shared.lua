AddCSLuaFile()

if SERVER then
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_spr.vmt")
end

function ROLE:PreInitialize()
  self.color = Color(26, 188, 156, 255)

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

function SetDrunkTeam(ply)
  if ply:GetSubRole() ~= ROLE_DRUNK then return end
  ply:SetNWBool("DrunkAwake", false)
  local teams = roles.GetAvailableTeams()
  local new_team
  repeat
    if #teams <= 0 then
      ply:UpdateTeam(TEAM_INNOCENT)
      return
    end
    local rnd = math.random(#teams)
    new_team = teams[rnd]
    table.remove(teams, rnd)
  until #roles.GetTeamMembers(new_team) > 0
  ply:UpdateTeam(new_team)
end

if SERVER then
  hook.Add("TTTBeginRound", "TTTDrunkTeam", function()
    timer.Simple(0.5, function()
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        SetDrunkTeam(plys[i])
      end
    end)
  end)

  hook.Add("TTT2UpdateSubrole", "DrunkRoleChange", function(ply, old, new)
    timer.Simple(0.5, function()
      if new == ROLE_DRUNK then
        SetDrunkTeam(ply)
      end
    end)
  end)
end
