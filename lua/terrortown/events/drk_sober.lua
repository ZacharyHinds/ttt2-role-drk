if CLIENT then
    EVENT.title = "title_drk_sober"
    EVENT.icon = Material("vgui/ttt/dynamic/roles/icon_drk.vmt")

    function EVENT:GetText()
        return {
            {
                string = "desc_drk_sober",
                params = {
                    nick = self.event.nick
                }
            },
            {
                string = "desc_drk_sober_role",
                params = {
                    role = self.event.role
                },
                translateParams = true
            }
        }
    end
end

if SERVER then
    function EVENT:Trigger(ply, role)
        return self:Add({
            nick = ply:Nick(),
            role = role
        })
    end
end