%%%-------------------------------------------------------------------
%% @doc new_game_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(new_game_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).


%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}

init([]) ->
    {ok, Pools} = application:get_env(new_game_server, pools),
    PoolSpec = lists:map(fun ({PoolName, SizeArgs, WorkerArgs}) ->
                             PoolArgs = [{name, {local, PoolName}},
                                         {worker_module, database_worker}] ++ SizeArgs,
                             poolboy:child_spec(PoolName, PoolArgs, WorkerArgs)
                         end, Pools),
    {ok, { {one_for_one, 10, 10}, PoolSpec} }.

add_pool(Name, PoolArgs, WorkerArgs) ->
    ChildSpec = poolboy:child_spec(Name, PoolArgs, WorkerArgs),
    supervisor:start_child(?MODULE, ChildSpec).