local Snowbirds_atlas = {
    object_type = "Atlas", 
    key = "Snowbirds_atlas", 
    path = "Snowbirds.png", 
    px = 71, py = 95
}

local Snowbirds = {
    object_type = "Joker",
    order = 47,
    key = "Snowbirds",
    config = { extra = { mult = 0, mult_mod = 2, money = -1 } },
    rarity = 1,
    atlas = 'Snowbirds_atlas',
    pos = { x = 0, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
  
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.mult_mod,
            card.ability.extra.mult,
            math.abs(card.ability.extra.money),
            colours = { G.C.DARK_EDITION }
        } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult, 
            }
        elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                operation = "+",
                message_key = 'a_mult',
                message_colour = G.C.MULT
            })
            return nil, true
        end
    end
}

return { name = {"Jokers"}, items = {Snowbirds_atlas, Snowbirds} }
