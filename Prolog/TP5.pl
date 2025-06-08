solution(Manege):-
    %longueur
    length(Manege,8),
    %unicité
    is_set(Manege),

    %Contrainte d'enfant
    member(place(betty,_),Manege),
    member(place(didier,soucoupevolante),Manege),
    member(place(jean,_),Manege),
    member(place(lisette,_),Manege),
    member(place(marc,_),Manege),
    member(place(pauline,_),Manege),
    member(place(robert,_),Manege),
    member(place(sylvie,_),Manege),

    %Contrainte de véhicule
    member(place(_,cheval0),Manege),
    member(place(_,cheval1),Manege),
    member(place(_,cheval2),Manege),
    member(place(_,voiture0),Manege),
    member(place(_,voiture1),Manege),
    member(place(_,soucoupevolante),Manege),
    member(place(_,camion),Manege),
    member(place(_,carosse),Manege),

    %Choix vehicule
    (   member(place(robert,cheval0),Manege);
        member(place(robert,cheval1),Manege);
        member(place(robert,cheval2),Manege)),

    (   member(place(betty,voiture0),Manege);
        member(place(betty,voiture1),Manege)),

     not(   member(place(pauline,cheval0),Manege);
        member(place(pauline,cheval1),Manege);
        member(place(pauline,cheval2),Manege)),

    %Choix emplacement
    % Choix emplacement

% 1. Betty est à côté de Jean
(
    nextto(place(betty,_), place(jean,_), Manege);
    nextto(place(jean,_), place(betty,_), Manege)
),

% 2. Lisette est entre Marc et Robert (dans n'importe quel ordre)
(
    (
        nextto(place(marc,_), place(lisette,_), Manege),
        nextto(place(lisette,_), place(robert,_), Manege)
    );
    (
        nextto(place(robert,_), place(lisette,_), Manege),
        nextto(place(lisette,_), place(marc,_), Manege)
    )
),

% 3. Pauline est à côté de Marc
(
    nextto(place(pauline,_), place(marc,_), Manege);
    nextto(place(marc,_), place(pauline,_), Manege)
),

% 4. Sylvie est à côté de Didier
(
    nextto(place(sylvie,_), place(didier,_), Manege);
    nextto(place(didier,_), place(sylvie,_), Manege)
).










