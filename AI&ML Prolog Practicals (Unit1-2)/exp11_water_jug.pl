% ============================================================
% Exp 11 (title) / Exp 12 (description) : Water Jug Problem
% State-space search (BFS) and display of the sequence of states
% Jug A = 4 litres, Jug B = 3 litres, goal: exactly 2 litres in Jug A
% Run   : swipl -s exp11_water_jug.pl
% Try   : ?- solve.
% ============================================================

capacity(a, 4).
capacity(b, 3).

% state = (A, B) : litres currently in jug A and jug B
goal((2, _)).

% move(State, NewState, Description)
move((A, B), (4, B), 'Fill jug A')   :- A < 4.
move((A, B), (A, 3), 'Fill jug B')   :- B < 3.
move((A, B), (0, B), 'Empty jug A')  :- A > 0.
move((A, B), (A, 0), 'Empty jug B')  :- B > 0.
move((A, B), (A1, B1), 'Pour A into B') :-
    A > 0, B < 3,
    T is min(A, 3 - B),
    A1 is A - T, B1 is B + T.
move((A, B), (A1, B1), 'Pour B into A') :-
    B > 0, A < 4,
    T is min(B, 4 - A),
    A1 is A + T, B1 is B - T.

% BFS: queue of reversed paths, each element is State-Action
solve :-
    Start = (0, 0),
    bfs([[Start-'Start (both jugs empty)']], [Start], Path),
    writeln('Sequence of states leading to the goal (A, B):'),
    print_path(Path, 0),
    length(Path, L), Steps is L - 1,
    format("Goal reached in ~w steps.~n", [Steps]).

bfs([[S-Act|Rest]|_], _, Path) :-
    goal(S), !,
    reverse([S-Act|Rest], Path).
bfs([[S-Act|Rest]|Queue], Visited, Path) :-
    findall([S2-Mv, S-Act|Rest],
            ( move(S, S2, Mv), \+ memberchk(S2, Visited) ),
            NewPaths),
    findall(S2, member([S2-_|_], NewPaths), NewStates),
    append(Visited, NewStates, Visited2),
    append(Queue, NewPaths, Queue2),
    bfs(Queue2, Visited2, Path).

print_path([], _).
print_path([(A, B)-Act|T], N) :-
    format("Step ~w: (~w, ~w)   <- ~w~n", [N, A, B, Act]),
    N1 is N + 1,
    print_path(T, N1).

main :- solve.

:- initialization(main).
