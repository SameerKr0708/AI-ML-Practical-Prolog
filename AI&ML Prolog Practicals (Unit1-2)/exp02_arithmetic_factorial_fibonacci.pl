% ============================================================
% Exp 2 : Arithmetic operations, Factorial and Fibonacci (recursion)
% Run   : swipl -s exp02_arithmetic_factorial_fibonacci.pl
% Try   : ?- factorial(5, F).    ?- fib_series(10).
% ============================================================

% ---------- Basic arithmetic ----------
add(X, Y, R)      :- R is X + Y.
subtract_(X, Y, R) :- R is X - Y.
multiply(X, Y, R) :- R is X * Y.
divide(_, 0, _)   :- writeln('Error: division by zero'), !, fail.
divide(X, Y, R)   :- R is X / Y.
modulo(X, Y, R)   :- R is X mod Y.
power(X, Y, R)    :- R is X ** Y.

% ---------- Factorial ----------
factorial(0, 1) :- !.
factorial(N, F) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, F1),
    F is N * F1.

% ---------- Fibonacci ----------
fib(0, 0).
fib(1, 1).
fib(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fib(N1, F1),
    fib(N2, F2),
    F is F1 + F2.

% Print first N Fibonacci numbers
fib_series(N) :-
    Last is N - 1,
    forall(between(0, Last, I), (fib(I, F), format("~w ", [F]))),
    nl.

main :-
    add(10, 5, A),        format("10 + 5  = ~w~n", [A]),
    subtract_(10, 5, S),  format("10 - 5  = ~w~n", [S]),
    multiply(10, 5, M),   format("10 * 5  = ~w~n", [M]),
    divide(10, 4, D),     format("10 / 4  = ~w~n", [D]),
    modulo(10, 3, Mo),    format("10 mod 3 = ~w~n", [Mo]),
    power(2, 8, P),       format("2 ^ 8   = ~w~n", [P]),
    factorial(5, F5),     format("Factorial of 5 = ~w~n", [F5]),
    factorial(0, F0),     format("Factorial of 0 = ~w~n", [F0]),
    write('First 10 Fibonacci numbers: '), fib_series(10).

:- initialization(main).
