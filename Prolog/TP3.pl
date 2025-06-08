score([],[],0).
score([X|Y1],[X|Y2],R1):-score(Y1,Y2,R2),R1 is R2+1.
score([X1|Y1],[X2|Y2],R):-X1\=X2,score(Y1,Y2,R).
qcm(BonnesReponses) :-
    BonnesReponses = [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10],

    % Chaque élément de la liste doit être soit a, b, c, ou d
    member(A1, [a, b, c, d]),
    member(A2, [a, b, c, d]),
    member(A3, [a, b, c, d]),
    member(A4, [a, b, c, d]),
    member(A5, [a, b, c, d]),
    member(A6, [a, b, c, d]),
    member(A7, [a, b, c, d]),
    member(A8, [a, b, c, d]),
    member(A9, [a, b, c, d]),
    member(A10, [a, b, c, d]),

    % Anciennes feuilles de réponses
    F1 = [b,c,b,a,c,c,c,d,c,c],
    F2 = [b,d,c,a,d,d,c,c,a,b],
    F3 = [d,a,b,b,d,d,c,d,a,b],
    F4 = [c,d,c,b,d,b,b,c,a,a],

    % Scores correspondants (fournis dans l'énoncé)
    score(F1, BonnesReponses, 7),
    score(F2, BonnesReponses, 6),
    score(F3, BonnesReponses, 5),
    score(F4, BonnesReponses, 3).

% Définition correcte de min(X1, X2, Min)
min(X1, X2, X1) :- X1 < X2.
min(X1, X2, X2) :- X2 =< X1.

% Remplir le seau de 5 litres (X1)
action([X1, X2], [5, X2]) :- X1 < 5.

% Remplir le seau de 3 litres (X2)
action([X1, X2], [X1, 3]) :- X2 < 3.

% Transvider le seau de 5 litres vers le seau de 3 litres
action([X1, X2], [Y1, Y2]) :-
    X1 > 0, X2 < 3,
    min(X1, 3 - X2, X3), % Calculer la quantité transférable
    Y1 is X1 - X3,
    Y2 is X2 + X3.

% Transvider le seau de 3 litres vers le seau de 5 litres
action([X1, X2], [Y1, Y2]) :-
    X2 > 0, X1 < 5,
    min(X2, 5 - X1, X3), % Calculer la quantité transférable
    Y1 is X1 + X3,
    Y2 is X2 - X3.

% Vider complètement le seau de 5 litres
action([X1, X2], [0, X2]) :- X1 \= 0.

% Vider complètement le seau de 3 litres
action([X1, X2], [X1, 0]) :- X2 \= 0.

% Condition d'arrêt : si le premier élément est [4,_], on a trouvé une solution
solution([[4,_] | _]) :- !.

% Recherche récursive d'une solution
solution([X | Y]) :-
    action(X, X1),  % Générer un nouvel état à partir de X
    \+ member(X1, [X | Y]),  % Vérifier que l'état n'a pas encore été visité
    ,write(X1),solution([X1, X | Y]).  % Continuer la recherche avec le nouvel état





