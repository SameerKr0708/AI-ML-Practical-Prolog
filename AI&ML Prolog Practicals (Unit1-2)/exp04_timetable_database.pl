% ============================================================
% Exp 4 : College Timetable Knowledge Base
% Queries about faculty, subjects and classrooms
% Run   : swipl -s exp04_timetable_database.pl
% ============================================================

% teaches(Faculty, Subject)
teaches(dr_sharma, ai).
teaches(prof_verma, java).
teaches(dr_singh,  dbms).
teaches(prof_gupta, python).
teaches(dr_sharma, ml).

% timetable(Subject, Classroom, Day, Time)
timetable(ai,     room101, monday,    '9:00').
timetable(java,   lab2,    monday,    '11:00').
timetable(dbms,   room204, tuesday,   '10:00').
timetable(python, lab1,    wednesday, '9:00').
timetable(ml,     room101, thursday,  '2:00').
timetable(ai,     room101, friday,    '10:00').

% ---------- Rules ----------
faculty_room(F, Room)       :- teaches(F, S), timetable(S, Room, _, _).
faculty_schedule(F, S, D, T) :- teaches(F, S), timetable(S, _, D, T).
subject_taught_by(S, F)     :- teaches(F, S).
room_in_use(Room, S, D, T)  :- timetable(S, Room, D, T).
classes_on(Day, S, Room, T) :- timetable(S, Room, Day, T).

main :-
    writeln('--- Who teaches ai? ---'),
    forall(subject_taught_by(ai, F), (write(F), nl)),
    writeln('--- Subjects taught by dr_sharma ---'),
    forall(teaches(dr_sharma, S), (write(S), nl)),
    writeln('--- Schedule of dr_sharma ---'),
    forall(faculty_schedule(dr_sharma, S1, D, T),
           format("~w on ~w at ~w~n", [S1, D, T])),
    writeln('--- Classes in room101 ---'),
    forall(room_in_use(room101, S2, D2, T2),
           format("~w on ~w at ~w~n", [S2, D2, T2])),
    writeln('--- Classes on monday ---'),
    forall(classes_on(monday, S3, R3, T3),
           format("~w in ~w at ~w~n", [S3, R3, T3])),
    writeln('--- Which faculty uses lab1? ---'),
    forall(faculty_room(F4, lab1), (write(F4), nl)).

:- initialization(main).
