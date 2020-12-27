
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

if SERVER then
  util.AddNetworkString("ttt2_drk_sober")
  function SetupDrkPly(ply, plys)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end
    if ply:GetSubRole() ~= ROLE_DRUNK then return end
    plys = plys or util.GetAlivePlayers()
    local pl
    repeat
      if #plys <= 0 then
        plys = util.GetAlivePlayers()
        if #plys <= 0 then return end
      end
      local rnd = math.random(#plys)
      pl = plys[rnd]
      table.remove(plys, rnd)
    until IsValid(ply) and pl ~= ply and pl:GetSubRole() ~= ROLE_DRUNK
    pl.drkPlyTag = ply:SteamID()
  end

  function ResetDrk(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    ply.drkPlyTag = nil
  end

  function ResetAllDrk()
    local plys = player.GetAll()
    for i = 1, #plys do
      ResetDrk(plys[i])
    end
  end

  hook.Add("TTTBeginRound", "TTT2DrunkSetup", function()
    ResetAllDrk()
    -- timer.Simple(0.5, function()
    --   local plys = util.GetAlivePlayers()
    --   for i = 1, #plys do
    --     SetupDrkPly(plys[i], plys)
    --   end
    -- end)
  end)

  hook.Add("TTTEndRound", "TTT2ResetDrunk", ResetAllDrk)
  hook.Add("TTTPrepRound", "TTT2ResetDrunk", ResetAllDrk)

  hook.Add("TTT2UpdateSubrole", "TTT2DrunkRoleChange", function(ply, old, new)
    timer.Simple(0.5, function()
      if new == ROLE_DRUNK then
        SetupDrkPly(ply)
      end
    end)
  end)

  function SoberUpPly(ply, new_role)
    if not IsValid(ply) or not ply:IsPlayer() or ply:IsSpec() or not ply:Alive() then return end
    if ply:GetSubRole() ~= ROLE_DRUNK then return end
    new_role = new_role or ROLE_INNOCENT
    ply:SetRole(new_role)
    SendFullStateUpdate()
    print("[TTT2 Drunk] Writing Net Message")
    net.Start("ttt2_drk_sober")
      -- net.WriteString(ply:GetRoleString())
      -- net.WriteColor(ply:GetRoleLtColor())
    net.Broadcast()
    print("[TTT2 Drunk] Broadcasting Net Message")
  end

  hook.Add("TTT2PostPlayerDeath", "DrunkTargetDied", function(ply, _, attacker)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply.drkPlyTag then return end
    -- print("[TTT2 Drunk] Drunk target identified")

    local drk = player.GetBySteamID(ply.drkPlyTag)
    -- print("[TTT2 Drunk] Connnected Drunk: " .. drk:Name())
    SoberUpPly(drk, ply:GetSubRole())
    ply.drkPlyTag = nil
  end)

  hook.Add("PlayerDisconnected", "DrunkTargetDisconnected", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply.drkPlyTag then return end
    local drk = player.GetBySteamID(ply.drkPlyTag)
    SoberUpPly(drk, ply:GetSubRole())
    ply.drkPlyTag = nil
  end)

  concommand.Add("ttt2_drk_identify", function()
    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      if ply.drkPlyTag then
        local drk = player.GetBySteamID(ply.drkPlyTag)
        print("[TTT2 Drunk] Drunk: " .. drk:Name() .. " | Targeting: " .. ply:Nick() .. " (" .. ply:GetRoleString() .. ")")
      end
    end
  end)
end
