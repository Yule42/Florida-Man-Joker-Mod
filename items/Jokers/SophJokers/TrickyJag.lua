local TrickyJag_atlas = {
    object_type = "Atlas", 
    key = "TrickyJag_atlas", 
    path = "TrickyJag.png", 
    px = 71, py = 95
}

local TrickyJag = {
    object_type = "Joker",
    order = 15,
    key = "TrickyJag",
    config = { extra = { xmult = 2, active = false } },
    rarity = 1,
    atlas = 'TrickyJag_atlas',
    pos = { x = 0, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
  
    loc_vars = function(self, info_queue, card)
        local jag_card = G.GAME.current_round.flor_jag_card or { rank = 'Ace', suit = 'Spades' }
        local key = card.ability.extra.active and 'j_flor_TrickyJag' or 'j_flor_TrickyJag_inactive'
        return { vars = { 
            card.ability.extra.xmult,
            localize(jag_card.rank, 'ranks'),
            localize(jag_card.suit, 'suits_plural'),
            colours = { G.C.DARK_EDITION, G.C.SUITS[jag_card.suit] }
        }, key = key }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 and card.ability.extra.active then
            return {
                xmult = card.ability.extra.xmult,
            }
        elseif context.discard then
			if context.other_card:get_id() == G.GAME.current_round.flor_jag_card.id and context.other_card:is_suit(G.GAME.current_round.flor_jag_card.suit) then
                card.ability.extra.active = true
				return {
					message = localize('k_flor_destroy_jag'),
					colour = G.C.FILTER,
					remove = true,
				}
			end
        elseif context.end_of_round then
            card.ability.extra.active = false
            return nil, true
        end
    end
}

local function reset_flor_jag_card()
    G.GAME.current_round.flor_jag_card = { rank = 'Ace', suit = 'Spades' }
    local valid_jag_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            valid_jag_cards[#valid_jag_cards + 1] = playing_card
        end
    end
    local jag_card = pseudorandom_element(valid_jag_cards, 'flor_jag'..G.GAME.round_resets.ante)
    if jag_card then
        G.GAME.current_round.flor_jag_card.rank = jag_card.base.value
        G.GAME.current_round.flor_jag_card.suit = jag_card.base.suit
        G.GAME.current_round.flor_jag_card.id = jag_card.base.id
    end
end

local rgg = SMODS.current_mod.reset_game_globals

function SMODS.current_mod.reset_game_globals(run_start)
    rgg(self, run_start)
	reset_flor_jag_card()
end

return { name = {"Jokers"}, items = {TrickyJag_atlas, TrickyJag} }
