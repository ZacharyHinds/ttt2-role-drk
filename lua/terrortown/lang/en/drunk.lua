L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[DRUNK.name] = "Drunk"
L["info_popup_" .. DRUNK.name] = [[You are a Drunk! You don't know which team your on until your the only one left!]]
L["body_found_" .. DRUNK.abbr] = "They were a Drunk!"
L["search_role_" .. DRUNK.abbr] = "This person was a Drunk!"
L["target_" .. DRUNK.name] = "Drunk"
L["ttt2_desc_" .. DRUNK.name] = [[The Drunk doesn't know what team they're on or who their teammates are.
Once all their teammates are gone, the Drunk learns what their team is.]]

-- OTHER ROLE STRINGS
L["ttt2_drk_remembers"] = "You've sobered up!"
L["ttt2_drk_role"] = "Your role is {role}!"
L["ttt2_drk_sober"] = "The drunk has sobered up!"
L["ttt2_drk_sobering"] = "Sobering up! Your role is {role}"

-- SETTING STRINGS
L["label_ttt2_drk_delay_min"] = "Minimum delay to receive new role when sobering up"
L["label_ttt2_drk_delay_max"] = "Maximum delay to receive new role when sobering up"
L["label_ttt2_drk_base_chance"] = "Base percent chance to sober up"
L["label_ttt2_drk_max_chance"] = "Maximum percent chance to sober up"