-- CreateConVar("ttt2_drk_tgt_pct", "0.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
-- CreateConVar("ttt2_drk_tgt_min", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
-- CreateConVar("ttt2_drk_tgt_max", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_delay_max", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_delay_min", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_base_chance", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_min_chance", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_drk_max_chance", "100". {FCVAR_ARCHIVE, FCVAR_NOTIFY})


hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_drk_dynamic_convars", function(tbl)
  tbl[ROLE_DRUNK] = tbl[ROLE_DRUNK] or {}


  table.insert(tbl[ROLE_DRUNK], {
    cvar = "ttt2_drk_delay_min",
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_drk_delay_min (def. 15)"
  })
  
  table.insert(tbl[ROLE_DRUNK], {
    cvar = "ttt2_drk_delay_max",
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_drk_delay_max (def. 30)"
  })

  table.insert(tbl[ROLE_DRUNK], {
    cvar = "ttt2_drk_base_chance",
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2_drk_base_chance (def. 15)"
  })

  table.insert(tbl[ROLE_DRUNK], {
    cvar = "ttt2_drk_max_chance",
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2_drk_max_chance (def. 100)"
  })

end)
