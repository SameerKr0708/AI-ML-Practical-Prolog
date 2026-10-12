% ============================================================
% Exp 9 : Hill Climbing for a numerical optimisation problem
% Objective : maximise f(x) = -(x-7)^2 + 50  (peak at x = 7)
% Run   : swipl -s exp09_hill_climbing.pl
% Try   : ?- hill_climb(0, Best).   ?- hill_climb(20, Best).
% ============================================================

f(X, Y) :- Y is -((X - 7) * (X - 7)) + 50.

step(1).    % neighbours are X+step and X-step

hill_climb(Start, Best) :-
    f(Start, FS),
    format("Start: x = ~w, f(x) = ~w~n", [Start, FS]),
    climb(Start, Best).

climb(X, Best) :-
    step(S),
    Up   is X + S,
    Down is X - S,
    f(X, FX), f(Up, FUp), f(Down, FDown),
    (   FUp > FX, FUp >= FDown
    ->  format("  move up   to x = ~w, f(x) = ~w~n", [Up, FUp]),
        climb(Up, Best)
    ;   FDown > FX
    ->  format("  move down to x = ~w, f(x) = ~w~n", [Down, FDown]),
        climb(Down, Best)
    ;   Best = X                                   % no better neighbour: peak
    ).

main :-
    hill_climb(0, B1),  f(B1, V1),
    format("Optimum found: x = ~w, f(x) = ~w~n~n", [B1, V1]),
    hill_climb(20, B2), f(B2, V2),
    format("Optimum found: x = ~w, f(x) = ~w~n", [B2, V2]).

:- initialization(main).
