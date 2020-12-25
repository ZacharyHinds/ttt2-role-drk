net.Receive("ttt2_drk_sober", function()
  print("[TTT2 Drunk] Net Message Received")
  -- local rolename = net.ReadString()
  -- local rolecolor = net.ReadColor()
  -- local drkID = nil
  -- local client = LocalPlayer()
  -- if client:SteamID64() == drkID then
  --   EPOP:AddMessage({
  --       text = LANG.TryTranslation("ttt2_drk_remembers"),
  --       color = rolecolor
  --     },
  --     LANG.GetParamTranslation("ttt2_drk_role", {role = rolename}),
  --     12,
  --     nil,
  --     true
  --   )
  -- else
  EPOP:AddMessage({
      text = LANG.TryTranslation("ttt2_drk_sober")
    },
    nil,
    6,
    nil,
    true
  )
  -- end
end)
