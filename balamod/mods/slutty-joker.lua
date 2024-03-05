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
        
                    local toReplaceLogic = "if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then"

                    local replacementLogic = [[
                        if self.ability.name == 'Slutty Joker' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            local sixs = 0
                            local nines = 0

                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i]:get_id() == 6 then sixs = sixs + 1 end
                                if context.scoring_hand[i]:get_id() == 9 then nines = nines + 1 end
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
                    
                    inject("card.lua", "Card:calculate_joker", toReplaceLogic:gsub("([^%w])", "%%%1"), replacementLogic)

                    ------------------------------------------

                    local toReplaceAtlas = "{name = 'chips', path = \"resources/textures/\"..self.SETTINGS.GRAPHICS.texture_scaling..\"x/chips.png\",px=29,py=29}"

                    local replacementAtlas = [[
                        {name = 'chips', path = "resources/textures/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/chips.png",px=29,py=29},
		                {name = 'slutty_joker', path = "pack/"..self.SETTINGS.GRAPHICS.texture_scaling.."x/slutty_joker.png",px=71,py=95}
                    ]]

                    inject("game.lua", "Game:set_render_settings", toReplaceAtlas:gsub("([^%w])", "%%%1"), replacementAtlas)


                    G:set_render_settings()

                    -------------------------------------------------------

                    local toReplaceTexLoad = "elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then"

                    local replacementTexLoad = [[
                        elseif _center.name == 'Slutty Joker' then
                            self.children.center = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["slutty_joker"], {x=0,y=0})
                        elseif self.config.center.set == 'Voucher' and not self.config.center.unlocked and not self.params.bypass_discovery_center then
                    ]]

                    inject("card.lua", "Card:set_sprites", toReplaceTexLoad:gsub("([^%w])", "%%%1"), replacementTexLoad)

                    sendDebugMessage(extractFunctionBody("card.lua", "Card:set_sprites"))

                    patchedSlutty = true

                    sendDebugMessage("Patched slutty joker mod !")
                end
            end,
        }
)
