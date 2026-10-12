% ============================================================
% Exp 5 : Student Performance Analysis (rule-based reasoning)
% Topper  : marks >= 85
% Average : 40 <= marks < 85
% Fail    : marks < 40
% Run     : swipl -s exp05_student_performance.pl
% ============================================================

% marks(Student, Marks)
marks(amit,  92).
marks(riya,  88).
marks(neha,  67).
marks(karan, 54).
marks(pooja, 39).
marks(rahul, 25).
marks(simran, 75).

% ---------- Rules ----------
topper(S)  :- marks(S, M), M >= 85.
average(S) :- marks(S, M), M >= 40, M < 85.
failed(S)  :- marks(S, M), M < 40.

classify(S, topper)  :- topper(S), !.
classify(S, average) :- average(S), !.
classify(S, fail)    :- failed(S).

main :-
    writeln('--- Toppers ---'),
    forall(topper(S1),  (marks(S1, M1), format("~w (~w)~n", [S1, M1]))),
    writeln('--- Average performers ---'),
    forall(average(S2), (marks(S2, M2), format("~w (~w)~n", [S2, M2]))),
    writeln('--- Failed students ---'),
    forall(failed(S3),  (marks(S3, M3), format("~w (~w)~n", [S3, M3]))),
    writeln('--- Full report ---'),
    forall(marks(S, M), (classify(S, C), format("~w scored ~w -> ~w~n", [S, M, C]))).

:- initialization(main).
