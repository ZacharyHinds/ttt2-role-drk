util.AddNetworkString("ttt2_drk_remembers")
util.AddNetworkString("ttt2_drk_sober")

local function NotifyEveryoneElse(drunk)
  -- if not GetConVar("ttt2_drk_notify"):GetBool() then return end
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    local ply = plys[i]
    if ply == drunk then continue end
    net.Start("ttt2_drk_sober")
    net.Broadcast()
  end
end

local function DrunkSobers(ply)
  if not IsValid(ply) or not ply:IsPlayer() then return end
  if not ply:Alive() or ply:IsSpec() or ply:GetSubRole() ~= ROLE_DRUNK then return end
  if ply:GetNWBool("DrunkSober") then return end
  local teaminfo = {
    team = ply:GetTeam(),
    color = nil,
    doNotify = true
  }
  teaminfo.color = TEAMS[teaminfo.team].color
  teaminfo = hook.Run("TTT2DrunkAwaken", ply, teaminfo) or teaminfo
  ply:SetNWBool("DrunkSober", true)
  if teaminfo.doNotify then
    net.Start("ttt2_drk_remembers")
    net.WriteString(teaminfo.team)
    net.WriteColor(teaminfo.color)
    net.Send(ply)
  end
  NotifyEveryoneElse(ply)
  SendFullStateUpdate()
end

local function CheckSober(ply, plys)
  if ply:GetSubRole() ~= ROLE_DRUNK then return end
  if ply:GetNWBool("DrunkSober") then return end
  local team = ply:GetTeam()
  for i = 1, #plys do
    local pl = plys[i]
    if pl == ply or pl:GetNWBool("DrunkSober") then continue end
    if pl:HasTeam(team) then
      return false
    end
  end
  return true
end

local function FullCheckSober()
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    local ply = plys[i]
    if CheckSober(ply, plys) then
      DrunkSobers(ply)
      return true
    end
  end
  return false
end

hook.Add("TTT2SpecialRoleSyncing", "TTT2RoleDrunkHide", function(ply, tbl)
  if ply and ply:GetSubRole() ~= ROLE_DRUNK then return end
  for drk in pairs(tbl) do
    if drk:GetSubRole() == ROLE_DRUNK and not ply:GetNWBool("DrunkSober") then
      tbl[drk] = {ROLE_DRUNK, TEAM_NONE}
    end
  end
end)

hook.Add("TTT2PostPlayerDeath", "DrunkAllyDied", FullCheckSober)
hook.Add("PlayerDisconnected", "DrunkAllyDisconnect", FullCheckSober)
hook.Add("PlayerSpawn", "DrunkSpawn", FullCheckSober)
hook.Add("TTT2UpdateSubrole", "DrunkRolechange", FullCheckSober)

local function ResetDrunk()
  local plys = player.GetAll()
  for i = 1, #plys do
    plys[i]:SetNWBool("DrunkSober", nil)
  end
end

hook.Add("TTTPrepRound", "ResetDrunk", ResetDrunk)
hook.Add("TTTEndRound", "ResetDrunk", ResetDrunk)

local function DrunkTraitor(ply, teaminfo)
  if teaminfo.team ~= TEAM_TRAITOR then return end
  ply:SetRole(ROLE_TRAITOR)
  ply:SetCredits(1)
end

-- local function DrunkInnocent(ply, teaminfo)
-- end

local function DrunkMarker(ply, teaminfo)
  if not MARKER or teaminfo.team ~= TEAM_MARKER then return end
  ply:SetRole(ROLE_MARKER)
end

local function DrunkJester(ply, teaminfo)
  if not JESTER or teaminfo.team ~= TEAM_JESTER  then return end
  ply:SetRole(ROLE_JESTER)
end

local function DrunkJackal(ply, teaminfo)
  if not JACKAL or teaminfo.team ~= TEAM_JACKAL then return end
  ply:SetRole(ROLE_JACKAL)
end

local function DrunkNecromancer(ply, teaminfo)
  if not NECROMANCER or teaminfo.team ~= TEAM_NECROMANCER then return end
  ply:SetRole(ROLE_NECROMANCER)
end

local function DrunkSerialKiller(ply, teaminfo)
  if not SERIALKILLER or teaminfo.team ~= TEAM_SERIALKILLER then return end
  ply:SetRole(ROLE_SERIALKILLER)
end

local function DrunkDoppelganger(ply, teaminfo)
  if not DOPPELGANGER or teaminfo.team ~= TEAM_DOPPELGANER then return end
  ply:SetRole(ROLE_DOPPELGANGER, TEAM_DOPPELGANER)
end

local function DrunkPirate(ply, teaminfo)
  if not PIRATE or teaminfo.team ~= TEAM_PIRATE then return end
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    local pl = plys[i]
    if pl.is_pir_master then
      teaminfo.team = pl:GetTeam()
      teaminfo.color = TEAMS[teaminfo.team].color
      break
    end
  end
  ply:SetRole(ROLE_PIRATE, teaminfo.team)
  return teaminfo
end

-- local function DrunkRestless(ply, teaminfo)
-- end
--
-- local function DrunkLover(ply, teaminfo)
-- end
--
-- local function DrunkRav(ply, teaminfo)
-- end

hook.Add("TTT2DrunkAwaken", "DrunkTraitor", DrunkTraitor)
hook.Add("TTT2DrunkAwaken", "DrunkMarker", DrunkMarker)
hook.Add("TTT2DrunkAwaken", "DrunkJester", DrunkJester)
hook.Add("TTT2DrunkAwaken", "DrunkJackal", DrunkJackal)
hook.Add("TTT2DrunkAwaken", "DrunkNecromancer", DrunkNecromancer)
hook.Add("TTT2DrunkAwaken", "DrunkSerialKiller", DrunkSerialKiller)
hook.Add("TTT2DrunkAwaken", "DrunkDoppelganger", DrunkDoppelganger)
hook.Add("TTT2DrunkAwaken", "DrunkPirate", DrunkPirate)
