retirer(_, [], []).
retirer(E, [E|T], T) :- !.
% Enlève la première occurrence uniquement
retirer(E, [H|T], [H|R]) :-
    retirer(E, T, R).

inverser(Liste, Inverse) :-
    inverser(Liste, [], Inverse).

inverser([], Acc, Acc).
inverser([T|Q], Acc, Resultat) :-
    inverser(Q, [T|Acc], Resultat).

% Cas de base : on a atteint 0, plus rien à faire.
leCompteEstBon(LF,V,[]):-member(V,LF).
% Opération + : Target = X0 + Y  =>  Y = Target - X0
leCompteEstBon(L0, Target, [[X0, +, Y,Target]|Resultat]) :-
    member(X0,L0),
    retirer(X0,L0,L1),

    Y is Target - X0,
    leCompteEstBon(L1, Y, Resultat).

% Opération - : Target = X0 - Y  =>  Y = X0 - Target
leCompteEstBon(L0, Target, [[X0, -, Y,=,Target]|Resultat]) :-
    member(X0,L0),
    retirer(X0,L0,L1),
    Y is X0 - Target,
    leCompteEstBon(L1, Y, Resultat).

% Opération - inversée : Target = Y - X0  =>  Y = Target + X0
leCompteEstBon(L0, Target, [[Y, -, X0,=,Target]|Resultat]) :-
    member(X0,L0),
    retirer(X0,L0,L1),

    Y is Target + X0,
    leCompteEstBon(L1, Y, Resultat).
leCompteEstBon1(X0,X1,Result1):-
    leCompteEstBon(X0,X1,Result0),
    inverser(Result0,Result1).
% Opération * : Target = X0 * Y  =>  Y = Target / X0 (si divisible)
leCompteEstBon(L0, Target, [[X0, *, Y,Target]|Resultat]) :-
    member(X0,L0),
    retirer(X0,L0,L1),

    X0 =\= 0,
    0 is Target mod X0,
    Y is Target // X0,
    leCompteEstBon(L1, Y, Resultat).

%Exo2
wow([X0|L0]):-
    inverser([X0|L0],[X1|_]),
    X0==X1.
selectionwow(L):-
    member(X,L),
    mot(X),
    string_chars(X,X0),
    wow(X0).
