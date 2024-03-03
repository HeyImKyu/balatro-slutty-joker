patched = false
centerHook = initCenterHook()

if (sendDebugMessage == nil) then
    sendDebugMessage = function(_)
    end
end

table.insert(mods,
            {
            mod_id = "slutty_joker",
            name = "Slutty Joker",
            version = "0.6.9",
            author = "Kyu & Skadi",
            description = {
                "Adds the \"Slutty Joker\""
            },
            enabled = true,
            on_post_update = function() 
                if not patched then 
                    centerHook.addJoker(self, "j_slutty", "Slutty Joker", nil, true, 1, { x = 0, y = 9 }, nil, {extra = 2}, { "{X:red,C:white} X2 {} Mult", "if played hand contains", "a 6 and a 9"}, 1, true)
            
                    -- local replacement = [[local used_tarot = copier or self
                    
                    -- if self.ability.name == "Bezos" then
                    --     G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    --         play_sound('timpani')
                    --         ease_dollars(100, true)
                    --         return true end }))
                    --     delay(0.6)
                    -- end
                    -- ]]
                    -- local to_replace = [[local used_tarot = copier or self]]
                    -- local fun_name = "Card:use_consumeable"
                    -- local file_name = "card.lua"
                    -- inject(file_name, fun_name, to_replace, replacement)
        
                    -- local to_replace = [[if self.ability.name == 'The Hermit' or self.ability.consumeable.hand_type or self.ability.name == 'Temperance' or self.ability.name == 'Black Hole' then]]
                    -- local replacement = [[sendDebugMessage(self)
                    -- if self.ability.name == 'The Hermit' or self.ability.consumeable.hand_type or self.ability.name == 'Temperance' or self.ability.name == 'Black Hole' or self.ability.name == 'Bezos' then]]
                    -- local fun_name = "Card:can_use_consumeable"
                    -- inject(file_name, fun_name, to_replace, replacement)

                    toPatch = "if _center.name == 'Photograph' and (_center.discovered or self.bypass_discovery_center) then "

                    patch = [[
                        if _center.name == 'Photograph' and (_center.discovered or self.bypass_discovery_center) then 
                            self.children.center.scale.y = self.children.center.scale.y/1.2
                        end
                        if _center.name == 'Slutty Joker'
                            self.
                        end
                    ]]

                    patched = true
                    sendDebugMessage("Patched slutty joker mod !")
                end
            end,
        }
)
