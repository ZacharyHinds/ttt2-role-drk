util.AddNetworkString("ttt2_drk_sober")

local function SetupDrk(ply)
    if not IsValid(ply) then return end
    ply.drunkDeadCount = 0
end

hook.Add("TTT2UpdateSubrole", "TTT2DrunkRoleChange", function(ply, old, new)
    if new ~= ROLE_DRUNK then return end
    SetupDrk(ply)
end)

local function SoberPly(drk, tgt)
    if not IsValid(drk) or not drk:IsPlayer() or not drk:Alive() or drk:IsSpec() then return end
    if drk:GetSubRole() ~= ROLE_DRUNK or tgt:GetSubRole() == ROLE_DRUNK then return end
    if not IsValid(tgt) or not tgt:IsPlayer() or tgt:Alive() then return end
    local new_role = tgt:GetSubRole()
    local new_team = tgt:GetTeam()
    local delay = math.random(GetConVar("ttt2_drk_delay_min"):GetInt(), GetConVar("ttt2_drk_delay_max"):GetInt())
    drk:SetNWFloat("ttt2_drk_start_time", CurTime())
    drk:SetNWString("ttt2_drk_rolestring", tgt:GetRoleStringRaw())
    drk:SetNWInt("ttt2_drk_delay", delay)
    print("[TTT2 Drunk] Drunk: " .. drk:Nick() .. " is Sobering up in " .. delay .. " seconds")

    timer.Create("TTT2DrunkSoberDelay" .. drk:SteamID(), delay, 1, function()
        if GetRoundState() ~= ROUND_ACTIVE then return end
        if drk:GetSubRole() ~= ROLE_DRUNK then return end

        drk:SetRole(new_role, new_team)
        SendFullStateUpdate()
        print("[TTT2 Drunk] Writing NetMessage")
        net.Start("ttt2_drk_sober")
        net.Broadcast()
        print("[TTT2 Drunk] Broadcasting Net Message")
    end)
end

local function CheckSoberPly(drk, tgt)
    if not IsValid(drk) or not drk:IsPlayer() or not drk:Alive() or drk:IsSpec() then return end
    if drk:GetSubRole() ~= ROLE_DRUNK or tgt:GetSubRole() == ROLE_DRUNK then return end
    if not drk.drunkDeadCount then return end
    if not IsValid(tgt) or not tgt:IsPlayer() then return end
    if timer.Exists("TTT2DrunkSoberDelay" .. drk:SteamID()) then return end

    local chance = math.Clamp(105 - (90 / (drk.drunkDeadCount)), 30, 100)

    if math.random(1, 100) <= chance then
        SoberPly(drk, tgt)
    else
        drk.drunkDeadCount = drk.drunkDeadCount + 1
        print("[TTT2 Drunk] " .. drk:Nick() .. " sober chance: " .. math.Clamp((115 - (85 / (drk.drunkDeadCount))), 30, 100))
    end
end

hook.Add("TTT2PostPlayerDeath", "TTT2DrunkPlayerDied", function(ply, _, attacker)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if ply:GetSubRole() == ROLE_DRUNK then return end

    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
        local drk = plys[i]
        CheckSoberPly(drk, ply)
    end
end)

hook.Add("PlayerDisconnected", "TTT2DrunkPlayerDisconnect", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
        local drk = plys[i]
        CheckSoberPly(drk, ply)
    end
end)

local function ResetDrunks()
    local plys = player.GetAll()
    for i = 1, #plys do
        local ply = plys[i]
        ply.drunkDeadCount = 0
        drk:SetNWFloat("ttt2_drk_start_time", nil)
        drk:SetNWString("ttt2_drk_rolestring", nil)
        drk:SetNWInt("ttt2_drk_delay", nil)
        local timer_id = "TTT2DrunkSoberDelay" .. ply:SteamID()
        if timer.Exists(timer_id) then
            timer.Remove(timer_id)
        end
    end
end

hook.Add("TTTEndRound", "TTT2DrunkReset", ResetDrunks)
hook.Add("TTTPrepRound", "TTT2DrunkReset", ResetDrunks)