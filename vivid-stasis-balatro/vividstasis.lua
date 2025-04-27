local oldcalculate_reroll_cost = calculate_reroll_cost
function calculate_reroll_cost(skip_increment)
    if #SMODS.find_card('j_vist_speakerbox') > 0 then
        G.GAME.current_round.reroll_cost = 7
        return
    end
    return oldcalculate_reroll_cost(skip_increment)
end
SMODS.Atlas{
    key = "vividstasis1",
    path = "vividstasis1.png",
    px = 71,
	py = 95
}
SMODS.Joker{
    key='bugreport',
    loc_txt = {
        name = "Bug Report",
        text = {
            "{C:mult}+#1#{} Mult if",
            "hand type unplayed in round",
        }
    },
    config = {extra = {mult = 15, handTable = {}}},
    rarity = 1,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 1, y = 0},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
            if context.end_of_round == true then
                card.ability.extra.handTable = {}
            end
            if context.joker_main then
                if not card.ability.extra.handTable[context.scoring_name] then
                    return {
                        mult_mod = card.ability.extra.mult,
                        message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
                        colour = G.C.MULT,
            }
        end
            if context.after then
                card.ability.extra.handTable[context.scoring_name] = true
            end
        end
    end
}
SMODS.Joker{
    key='movator',
    loc_txt = {
        name = "Movator",
        text = {
            "Gains {C:mult}+#2#{} Mult",
            "per {C:attention}consecutive{} hand played",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        }
    },
    config = { extra = {mult = 0, mult_gain = 2} },
    rarity = 1,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} }
            }
        end
        if context.before and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult_gain + card.ability.extra.mult
            return {
                message = 'Upgraded!',
                colour = G.C.MULT,
                card = card
            }
        end
        if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
            card.ability.extra.mult = 0
            return {
                message = 'Reset!',
                colour = G.C.MULT,
                card = card
            }
        end
    end
}
SMODS.Joker{
    key = 'nurse',
    loc_txt = {
        name = "Nurse",
        text = {
            "Gains {C:chips}+#1#{} Chips for",
            "each {C:attention}remaining{} hand",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        }
    },
    config = { extra = {chip_gain = 20} },
    rarity = 1,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chip_gain, card.ability.extra.chip_gain * G.GAME.current_round.hands_left} }
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if(G.GAME.current_round.hands_left > 0) then
            return {
                chip_mod = card.ability.extra.chip_gain * G.GAME.current_round.hands_left + card.ability.extra.chip_gain,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain * G.GAME.current_round.hands_left} }
            }
            end
        end
    end
}
SMODS.Joker{
    key = 'speakerbox',
    loc_txt = {
        name = "Speaker Box",
        text = {
            "Rerolls always cost {C:money}$7{}"
        }
    },
    rarity = 1,
    blueprint_compat = false,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 5,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = 7
        calculate_reroll_cost(true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end
}
SMODS.Joker{
    key='Jade',
    loc_txt = {
        name = "Jade",
        text = {
            "Retrigger all played {C:attention}Stone{} cards #1# times.",
        }
    },
    config = {extra = {repetitions = 1}},
    rarity = 2,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 6,
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.repetitions}}
    end,
    in_pool = function(self,args)
        for i, _playing_card_in_deck in pairs(G.playing_cards) do
        if SMODS.has_enhancement(_playing_card_in_deck, "m_stone") then
          return true
        end
        end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and SMODS.has_enhancement(context.other_card, 'm_stone') then
            return {
                message = localize('k_again_ex'),
                color = G.C.FILTER,
                repetitions = card.ability.extra.repetitions,
                card = card
            }
        end
    end
}
SMODS.Joker{
    key='mountainview',
    loc_txt = {
        name = "Mountain View",
        text = {
            "In the {C:attention}first{} hand of round",
            "retriggers all played cards {C:attention}#1#{} time(s)"

        }
    },
    config = {extra = {repetitions = 1}},
    rarity = 2,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = {x = 0, y = 0},
    cost = 5,
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.repetitions}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition and G.GAME.current_round.hands_played == 0 then
            return{
                message = localize('k_again_ex'),
                color = G.C.FILTER,
                repetitions = card.ability.extra.repetitions,
                card = context.other_card
            }
        end
    end
}
SMODS.Joker{
    key='salmonnigiri',
    loc_txt = {
        name = "Salmon Nigiri",
        text = {
            "For the next {C:attention}#1#{} rounds",
            "all cards give {C:money}$#2#{} when scored."
        }
    },
    config = {extra = {roundcount = 5, money = 2}},
    rarity = 2,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = {x = 0, y = 0},
    cost = 5,
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.roundcount, card.ability.extra.money}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            return{
                dollars = card.ability.extra.money,
                card = card
            }
        end
        if context.end_of_round then
            card.ability.extra.roundcount = card.ability.extra.roundcount - 1
            return{
                message = "Consumed!"
            }
        end
        if card.ability.extra.roundcount == 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                        end
                    }))
                    return true
                end
            }))
            return{
            message = "All Gone!"
            }

        end
    end
}
SMODS.Joker{
    key='bearcreekpark',
    loc_txt = {
        name = "Bear Creek Park",
        text = {
            "Gives {X:mult,C:white}X#1# {} Mult if first played card",
            "is a {C:attention}9, 7, 2, or 5 {}"
        }
    },
    config = { extra = {Xmult = 3} },
    rarity = 3,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and (context.scoring_hand[1]:get_id() == 2 or context.scoring_hand[1]:get_id() == 5 or context.scoring_hand[1]:get_id() == 7 or context.scoring_hand[1]:get_id() == 9) then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}
SMODS.Joker{
    key='kenbanvanquishers',
    loc_txt = {
        name = "Kenban Vanquishers",
        text = {
            "This joker gains {X:mult,C:white}X#2# {} mult if played hand",
            "exceeds the required chips",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = {mult_gain = 0.5, Xmult = 1} },
    rarity = 3,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult, card.ability.extra.mult_gain}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
        if context.after and hand_chips*mult > G.GAME.blind.chips and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.mult_gain
            return {
                message = 'Upgraded!',
                colour = G.C.XMULT,
                card = card
            }
        end
    end


}
SMODS.Joker{
    key='chiyo',
    loc_txt = {
        name = "Chiyo",
        text = {
            "At the end of each round",
            "Create a {C:attention}Voucher {}tag"
        }
    },
    rarity = 4,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = {x = 0, y = 0},
    cost = 20,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            return{
            message = "+1 Tag",
            add_tag(Tag('tag_voucher')),
            }
        end
    end
}
SMODS.Joker{
    key='eri',
    loc_txt = {
        name = "Eri",
        text = {
            "{C:chips}+1{} hand for",
            "every {C:mult}12{} discards used this run.",
            "{C:inactive}(Currently {C:chips}#1#{}{C:inactive} Hands",
            "and {C:mult}#2#{} discards used.)"
        }
    },
    config = { extra = {hands = 0, discards = 12, discard_count = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.hands, card.ability.extra.discard_count}}
    end,
    rarity = 4,
    blueprint_compat = false,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 20,
    calculate = function(self, card, context)
        if context.selling_self then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            card.ability.extra.hands = 0
        end
        if context.pre_discard then
            card.ability.extra.discard_count = card.ability.extra.discard_count + 1
                if card.ability.extra.discard_count >= card.ability.extra.discards then
                    card.ability.extra.discard_count = 0
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                    card.ability.extra.hands = card.ability.extra.hands + 1
                    ease_hands_played(1)
                end    
        end
    end
}
SMODS.Joker{
    key='saturday',
    loc_txt = {
        name = "Saturday",
        text = {
            "This joker gives {X:mult,C:white}X1{} Mult",
            "for each Joker held.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = {xmult = 1} },
    rarity = 4,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return { vars = {G.jokers and #G.jokers.cards or 0}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.xmult = #G.jokers.cards
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.selling_card and context.card.config.center.key == 'j_egg' then
            return{
                message = "Poggers"
            }
        end
    end
}
SMODS.Joker{
    key=':3c',
    loc_txt = {
        name = ":3c",
        text = {
            "Played {C:attention}3s{} give",
            "{X:mult,C:white} X#1# {} Mult when scored."
        }
    },
        config = { extra = {Xmult = 3} },
        rarity = 4,
        blueprint_compat = true,
        atlas = 'vividstasis1',
        pos = {x = 0, y = 0},
        cost = 20,
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult}}
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then
                return{
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
}
