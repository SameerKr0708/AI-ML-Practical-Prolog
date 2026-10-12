% ============================================================
% Exp 10 (description) : Rule-based Expert System for Fault Diagnosis
% (Car trouble) using IF-THEN production rules
% Run   : swipl -s exp10_expert_system_fault_diagnosis.pl
% Interactive : ?- diagnose.   (answer with  yes.  or  no.  )
% ============================================================

:- dynamic known/2.

symptom(engine_does_not_crank).
symptom(headlights_are_dim).
symptom(engine_cranks_but_wont_start).
symptom(fuel_gauge_shows_empty).
symptom(engine_overheats).
symptom(coolant_level_is_low).
symptom(brakes_squeal).
symptom(brake_pedal_feels_soft).
symptom(black_smoke_from_exhaust).

% ---------- Production rules: IF symptoms THEN fault ----------
fault(dead_battery)        :- ask(engine_does_not_crank), ask(headlights_are_dim).
fault(out_of_fuel)         :- ask(engine_cranks_but_wont_start), ask(fuel_gauge_shows_empty).
fault(faulty_spark_plugs)  :- ask(engine_cranks_but_wont_start), \+ ask(fuel_gauge_shows_empty).
fault(coolant_leak)        :- ask(engine_overheats), ask(coolant_level_is_low).
fault(faulty_thermostat)   :- ask(engine_overheats), \+ ask(coolant_level_is_low).
fault(worn_brake_pads)     :- ask(brakes_squeal).
fault(air_in_brake_line)   :- ask(brake_pedal_feels_soft).
fault(clogged_air_filter)  :- ask(black_smoke_from_exhaust).

advice(dead_battery,       'Recharge or replace the battery.').
advice(out_of_fuel,        'Refuel the vehicle.').
advice(faulty_spark_plugs, 'Inspect and replace the spark plugs.').
advice(coolant_leak,       'Check hoses/radiator for leaks and top up coolant.').
advice(faulty_thermostat,  'Replace the thermostat.').
advice(worn_brake_pads,    'Replace the brake pads.').
advice(air_in_brake_line,  'Bleed the brake system.').
advice(clogged_air_filter, 'Clean or replace the air filter.').

% ---------- Knowledge acquisition ----------
ask(Q) :- known(Q, yes), !.
ask(Q) :- known(Q, no),  !, fail.
ask(Q) :-
    format("Is it true that: ~w? (yes. / no.) ", [Q]),
    read(Ans),
    assertz(known(Q, Ans)),
    Ans == yes.

report :-
    findall(F, fault(F), Faults0), sort(Faults0, Faults),
    (   Faults == []
    ->  writeln('No known fault matches these symptoms. Consult a mechanic.')
    ;   forall(member(F, Faults),
               ( advice(F, A), format("Possible fault: ~w~n  Advice: ~w~n", [F, A]) ))
    ).

diagnose :-
    retractall(known(_, _)),
    writeln('--- Car Fault Diagnosis Expert System ---'),
    report.

% ---------- Non-interactive demo ----------
demo_case(YesList) :-
    retractall(known(_, _)),
    forall(symptom(S),
           ( memberchk(S, YesList) -> assertz(known(S, yes)) ; assertz(known(S, no)) )),
    format("Symptoms present: ~w~n", [YesList]),
    report, nl.

main :-
    demo_case([engine_does_not_crank, headlights_are_dim]),
    demo_case([engine_overheats, coolant_level_is_low]),
    demo_case([engine_cranks_but_wont_start, fuel_gauge_shows_empty]),
    demo_case([brakes_squeal, brake_pedal_feels_soft]),
    demo_case([]),
    writeln('Type  ?- diagnose.  for the interactive version.').

:- initialization(main).
