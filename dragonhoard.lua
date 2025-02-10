SMODS.Atlas {
	-- Key for code to find it with
	key = "dragonatlas",
	-- The name of the file, for the code to pull the atlas from
	path = "dragonatlas.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}
-- JOKERS
--Equinox
SMODS.Joker {
        key = 'equinox',
        loc_txt = {
                name = "Equinox",
                text = {
                        "Retriggers {C:attention}every played Ace",
                        "once per {C:planet}Planet {}card used",
                        "{C:inactive}(Currently {X:attention,C:white}X#1#{C:inactive})"
                }
        },
        config = { extra = { planets = 0 } },
        loc_vars = function(self, info_queue, card)
                return { vars = { card.ability.extra.planets } }
        end,
        rarity = 3,
        atlas = 'dragonatlas',
        pos = { x = 0, y = 0},
        cost = 7,
        blueprint_compat = true,
        calculate = function(self, card, context)
                if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
                    card.ability.extra.planets = card.ability.extra.planets + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                            				{ message = 'Upgrade!',
                            				colour = G.C.SECONDARY_SET.Planet
                            				})
                            return true
                        end
                    }))
                end
                if context.cardarea == G.play and context.repetition and not context.repetition_only and context.other_card:get_id() == 14 then
                            return {
                                message = 'Orbit!',
                                colour = G.C.SECONDARY_SET.Planet,
                                repetitions = card.ability.extra.planets,
                                card = card
                            }
                end
        end
}
--Sword in the Stone
SMODS.Joker {
        key = 'swordstone',
        loc_txt = {
                name = "Sword in the Stone",
                text = {
                        "Adds a {C:dark_edition}Negative {C:attention}Stone Card {}to your hand",
                        "whenever a {C:attention}King {}is played and scores"
                }
        },
        config = { extra = {  } },
        	rarity = 1,
        	atlas = 'dragonatlas',
        	pos = { x = 1, y = 0 },
        	cost = 3,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
        	    info_queue[#info_queue+1] = {
        	    key = 'e_negative_playing_card',
        	    set = 'Edition',
        	    config = {extra = 1}
        	    }
        		return { vars = {  } }
        	end,
        	calculate = function(self, card, context)
        		if context.individual and context.cardarea == G.play then
        			if context.other_card:get_id() == 13 then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                                               { message = 'Pulled!',
                                               colour = G.C.DARK_EDITION,
                                               instant = true,
                                               })
                                        play_sound('timpani')
                                       local stone = create_card("Enhanced",
                            						G.deck,
                            					    nil,
                            						nil,
                            			            nil,
                            					    nil,
                            						"m_stone",
                            						nil)
                            	stone:add_to_deck()
                            	stone:set_edition({negative = true}, true)
                            	G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, stone)
                                G.hand:emplace(stone)
                                return true
                                end
        				}))
        			end
        			--[[if context.other_card:get_id() == 13 then
        			        return{
                                                                    extra = { focus = card, message = "Pulled!", colour = G.C.DARK_EDITION, sound = 'timpani' },
                                                     				card = card,

                            }
        			end]]
        		end
        	end
        }
--Heart Amulet
SMODS.Joker {
        key = 'heartamulet',
        loc_txt = {
                name = "Heart Amulet",
                text = {
                        "This Joker gains {C:mult}+#2# {}Mult",
                        "whenever a {C:red}Heart {}is played and scores",
                        "{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)"
                }
        },
        config = { extra = { mult = 0, mult_gain = 2 } },
        	rarity = 2,
        	atlas = 'dragonatlas',
        	pos = { x = 2, y = 0 },
        	cost = 5,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
        		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
        	end,
        	calculate = function(self, card, context)
        		if context.joker_main and card.ability.extra.mult > 0 then
                        return {
                                mult_mod = card.ability.extra.mult,
                                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
                                }
        		end
        		if context.individual and context.cardarea == G.play and context.other_card:is_suit('Hearts') then
        		        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                                return{
                                        extra = { focus = card, message = "Upgrade!", colour = G.C.MULT },
                         				card = card,
                         }
        		end
        	end
        }
--Scepter
SMODS.Joker {
        key = 'promotion',
        loc_txt = {
                name = "Scepter",
                text = {
                        "Once every rank ({C:attention}Ace{} high)",
                        "has been scored in ascending order,",
                        "this Joker gains {X:mult,C:white}X#2#{} Mult",
                        "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
                        "{C:inactive}Next rank: {C:attention}#3#{C:inactive}{C:red}#5#",
                }
        },
        config = { extra = { Xmult = 1, Xmult_gain = 1, next_rank = '2', chain = 2, active = '' } },
        	rarity = 2,
        	atlas = 'dragonatlas',
        	pos = { x = 3, y = 0 },
        	cost = 6,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
        		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain, card.ability.extra.next_rank, card.ability.extra.chain, card.ability.extra.active } }
        	end,
        	calculate = function(self, card, context)
        	    if context.joker_main and card.ability.extra.Xmult > 1 then
                                        return {

                                                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                                                Xmult_mod = card.ability.extra.Xmult,
                                                }
                end
        		if context.individual and context.cardarea == G.play and context.other_card:get_id() == card.ability.extra.chain and card.ability.extra.chain < 14 then
        		            card.ability.extra.chain = card.ability.extra.chain + 1

                                if card.ability.extra.chain == 2 then
                        	       card.ability.extra.next_rank = '2'
                                elseif card.ability.extra.chain == 3 then
                        	       card.ability.extra.next_rank = '3'
                                elseif card.ability.extra.chain == 4 then
                        	       card.ability.extra.next_rank = '4'
                                elseif card.ability.extra.chain == 5 then
                        	       card.ability.extra.next_rank = '5'
                                elseif card.ability.extra.chain == 6 then
                        	       card.ability.extra.next_rank = '6'
                                elseif card.ability.extra.chain == 7 then
                        	       card.ability.extra.next_rank = '7'
                                elseif card.ability.extra.chain == 8 then
                        	       card.ability.extra.next_rank = '8'
                                elseif card.ability.extra.chain == 9 then
                        	       card.ability.extra.next_rank = '9'
                                elseif card.ability.extra.chain == 10 then
                        	       card.ability.extra.next_rank = '10'
                        	    elseif card.ability.extra.chain == 11 then
                        	       card.ability.extra.next_rank = 'Jack'
                        	    elseif card.ability.extra.chain == 12 then
                                   card.ability.extra.next_rank = 'Queen'
                                elseif card.ability.extra.chain == 13 then
                                   card.ability.extra.next_rank = 'King'
                                elseif card.ability.extra.chain == 14 then
                                   card.ability.extra.next_rank = 'Ace'
                                   card.ability.extra.active = ' (Active!)'
                                   local eval = function(card) return (card.ability.extra.chain == 14) end
                                    juice_card_until(card, eval, false)
                                   end
                                   return{
                                                                           extra = { focus = card, message = "Rank Up!", colour = G.C.GREEN },
                                                            				card = card,
                                                            }end
        		if context.individual and context.cardarea == G.play and context.other_card:get_id() == card.ability.extra.chain and card.ability.extra.chain >= 14 then
                            card.ability.extra.chain = 2
                            card.ability.extra.next_rank = '2'
                            card.ability.extra.active = ''
                            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                            return{
                                                                           extra = { focus = card, message = "Reset!", colour = G.C.MULT },
                                                            				card = card,
                                                            }

        		end
        	end
        }
--Dark Mirror
SMODS.Joker {
        key = 'mirror',
        loc_txt = {
                name = "Dark Mirror",
                text = {
                        "{C:green}#1# in #2#{} chance for played cards",
                        "to become {C:dark_edition}Negative{} when scored"
                }
        },
        config = { extra = { odds = 12 } },
        	rarity = 3,
        	atlas = 'dragonatlas',
        	pos = { x = 4, y = 0 },
        	cost = 5,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = {
        	    key = 'e_negative_playing_card',
        	    set = 'Edition',
        	    config = {extra = 1}
        	    }
        		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        	end,
        	calculate = function(self, card, context)
        		if context.individual and context.cardarea == G.play and context.other_card then
        		    if pseudorandom('mirror') < G.GAME.probabilities.normal / card.ability.extra.odds and not context.other_card:get_edition('e_negative') then
                         G.E_MANAGER:add_event(Event({
                                                         		                func = function()
                                                         		                context.other_card:set_edition({negative = true}, true)
                                                                                         card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                                                                                                     { message = 'Reflect!',
                                                                                                       colour = G.C.DARK_EDITION,
                                                                                                       instant = true,
                                                                                                        })
                         return true
                         end })) end
        		end
        	end
        }
--Guillotine
SMODS.Joker {
        key = 'guillotine',
        loc_txt = {
                name = "Guillotine",
                text = {
                        "Sell this Joker to divide the current",
                        "{C:attention}Blind {}requirement by {C:attention}#1#",
                        "{C:inactive,s:0.8}(Must be used in a Blind, use wisely!)"
                }
        },
        config = { extra = { divide = 2 } },
        	rarity = 2,
        	atlas = 'dragonatlas',
        	pos = { x = 5, y = 0 },
        	cost = 5,
        	blueprint_compat = true,
        	eternal_compat = false,
        	loc_vars = function(self, info_queue, card)
        		return { vars = { card.ability.extra.divide } }
        	end,
        	calculate = function(self, card, context)
        		if context.selling_self then
        		        G.GAME.blind.chips = G.GAME.blind.chips / card.ability.extra.divide
        		        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Cut!", sound = 'timpani'})
                        return true
        		end
        	end
        }
--Coin
SMODS.Joker {
        key = 'coin',
        loc_txt = {
                name = "Golden Coin",
                text = {
                        "{C:green}#1# in #2# {}chance to earn {C:money}$#3#",
                        "whenever a card is scored"
                }
        },
        config = { extra = { odds = 5, dollars = 2 } },
        	rarity = 1,
        	atlas = 'dragonatlas',
        	pos = { x = 0, y = 1 },
        	cost = 1,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
        		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.dollars } }
        	end,
        	calculate = function(self, card, context)
        		if context.individual and context.cardarea == G.play and context.other_card then
                     if pseudorandom('coin') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        ease_dollars(card.ability.extra.dollars)
                        G.E_MANAGER:add_event(Event({
                                                func = function()
                                                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.dollars,colour = G.C.MONEY, instant = true})
                                                    return true
                                                end}))
        		end end
        	end
        }
--Placeholder [TEMPLATE]
SMODS.Joker {
        key = 'Placeholder',
        loc_txt = {
                name = "Placeholder",
                text = {
                        "{C:inactive}Does nothing?"
                }
        },
        config = { extra = {  } },
        	rarity = 1,
        	atlas = 'dragonatlas',
        	pos = { x = 5, y = 3 },
        	cost = 1,
        	blueprint_compat = true,
        	loc_vars = function(self, info_queue, card)
        		return { vars = {  } }
        	end,
        	calculate = function(self, card, context)
        		if context.joker_main then
                        return {
                                message = 'Triggered!',
                                colour = G.C.GREEN
                                }
        		end
        	end
        }

--BLINDS
--VOUCHERS