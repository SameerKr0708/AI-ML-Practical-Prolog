% ============================================================
% Exp 3 : List operations - append, reverse, member search, length
% Run   : swipl -s exp03_list_operations.pl
% ============================================================

% ---------- Append two lists ----------
my_append([], L, L).
my_append([H|T], L, [H|R]) :- my_append(T, L, R).

% ---------- Reverse a list (accumulator version) ----------
my_reverse(L, R) :- rev_acc(L, [], R).
rev_acc([], Acc, Acc).
rev_acc([H|T], Acc, R) :- rev_acc(T, [H|Acc], R).

% ---------- Search for an element ----------
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

% ---------- Length of a list ----------
my_length([], 0).
my_length([_|T], N) :- my_length(T, N1), N is N1 + 1.

main :-
    my_append([1,2,3], [4,5], A),      format("Append  [1,2,3]+[4,5] = ~w~n", [A]),
    my_reverse([a,b,c,d], R),          format("Reverse [a,b,c,d]     = ~w~n", [R]),
    my_length([10,20,30,40,50], N),    format("Length  [10,20,30,40,50] = ~w~n", [N]),
    ( my_member(c, [a,b,c,d]) -> writeln('c is a member of [a,b,c,d]')
                               ; writeln('c is NOT a member') ),
    ( my_member(z, [a,b,c,d]) -> writeln('z is a member of [a,b,c,d]')
                               ; writeln('z is NOT a member of [a,b,c,d]') ).

:- initialization(main).
