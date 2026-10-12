% ============================================================
% Exp 1 : Simple Knowledge Base (Student-Course Database)
% Concepts: Facts, Predicates, Clauses, Goals
% Run   : swipl -s exp01_knowledge_base.pl
% ============================================================

% ---------- FACTS ----------
student(amit).
student(riya).
student(neha).
student(karan).

course(ai).
course(java).
course(dbms).
course(python).

enrolled(amit,  ai).
enrolled(amit,  java).
enrolled(riya,  ai).
enrolled(riya,  python).
enrolled(neha,  dbms).
enrolled(neha,  java).
enrolled(karan, ai).
enrolled(karan, dbms).

likes(amit,  python).
likes(riya,  ai).
likes(neha,  java).
likes(karan, dbms).

% ---------- RULES (clauses with a body) ----------
classmates(X, Y) :- enrolled(X, C), enrolled(Y, C), X \= Y.
studies_and_likes(S, C) :- enrolled(S, C), likes(S, C).

% ---------- GOALS (queries) ----------
main :-
    writeln('--- Goal 1: Who is enrolled in ai? ---'),
    forall(enrolled(S, ai), (write(S), nl)),
    writeln('--- Goal 2: Courses taken by amit ---'),
    forall(enrolled(amit, C), (write(C), nl)),
    writeln('--- Goal 3: Classmates of riya ---'),
    forall(classmates(riya, X), (write(X), nl)),
    writeln('--- Goal 4: Students who study the course they like ---'),
    forall(studies_and_likes(S2, C2), format("~w likes ~w~n", [S2, C2])),
    writeln('--- Goal 5: Is neha enrolled in ai? ---'),
    ( enrolled(neha, ai) -> writeln(yes) ; writeln(no) ).

:- initialization(main).
