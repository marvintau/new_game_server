-module(add_profile_handler).

-export([init/2]).
-export([content_types_provided/2, content_types_accepted/2]).
-export([allow_missing_posts/2]).
-export([allowed_methods/2]).
-export([handle_post/2]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

allowed_methods(Req, Opts) ->
    {[<<"POST">>], Req, Opts}.

content_types_accepted(Req, State) ->

    {[
        {<<"application/text">>, handle_post},
        {<<"application/json">>, handle_post}
    ], Req, State}.


% note that the method won't be called since the callback
% specified here will be only called when GET and HEAD request
% being processed.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>, handle_post}
    ], Req, State}.


allow_missing_posts(Req, State) ->
    {false, Req, State}.


handle_post(Req, State) ->

    {ReqBody, NextReq} = try cowboy_req:read_body(Req) of
        {ok, ReqBodyRaw, NewReq} ->
            {ReqBodyRaw, NewReq}
    catch
        error:Error ->
            erlang:display(Error),
            {<<"Nah">>, Req}
    end,
    

    Data = jiffy:decode(ReqBody),
    %ParsedProfile = battle_parse:parse_single_player(Data),

    error_logger:info_report(Data),

    {ok, Conn} = epgsql:connect("localhost", "yuetao", "asdasdasd", [
        {database, "dungeon"},
        {timeout, 100}
    ]),


    PayLoad = list_to_binary([
        "insert into player_profile (profile) values ('",
        Data,
        "')"
    ]), 

    error_logger:info_report(PayLoad),
    
    InsertRes = epgsql:squery(Conn, binary_to_list(PayLoad)),

    ok = epgsql:close(Conn),


    error_logger:info_report([InsertRes]),

    Res = cowboy_req:set_resp_body(<<"ok">>, NextReq),
    {true, Res, State}.

