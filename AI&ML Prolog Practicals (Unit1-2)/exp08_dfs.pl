% ============================================================
% Exp 8 : Depth-First Search (state-space tree / graph)
% Run   : swipl -s exp08_dfs.pl
% Try   : ?- dfs(a, g, Path).
% ============================================================

edge(a, b).
edge(a, c).
edge(b, d).
edge(b, e).
edge(c, f).
edge(e, g).
edge(f, g).

connected(X, Y) :- edge(X, Y).
connected(X, Y) :- edge(Y, X).

% dfs(Start, Goal, Path): first path found going deep first
dfs(Start, Goal, Path) :-
    dfs_visit(Start, Goal, [Start], RevPath),
    reverse(RevPath, Path).

dfs_visit(Goal, Goal, Visited, Visited).
dfs_visit(Node, Goal, Visited, Path) :-
    connected(Node, Next),
    \+ memberchk(Next, Visited),
    dfs_visit(Next, Goal, [Next|Visited], Path).

% DFS traversal order from a start node
dfs_order(Start, Order) :-
    dfs_trav([Start], [], RevOrder),
    reverse(RevOrder, Order).

dfs_trav([], Visited, Visited).
dfs_trav([N|Stack], Visited, Order) :-
    (   memberchk(N, Visited)
    ->  dfs_trav(Stack, Visited, Order)
    ;   findall(X, connected(N, X), Ns),
        append(Ns, Stack, NewStack),            % LIFO stack => depth first
        dfs_trav(NewStack, [N|Visited], Order)
    ).

main :-
    ( dfs(a, g, P) -> atomic_list_concat(P, ' -> ', T),
                      format("DFS path a to g: ~w~n", [T])
                    ; writeln('No path') ),
    dfs_order(a, O), atomic_list_concat(O, ', ', OT),
    format("DFS traversal order from a: ~w~n", [OT]),
    writeln('All paths from a to g:'),
    forall(dfs(a, g, AP),
           ( atomic_list_concat(AP, ' -> ', AT), format("  ~w~n", [AT]) )).

:- initialization(main).
