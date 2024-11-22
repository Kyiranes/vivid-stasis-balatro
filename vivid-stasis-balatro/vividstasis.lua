--- STEAMODDED HEADER
--- MOD_NAME: vivid/stasis Balatro Mod
--- MOD_ID: stasisMOD
--- MOD_AUTHOR: [TwinklingStar]
--- MOD_DESCRIPTION: Mod adding vivid stasis characters and developers into balatro.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]
--- BADGE_COLOR: CD015A
--- PREFIX: vist
----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas{
    key = "vividstasis1",
    path = "vividstasis1.png",
    px = 71,
	py = 95
}
SMODS.Joker{
    key = 'nurse',
    loc_txt = {
        name = "Nurse",
        text = {
            "Gains +{C:chips}#1#{} Chips for",
            "each {C:attention}remaining{} hand",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        }
    },
    config = { extra = {chip_gain = 40} },
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
            return {
                chip_mod = card.ability.extra.chip_gain * G.GAME.current_round.hands_left + card.ability.extra.chip_gain,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain * G.GAME.current_round.hands_left} }
            }
        end
    end
}
SMODS.Joker{
    key='movator',
    loc_txt = {
        name = "Movator",
        text = {
            "Gains {C:mult}#2#{} Mult",
            "per {C:attention}consecutive{} hand",
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
    key='bugreport',
    loc_txt = {
        name = "Bug Report",
        text = {
            "Gives {C:mult}#1#{} Mult",
            "if hand type unplayed in round",
        }
    },
    config = {extra = {mult = 15, handTable = {}}},
    rarity = 1,
    blueprint_compat = true,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
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
    key='mountainview',
    loc_txt = {
        name = "Mountain View",
        text = {
            "In the {C:attention}first{} hand of round",
            "Retriggers all played cards {C:attention}#1#{} time(s)"
        
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
