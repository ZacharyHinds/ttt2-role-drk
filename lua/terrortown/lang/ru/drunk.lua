L = LANG.GetLanguageTableReference("ru")

-- GENERAL ROLE LANGUAGE STRINGS
L[DRUNK.name] = "Алкаш"
L["info_popup_" .. DRUNK.name] = [[Вы пьяны! Вы не знаете, в какой команде находитесь, пока не останется ваша единственная!]]
L["body_found_" .. DRUNK.abbr] = "Он был алкашом!"
L["search_role_" .. DRUNK.abbr] = "Этот человек был алкашом!"
L["target_" .. DRUNK.name] = "Алкаш"
L["ttt2_desc_" .. DRUNK.name] = [[Алкаш не знает, в какой команде он или кто его товарищи по команде.
Как только все его товарищи по команде пропадут, Алкаш узнает, что это за команда.]]

-- OTHER ROLE STRINGS
L["ttt2_drk_remembers"] = "Вы протрезвели! Вы в команде {team}" -- CHANGED: "You've sobered up!"
-- L["ttt2_drk_role"] = "Your role is {role}!"
L["ttt2_drk_sober"] = "Алкаш протрезвел!"
-- L["ttt2_drk_sobering"] = "Sobering up! Your role is {role}"

-- SETTING STRINGS
-- L["label_ttt2_drk_delay_min"] = "Minimum delay to receive new role when sobering up"
-- L["label_ttt2_drk_delay_max"] = "Maximum delay to receive new role when sobering up"