:- [main].

/* charCypher(KeyCodes, KeyTam, Char1, Char2) :-
    ( 
        nonvar(Char1) -> 
        code(Char1, Code1),

        Code2 is (Code1+Key)mod 27
        ; nonvar(Char2) -> code(Char2, Code2),
        Code1 is (Code2-Key+27)mod 27
    ),
    code(Char1, Code1),
    code(Char2, Code2).  */

cypher([H1|T1],[H2|T2], KeyCodes, KeyTam, N) :-
    nth0(N, KeyCodes, Key),
    code(H1, Code1),
    Code2 is (Code1+Key)mod 27,
    code(H2, Code2),    
    ( KeyTam =:= N -> N is 0 ; N is N+1 ),
    cypher(T1, T2, KeyCodes, KeyTam, N).

size([],0).
size([_|T],N) :- 
    size(T,N1), 
    N is N1+1. 

vigenere(KeyString, S1, S2) :-
    string2Code(KeyString, KeyCodes),
    ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),
    size(KeyCodes, KeyTam),
    N is 0,
    cypher(L1, L2, KeyCodes, KeyTam, N),
    string_chars(S1, L1),
    string_chars(S2, L2).

test(Key, N) :-
    string2Code(Key, KeyCodes),
    size(KeyCodes, N).