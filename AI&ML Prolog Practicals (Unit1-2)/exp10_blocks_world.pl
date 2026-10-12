% ============================================================
% Exp 10 (title) : Blocks World - represent and validate stacking
% Run   : swipl -s exp10_blocks_world.pl
% Try   : ?- valid_state.   ?- clear(X).   ?- stack_of(a, S).
% ============================================================

% Current configuration:   a      d
%                          b      e
%                          c  ---------  (table)
:- dynamic on/2.

block(a). block(b). block(c). block(d). block(e).

on(a, b).
on(b, c).
on(c, table).
on(d, e).
on(e, table).

% A block is clear if nothing is on top of it
clear(X) :- block(X), \+ on(_, X).

% A block is on the table
on_table(X) :- on(X, table).

% Everything stacked (directly or indirectly) below a block
below(X, Y) :- on(X, Y), Y \== table.
below(X, Z) :- on(X, Y), Y \== table, below(Y, Z).

% Stack from a block down to the table
stack_of(X, [X|Rest]) :- on(X, Y), ( Y == table -> Rest = [table] ; stack_of(Y, Rest) ).

% ---------- Validation rules ----------
valid_on(X, Y) :- block(X), X \== Y, ( Y == table ; block(Y) ).

one_support(X)  :- findall(Y, on(X, Y), [_]).                 % exactly one support
one_on_top(Y)   :- findall(X, (on(X, Y), Y \== table), L), length(L, N), N =< 1.
no_cycle(X)     :- \+ below(X, X).

valid_state :-
    forall(on(X, Y), valid_on(X, Y)),
    forall(block(X), one_support(X)),
    forall(block(Y), one_on_top(Y)),
    forall(block(X), no_cycle(X)).

% ---------- Moving a block ----------
can_move(X, To) :- block(X), clear(X), ( To == table ; ( block(To), To \== X, clear(To) ) ).

move(X, To) :-
    can_move(X, To),
    retract(on(X, _)),
    assertz(on(X, To)).

main :-
    writeln('Clear blocks (nothing on top):'),
    forall(clear(X), format("  ~w~n", [X])),
    stack_of(a, S), format("Stack starting at a: ~w~n", [S]),
    ( valid_state -> writeln('Initial configuration is VALID')
                   ; writeln('Initial configuration is INVALID') ),
    ( can_move(b, d) -> writeln('b can move onto d')
                      ; writeln('b cannot move onto d (b is not clear)') ),
    move(a, table),
    writeln('After move(a, table):'),
    move(b, d),
    writeln('After move(b, d):'),
    forall(on(P, Q), format("  ~w is on ~w~n", [P, Q])),
    ( valid_state -> writeln('New configuration is VALID')
                   ; writeln('New configuration is INVALID') ),
    % Make an invalid state: a on two blocks
    assertz(on(a, c)),
    ( valid_state -> writeln('Broken configuration is VALID')
                   ; writeln('Broken configuration (a on two supports) is INVALID') ).

:- initialization(main).
