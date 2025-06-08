%Exo1
%0
filtre([Y|Liste],X0,0,[Y|Resultat]):-
    Y>X0,
    filtre(Liste,X0,0,Resultat).

filtre([Y|Liste],X0,0,[Resultat]):-
    Y=<X0,
    filtre(Liste,X0,0,Resultat).
%1
filtre([Y|Liste],X0,1,[Y|Resultat]):-
    Y<X0,
    filtre(Liste,X0,1,Resultat).

filtre([Y|Liste],X0,1,[Resultat]):-
    X0=<Y,
    filtre(Liste,X0,1,Resultat).

filtre([],_,_,[]).

%Exo2
%a

listEqual([X0|Liste0],[X0|Liste1]):-
     listEqual(Liste0,Liste1).

listEqual([],[]).

firstNelements(_,0,[]).
firstNelements([],_,[]).

firstNelements([X0|Liste0],N,[X0|Result]):-
    N1 is N-1,
    firstNelements(Liste0,N1,Result).


appartientListe(Liste0,Liste1):-
    length(Liste0,L),
    firstNelements(Liste1,L,Check),
    listEqual(Liste0,Check).

appartientListe(Liste0,[X0|Liste1]):-
    appartientListe(Liste0,Liste1).



%b

motCache(List0,[X1|List1]):-
    appartientListe(List0,X1).

motCache(List0,[X1|List1]):-
    motCache(List0,List1).


motCache(_,[]):-fail.

%c
eplucher([[X0|L0]|L1],[X0|R0],[L0|R1]):-
    eplucher(L1,R0,R1).
eplucher([],[],[]).

inverseLigCol(L0,[R0|R1]):-
    eplucher(L0,R0,L1),
    inverseLigCol(L1,R1)
    .
inverseLigCol(L,[]):-
    member([],L).
%



