:- [main].

size([],0).
size([_|T],N) :- 
    size(T,N1), 
    N is N1+1. 

charCypher(Key, Char1, Char2) :-
    ( 
    nonvar(Char1) -> code(Char1, Code1),
    Code2 is (Code1+Key)mod 27
    ; nonvar(Char2) -> code(Char2, Code2),
    Code1 is (Code2-Key+27)mod 27
    ),
    code(Char1, Code1),
    code(Char2, Code2). 

cypher(_,_,[],[],_).
cypher(KeyCodes, KeyTam, [H1|T1], [H2|T2], N) :-
    nth1(N, KeyCodes, Key),
    charCypher(Key, H1, H2),
    ( N =:= KeyTam -> N is 1 ; N is N+1),
    cypher(KeyCodes, KeyTam, T1, T2, N).

vigenere(KeyString, S1, S2) :-
    ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),
    string2Code(KeyString, KeyCodes),
    size(KeyCodes, KeyTam),
    S2 is KeyTam.
    /* N is 1,
    cypher(KeyCodes, KeyTam, L1, L2, N),
    string_chars(S1, L1),
    string_chars(S2, L2). */
  
test(X, Y, Z) :-
    nth0(X, Y, Z).

process:-
    guitracer,
    trace,
    caesar(b, "ab yz", X).