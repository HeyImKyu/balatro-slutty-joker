patchedSlutty = false
centerHook = initCenterHook()

if (sendDebugMessage == nil) then
    sendDebugMessage = function(_)
    end
end

function input(path, function_name, to_replace, replacement)
    -- Injects code into a function (replaces a string with another string inside a function)
    local function_body = extractFunctionBody(path, function_name)
    local modified_function_code = function_body:gsub(to_replace, replacement)
    current_game_code[path] = current_game_code[path]:gsub(function_body, modified_function_code) -- update current game code in memory

    local new_function, load_error = load(modified_function_code) -- load modified function
    if not new_function then
        -- Safeguard against errors, will be logged in %appdata%/Balatro/err1.txt
        love.filesystem.write("err1.txt", "Error loading modified function: " .. (load_error or "Unknown error"))
    end

    if setfenv then
        setfenv(new_function, getfenv(original_testFunction))
    end -- Set the environment of the new function to the same as the original function

    local status, result = pcall(new_function) -- Execute the new function
    if status then
        testFunction = result -- Overwrite the original function with the result of the new function
    else
        love.filesystem.write("err2.txt", "Error executing modified function: " .. result) -- Safeguard against errors, will be logged in %appdata%/Balatro/err2.txt
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
            
                    local toReplace = [[if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local eights = 0
                        for i = 1, #context.full_hand do
                            if context.full_hand[i]:get_id() == 8 then eights = eights + 1 end
                        end
                        if eights >= self.ability.extra then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                            return {
                                message = localize('k_plus_planet'),
                                colour = G.C.SECONDARY_SET.Planet,
                                card = self
                            }
                        end
                    end
                    ]]

                    local replacement = [[if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local eights = 0
                        for i = 1, #context.full_hand do
                            if context.full_hand[i]:get_id() == 8 then eights = eights + 1 end
                        end
                        if eights >= self.ability.extra then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                            return {
                                message = localize('k_plus_planet'),
                                colour = G.C.SECONDARY_SET.Planet,
                                card = self
                            }
                        end
                    end

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
                    ]]
                    
                    input("card.lua", "Card:calculate_joker", toReplace:gsub("([^%w])", "%%%1"), replacement)

                    local function_body = extractFunctionBody("card.lua", "Card:calculate_joker")
                    sendDebugMessage(function_body)

                    patchedSlutty = true
                    sendDebugMessage("Patched slutty joker mod !")
                end
            end,
        }
)
