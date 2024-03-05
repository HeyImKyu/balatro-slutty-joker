patchedSlutty = false
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
                if not patchedSlutty then 
                    centerHook.addJoker(self, "j_slutty", "Slutty Joker", nil, true, 1, { x = 0, y = 9 }, nil, {extra = 2}, { "{X:red,C:white} X2 {} Mult", "if played hand contains", "a 6 and a 9"}, 1, true)
        
                    local toReplace = "if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then"

                        local replacement = [[
                        if self.ability.name == 'Slutty Joker' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            local sixs = 0
                            local nines = 0
    
                            for i = 1, #context.full_hand do
                                if context.full_hand[i]:get_id() == 6 then sixs = sixs + 1 end
                                if context.full_hand[i]:get_id() == 9 then nines = nines + 1 end
                            end
                            if sixs > 0 and nines > 0 then
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                    Xmult_mod = self.ability.extra
                                }
                            end
                        end
    
                        if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        ]]
                        
                        inject("card.lua", "Card:calculate_joker", toReplace:gsub("([^%w])", "%%%1"), replacement)
    
                    patchedSlutty = true

                    sendDebugMessage("Patched slutty joker mod !")
                end
            end,
        }
)
