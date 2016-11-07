-module(battle_parse).

-author('Yue Marvin Tao').

-export([player_context_from_parsed_JSON/1]).

parse_single_player(SinglePlayerData) ->

    {[
      {_, ID}, {_, HP}, {_, PrimType}, {_, PrimMax}, {_, PrimMin}, {_, SecdType},
      {_, SecdMax}, {_, SecdMin}, {_, Armor}, {_, HitBonus}, {_, Critic}, {_, Dodge},
      {_, Resist}, {_, Block}, {_, Agi}, {_, CastList}
     ]} = SinglePlayerData,

    #{

        id         => binary_to_atom(ID, utf8),

        % State is the data that will be modified during a battle, and the result will
        % be preserved.

        state      => #{
            hp         => HP,
            rem_moves  => 0
        },

        done => already,
        
        curr_hand  => {prim, binary_to_atom(PrimType, utf8), {PrimMin, PrimMax}},
        secd_hand  => {secd, binary_to_atom(SecdType, utf8), {SecdMin, SecdMax}},
        prim_hand  => {prim, binary_to_atom(PrimType, utf8), {PrimMin, PrimMax}},

        casts => lists:map(fun(X) -> binary_to_atom(X, utf8) end, CastList),
        effects => [],

        orig_attr => #{
            attack_disabled => false,
            cast_disabled => false,
            effect_invalidated => false,
            armor      => Armor,
            hit_bonus  => HitBonus,
            critical   => Critic,
            dodge      => Dodge,
            resist     => Resist,
            block      => Block,
            agility    => Agi,
            outcome    => null,
            damage_coeff => 1,
            damage_addon => 0,
            damage_taken => 0
        }
    }.



player_context_from_parsed_JSON(Data) ->

    {[{<<"player1">>, Player1}, {<<"player2">>, Player2}]} = Data,

    {parse_single_player(Player1), parse_single_player(Player2)}.
