permut(L1,L2):-
    length(L1,X),
    length(L2,X),
    permut1(L1,L2).
permut1([],_).
permut1([X|L1],L2):-
    member(X,L2),
    permut1(L1,L2).

declarerG(L,0,L).
declarerG([X|L],N,L2):-
    N>0,
    append(L,[X],L1),
    N1 is N-1,
    declarerG(L1,N1,L2).

declarerD(L,N,R):-
    length(L,X),
    N1 is N mod X,
    N2 is X-N1,
    declarerG(L,N2,R)
    .
