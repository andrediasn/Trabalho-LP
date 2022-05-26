%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(vigenereCypher,
            [ 
                vigenere/3,         % +Keys, ?S1, ?S2
                cypherV/5,          % +Keys, +KeyTam, ?S1, ?S2 , +N
                charCypherV/3,       % +Key, ?Char1, ?Char2
                pairingLists/3,
                completList/4,
                completeListAux/3
            ]).

charCypherV(Key, Char1, Char2) :-
    ( 
        nonvar(Char1) -> code(Char1, Code1),
        Code2 is (Code1+Key)mod 27
        ; nonvar(Char2) -> code(Char2, Code2),
        Code1 is (Code2-Key+27)mod 27
    ),
    code(Char1, Code1),
    code(Char2, Code2). 

cypherV(_,_,[],[],_).
cypherV(KeyCodes, KeyTam, [H1|T1], [H2|T2], N) :-
    nth1(N, KeyCodes, Key),
    charCypherV(Key, H1, H2),
    ( N =:= KeyTam -> N1 is 1 ; N1 is N+1),
    cypherV(KeyCodes, KeyTam, T1, T2, N1).

vigenere(KeyString, S1, S2) :-
    ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),
    string2Code(KeyString, KeyCodes),
    size(KeyCodes, KeyTam),
    N is 1,
    cypherV(KeyCodes, KeyTam, L1, L2, N),
    string_chars(S1, L1),
    string_chars(S2, L2).


    %% ========================= Vigenere Breaker =====================

% Completa uma lista repetindo seus caracteres com o tamanho da outra Lista
/* pairingLists(L1, L2, Output) :-
    length(L2, Tam),
    completList(L1, L1, Output, Tam).


completList(_,_,_,0).
completList(List, [], [H|Y], N) :-
    completList(List, List, [H|Y], N).
completList(List, [H|T], [H|Y], N) :-
    N1 is N - 1,
    completList(List, T, Y, N1).
*/


completeListAux(L, 0, R).
completeListAux(L, N, R) :-
    listConcat(R,L,R1),
    N1 is N - 1,
    completeListAux(L, N1, R1).

completList(L, T1, T2, R) :-
    Q is integer(T1/T2),
    E is T1 - (Q*T2),
    completeListAux(L, Q, R).



pairingLists(L1, L2, Output) :-
    length(L1, Tam1),
    length(L2, Tam2),
    ( Tam2 < Tam1 -> completList(L2, Tam1, Tam2, LR2) ; string_chars(L2, LR2 ) ).
    maplist(L1, L2, Output).