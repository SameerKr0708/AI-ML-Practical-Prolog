% ============================================================
% Exp 12 (title) / Exp 11 (description) :
% 3x3 Tic-Tac-Toe game-playing agent using adversarial search (Minimax)
% Human = x, Computer = o (computer maximises, x minimises)
% Run   : swipl -s exp12_tictactoe_adversarial.pl
% Play  : ?- play.        (enter square 1-9 followed by a period)
% Demo  : ?- demo.        (computer plays both sides)
% ============================================================

% Board = list of 9 cells (index 0..8), each x, o or e (empty)
empty_board([e,e,e,e,e,e,e,e,e]).

win_line([0,1,2]). win_line([3,4,5]). win_line([6,7,8]).
win_line([0,3,6]). win_line([1,4,7]). win_line([2,5,8]).
win_line([0,4,8]). win_line([2,4,6]).

other(x, o).
other(o, x).

winner(B, P) :-
    win_line([I, J, K]),
    nth0(I, B, P), nth0(J, B, P), nth0(K, B, P),
    P \== e.

full(B) :- \+ memberchk(e, B).

% move(Board, Player, Index, NewBoard)
move(B, P, I, B2) :-
    nth0(I, B, e, Rest),
    nth0(I, B2, P, Rest).

% ---------- Minimax ----------
% utility: +1 computer (o) wins, -1 human (x) wins, 0 draw
terminal(B, 1)  :- winner(B, o), !.
terminal(B, -1) :- winner(B, x), !.
terminal(B, 0)  :- full(B).

minimax(B, _, S) :- terminal(B, S), !.
minimax(B, P, S) :-
    findall(V, ( move(B, P, _, B2), other(P, Q), minimax(B2, Q, V) ), Vs),
    (   P == o -> max_list(Vs, S) ; min_list(Vs, S) ).

best_move(B, _, 4) :- empty_board(B), !.          % opening shortcut: centre
best_move(B, P, Move) :-
    findall(V-I, ( move(B, P, I, B2), other(P, Q), minimax(B2, Q, V) ), L),
    keysort(L, Sorted),
    (   P == o -> last(Sorted, _-Move) ; Sorted = [_-Move|_] ).

% ---------- Display ----------
show(B) :-
    forall(member(Row, [[0,1,2],[3,4,5],[6,7,8]]),
           ( forall(member(I, Row),
                    ( nth0(I, B, C),
                      (   C == e -> N is I + 1, format(" ~w ", [N])
                      ;   format(" ~w ", [C]) ) )),
             nl )),
    nl.

outcome(B) :- winner(B, W), !, format("~w wins!~n", [W]).
outcome(B) :- full(B), writeln('It is a draw!').

% ---------- Human vs Computer ----------
play :-
    writeln('You are x, computer is o. Squares are numbered 1-9.'),
    empty_board(B), show(B),
    human_turn(B).

human_turn(B) :-
    ask_move(B, I),
    move(B, x, I, B2),
    show(B2),
    (   outcome(B2) -> true ; computer_turn(B2) ).

computer_turn(B) :-
    best_move(B, o, I),
    N is I + 1,
    format("Computer plays ~w~n", [N]),
    move(B, o, I, B2),
    show(B2),
    (   outcome(B2) -> true ; human_turn(B2) ).

ask_move(B, I) :-
    write('Your move (1-9, end with a period): '),
    read(N),
    (   integer(N), N >= 1, N =< 9, I0 is N - 1, nth0(I0, B, e)
    ->  I = I0
    ;   writeln('Invalid move, try again.'), ask_move(B, I)
    ).

% ---------- Computer vs Computer demo ----------
demo :- empty_board(B), demo_loop(B, x).

demo_loop(B, _) :- outcome(B), !.
demo_loop(B, P) :-
    best_move(B, P, I),
    move(B, P, I, B2),
    N is I + 1,
    format("~w plays ~w~n", [P, N]),
    show(B2),
    other(P, Q),
    demo_loop(B2, Q).

main :-
    writeln('Minimax self-play demo (perfect play always ends in a draw):'),
    demo,
    writeln('Type  ?- play.  to play against the computer.').

:- initialization(main).
