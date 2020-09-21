local function CheckAwaken(ply, plys)
  if ply:GetSubRole() ~= ROLE_DRUNK then return end
  if ply:GetNWBool("DrunkAwake") then return end

  for i = 1, #plys do
    local pl = plys[i]
    if pl == ply or pl:GetNWBool("DrunkAwake") then continue end
    if pl:HasTeam(ply:GetTeam()) then
      hook.Run("TTT2DrunkAwaken", ply)
      ply:SetNWBool("DrunkAwake", true)
      SendFullStateUpdate()
      return true
    end
  end
  return false
end

local function FullCheckAwaken()
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    if CheckAwaken(plys[i], plys) then return true end
  end
  return false
end

hook.Add("TTTSpecialRoleSyncing", "TTT2RoleDrunkHide", function(ply, tbl)
  for drk in pairs(tbl) do
    if drk:GetSubRole() == ROLE_DRUNK and not drk:GetNWBool("DrunkAwake") then
      tbl[drk] = {ROLE_DRUNK, TEAM_NONE}
    end
  end
end)

hook.Add("TTT2PostPlayerDeath", "DrunkAllyDied", FullCheckAwaken)
hook.Add("PlayerDisconnected", "DrunkAllyDisconnect", FullCheckAwaken)
hook.Add("PlayerSpawn", "DrunkSpawn", FullCheckAwaken)

local function ResetDrunk()
  local plys = player.GetAll()
  for i = 1, #plys do
    plys[i]:SetNWBool("DrunkAwake", nil)
  end
end

hook.Add("TTTPrepRound", "ResetDrunk", ResetDrunk)
hook.Add("TTTEndRound", "ResetDrunk", ResetDrunk)
