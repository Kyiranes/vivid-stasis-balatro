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
            "Gains #1# Chips",
            "per unplayed hand",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        }
    },
    config = { extra = {chip_gain = 40} },
    rarity = 1,
    atlas = 'vividstasis1',
    pos = { x = 0, y = 0},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chip_gain, card.ability.extra.chip_gain * G.GAME.current_round.hands_left + card.ability.extra.chip_gain} }
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chip_gain * G.GAME.current_round.hands_left,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain * G.GAME.current_round.hands_left} }
            }
        end
    end
}