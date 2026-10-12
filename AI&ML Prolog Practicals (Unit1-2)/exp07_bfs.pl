% ============================================================
% Exp 7 : Breadth-First Search (shortest path in a graph)
% Run   : swipl -s exp07_bfs.pl
% Try   : ?- bfs(a, g, Path).
% ============================================================

%        a
%      /   \
%     b     c
%    / \     \
%   d   e     f
%       |     |
%       g ----+
edge(a, b).
edge(a, c).
edge(b, d).
edge(b, e).
edge(c, f).
edge(e, g).
edge(f, g).

connected(X, Y) :- edge(X, Y).
connected(X, Y) :- edge(Y, X).

% bfs(Start, Goal, Path): Path has the fewest edges
bfs(Start, Goal, Path) :-
    bfs_queue([[Start]], Goal, [Start], RevPath),
    reverse(RevPath, Path).

% Queue holds reversed paths: [CurrentNode, ..., Start]
bfs_queue([[Goal|Rest]|_], Goal, _, [Goal|Rest]) :- !.
bfs_queue([[Node|Rest]|Queue], Goal, Visited, Path) :-
    findall([Next, Node|Rest],
            ( connected(Node, Next), \+ memberchk(Next, Visited) ),
            NewPaths),
    findall(N, member([N|_], NewPaths), NewNodes),
    append(Visited, NewNodes, NewVisited),
    append(Queue, NewPaths, NewQueue),          % FIFO queue => breadth first
    bfs_queue(NewQueue, Goal, NewVisited, Path).

show_path(S, G) :-
    (   bfs(S, G, P)
    ->  length(P, L), Edges is L - 1,
        atomic_list_concat(P, ' -> ', T),
        format("BFS ~w to ~w: ~w  (~w edges)~n", [S, G, T, Edges])
    ;   format("No path from ~w to ~w~n", [S, G])
    ).

main :-
    show_path(a, g),
    show_path(a, d),
    show_path(d, f),
    show_path(a, z).

:- initialization(main).
