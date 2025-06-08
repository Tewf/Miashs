% Vérifie que tous les éléments d'une liste sont distincts
tousDifferents([]).
tousDifferents([X|L]) :-
    \+ member(X, L), % Vérifie que X n'est pas dans le reste de la liste
    tousDifferents(L).

% Résolution de l'équation FRERE + SOEUR = BASTON
solution([F,R,E,S,O,U,B,A,T,N]) :-
    % Assigner des chiffres aux lettres
    between(0, 9, F), between(0, 9, R), between(0, 9, E),
    between(0, 9, S), between(0, 9, O), between(0, 9, U),
    between(0, 9, B), between(0, 9, A), between(0, 9, T), between(0, 9, N),

    % Vérifier que tous les chiffres sont distincts
    tousDifferents([F,R,E,S,O,U,B,A,T,N]),

    % Les premiers chiffres ne doivent pas être 0
    F \= 0, S \= 0, B \= 0,

    % Conversion des mots en nombres
    FRERE is 10000*F + 1000*R + 100*E + 10*R + E,
    SOEUR is 10000*S + 1000*O + 100*E + 10*U + R,
    BASTON is 100000*B + 10000*A + 1000*S + 100*T + 10*O + N,

    % Vérifier l'équation
    FRERE + SOEUR =:= BASTON,

    % Affichage de la solution
    writef("%d%d%d%d%d + %d%d%d%d%d = %d%d%d%d%d%d\n",
        [F,R,E,R,E,S,O,E,U,R,B,A,S,T,O,N]).


