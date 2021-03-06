CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

drop table if exists preset_character_card_profile CASCADE;

CREATE TABLE preset_character_card_profile (
    profile jsonb
);

insert into preset_character_card_profile (profile) values
(
'{"hp": 2700, "card_name":"普通刺客", "image_name": "normal_rogue", "class": "rogue", "range_type" : "near",
 "agi": 75, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 205, "prim_min": 190, "secd_type": "physical", "secd_max": 190, "secd_min": 175,
 "cast_list": ["talisman_of_death", "rune_of_the_void", "talisman_of_spellshrouding", "holy_hand_grenade", "poison_gas"],
 "talented_skill": "blade_dance"}'),

(
'{"hp": 2700, "card_name":"霸道刺客", "image_name": "awaken_rogue", "class": "rogue", "range_type" : "near",
 "agi": 75, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 205, "prim_min": 190, "secd_type": "physical", "secd_max": 190, "secd_min": 175,
 "cast_list": ["healing_potion", "pierce_armor", "flurry", "spellbreak", "perfect_strike"],
 "talented_skill": "blade_dance"}'),

(
'{"hp": 3400, "card_name":"普通猎人", "image_name": "normal_hunter", "class": "hunter", "range_type" : "far",
 "agi": 40, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 370, "prim_min": 335, "secd_type": "bare", "secd_max": 100, "secd_min": 50,
 "cast_list": ["talisman_of_death", "rune_of_the_void", "talisman_of_spellshrouding", "holy_hand_grenade", "poison_gas"],
 "talented_skill": "blade_dance"}'),

(
'{"hp": 3400, "card_name":"痴呆猎人", "image_name": "awaken_hunter", "class": "hunter", "range_type" : "far",
 "agi": 40, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 370, "prim_min": 335, "secd_type": "bare", "secd_max": 100, "secd_min": 50,
 "cast_list": ["tornado", "mend", "outbreak", "roots", "tree_hide"],
 "talented_skill": "blade_dance"}'),

(
 '{"hp": 2300, "card_name":"普通法师", "image_name": "normal_mage", "class": "mage", "range_type" : "far",
 "agi": 35, "hit": 20, "armor": 2700, "block": 0, "dodge": 20, "resist": 15, "critical": 35,
 "prim_type": "magic", "prim_max": 280, "prim_min": 255, "secd_type": "bare", "secd_max": 100, "secd_min": 50,
 "cast_list": ["talisman_of_death", "rune_of_the_void", "talisman_of_spellshrouding", "holy_hand_grenade", "poison_gas"],
 "talented_skill": "blade_dance"}'),

(
 '{"hp": 2300, "card_name":"暴躁法师", "image_name": "awaken_mage", "class": "mage", "range_type" : "far",
 "agi": 35, "hit": 20, "armor": 2700, "block": 0, "dodge": 20, "resist": 15, "critical": 35,
 "prim_type": "magic", "prim_max": 280, "prim_min": 255, "secd_type": "bare", "secd_max": 100, "secd_min": 50,
 "cast_list": ["vampiric_bolt", "arcane_surge", "lower_resist", "pyromania", "mind_blast"],
 "talented_skill": "blade_dance"}'),

(
 '{"hp": 3400, "card_name":"普通战士", "image_name": "normal_warrior", "class": "warrior", "range_type" : "near",
 "agi": 50, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 205, "prim_min": 190, "secd_type": "physical", "secd_max": 190, "secd_min": 175,
 "cast_list": ["talisman_of_death", "rune_of_the_void", "talisman_of_spellshrouding", "holy_hand_grenade", "poison_gas"],
 "talented_skill": "blade_dance"}'),

(
 '{"hp": 3400, "card_name":"癫狂战士", "image_name": "awaken_warrior", "class": "warrior", "range_type" : "near",
 "agi": 50, "hit": 35, "armor": 4500, "block": 0, "dodge": 30, "resist": 35, "critical": 30,
 "prim_type": "physical", "prim_max": 205, "prim_min": 190, "secd_type": "physical", "secd_max": 190, "secd_min": 175,
 "cast_list": ["shield_wall", "sure_hit", "double_swing", "chain_lock", "first_aid"],
 "talented_skill": "blade_dance"}');



CREATE FUNCTION insert_new_player(player_name) RETURNS void AS
$BODY$
BEGIN

    drop table if exists temp_cards;
    drop table if exists card_list;
    drop table if exists default_id;
    select uuid_generate_v4() as id, profile into temp_cards from preset_character_card_profile;
    select json_agg(id) as card_list into card_list from temp_cards;
    select id into default_id from temp_cards order by random() limit 1;

    insert into player_profile(id, profile) values
    (uuid_generate_v4(), json_build_object(
        'player_name', player_name,
        'player_level', 58,
        'default_card', ));
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE