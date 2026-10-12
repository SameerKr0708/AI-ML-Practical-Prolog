% ============================================================
% Exp 6 : Travel Route Recommendation System
% City connections (facts) + inference rules
% NOTE: distances (km) are approximate sample data.
% Run   : swipl -s exp06_route_recommendation.pl
% Try   : ?- route(raipur, nagpur, Path, Dist).
%         ?- shortest_route(raipur, jagdalpur, Path, Dist).
% ============================================================

% road(CityA, CityB, DistanceKm)  (roads are two-way)
road(raipur,   durg,       40).
road(raipur,   bilaspur,  115).
road(raipur,   jagdalpur, 300).
road(raipur,   nagpur,    285).
road(durg,     nagpur,    270).
road(bilaspur, korba,      70).
road(bilaspur, ambikapur, 230).
road(korba,    ambikapur, 190).
road(jagdalpur, nagpur,   600).

connected(A, B, D) :- road(A, B, D).
connected(A, B, D) :- road(B, A, D).

% ---------- All simple routes (no city visited twice) ----------
route(Start, End, Path, Dist) :-
    travel(Start, End, [Start], RevPath, Dist),
    reverse(RevPath, Path).

travel(End, End, Visited, Visited, 0).
travel(Cur, End, Visited, Path, Dist) :-
    connected(Cur, Next, D1),
    \+ memberchk(Next, Visited),
    travel(Next, End, [Next|Visited], Path, D2),
    Dist is D1 + D2.

% ---------- Recommend the shortest route ----------
shortest_route(Start, End, BestPath, BestDist) :-
    findall(D-P, route(Start, End, P, D), Routes),
    Routes \== [],
    keysort(Routes, [BestDist-BestPath|_]).

recommend(Start, End) :-
    (   shortest_route(Start, End, Path, Dist)
    ->  atomic_list_concat(Path, ' -> ', Text),
        format("Recommended route: ~w (~w km)~n", [Text, Dist])
    ;   format("No route found from ~w to ~w~n", [Start, End])
    ).

main :-
    writeln('--- All routes from raipur to korba ---'),
    forall(route(raipur, korba, P, D), format("~w : ~w km~n", [P, D])),
    writeln('--- Recommendations ---'),
    recommend(raipur, korba),
    recommend(durg, jagdalpur),
    recommend(korba, nagpur),
    recommend(raipur, mumbai).

:- initialization(main).
