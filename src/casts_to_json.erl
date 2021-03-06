-module(casts_to_json).

-author('Yue Marvin Tao').

-export([]).

ref({AttrType, Attribute, Role}) ->
    {[{type, AttrType}, {attr, Attribute}, {role, Role}]};
ref({Min, Max}) ->
    {[{min, Min}, {max, Max}]};
ref(Value) ->
    {[{value, Value}]}.

operand({Inc, Mul}) -> {[{inc, ref(Inc)}, {mul, ref(Mul)}]};
operand({Inc}) -> {[{inc, ref(Inc)}]}.

operator({Opcode, Operand, Note}) ->
    {[{opcode, Opcode}, {operand, operand(Operand)}, {note, Note}]}.

trans({Operator, ToWhom}) ->
    {[{operator, operator(Operator)}, {to_whom, ref(ToWhom)}]}.

trans_list(TransList) ->
    [trans(Trans) || Trans <- TransList].

seq_cond({Start, Last, Stage}) ->
    {[{start, Start}, {last, Last}, {stage, Stage}]}.

comp_cond({Value, Opcode, Ref}) ->
    {[{value, Value}, {op, Opcode}, {ref, ref(Ref)}]}.

comp_cond_list(CompCondList) ->
    [comp_cond(CompCond) || CompCond <- CompCondList].

conds({Seq, CompCondList}) ->
    {[{seq_cond, seq_cond(Seq)}, {comp_cond_list, comp_cond_list(CompCondList)}]}.

effect({Conds, TransList, EffectNote}) ->
    {[{conds, conds(Conds)}, {trans_list, trans_list(TransList)}, {effect_note, EffectNote}]}.

effect_list(EffectList) ->
    [effect(Effect) || Effect <- EffectList].

effect_prob_group({Prob, ToWhom, EffectList}) ->
    {[{prob, Prob}, {towhom, ToWhom}, {effects, effect_list(EffectList)}]}.

effect_prob_group_list(EffectProbGroupList) ->
    [effect_prob_group(EffectProbGroup) || EffectProbGroup <- EffectProbGroupList].

cast({Name, Class, EffectProbGroupsList}) ->
    Cast = {[{name, Name}, {class, Class}, {effect_prob_group_list, effect_prob_group_list(EffectProbGroupsList)}]},
    Cast.


