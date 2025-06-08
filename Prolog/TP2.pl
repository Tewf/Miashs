ecart(A,B,C):- A<B,C is B-A.
ecart(A,B,C):- B=<A,C is A-B.

% Vérifier si un nombre est premier
premier(N) :-
    N > 1,
    R is floor(sqrt(N)),
    \+ (between(2, R, X), N mod X =:= 0).

% Vérifier si deux nombres sont premiers, ont une différence de 8 et des milliers différents
premiersDiff8(A, B) :-
    between(1, 9999, A),
    B is A + 8,  % On évite la redondance en calculant directement B
    B =< 9999,   % On s'assure que B reste dans la plage demandée
    premier(A),
    premier(B),
    (A // 1000)=\= (B // 1000).   % Vérifier que les chiffres des milliers sont différents

% Une liste vide ou une liste à un seul élément est forcément constituée d'éléments uniques.
tousDifferents([]).
tousDifferents([X|L]) :-
    \+ member(X, L), % Vérifie que X n'est pas déjà dans L
    tousDifferents(L). % Vérifie récursivement pour le reste de la liste:

% Résolution de l'équation FRERE + SOEUR = BASTON
solution([F,R,E,S,O,U,B,A,T,N]) :-
    % Assigner des chiffres uniques aux lettres
    L = [F,R,E,S,O,U,B,A,T,N],
    tousDifferents(L), % Vérifie que tous les chiffres sont distincts
    between(0,9,F), between(0,9,R), between(0,9,E), between(0,9,S),
    between(0,9,O), between(0,9,U), between(0,9,B), between(0,9,A),
    between(0,9,T), between(0,9,N),

    % Les premiers chiffres des nombres ne doivent pas être 0
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
