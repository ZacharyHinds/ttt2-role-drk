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


--EVENT STRINGS
L["title_drk_sober"] = "A Drunk sobered up"
L["desc_drk_sober"] = "{nick} sobered up."
L["desc_drk_sober_role"] = "They became a {role}"