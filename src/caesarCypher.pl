%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(caesarCypher, [ 
              caesar/3,       % +Key, ?S1, ?S2
              cypherC/3       % +Key, ?Char1, ?Char2
            ]).


cypherC(Key, Char1, Char2) :-
    ( 
        nonvar(Char1) -> code(Char1, Code1), 
        Code2 is (Code1+Key)mod 27
      ; nonvar(Char2) -> code(Char2, Code2),
        Code1 is (Code2-Key+27)mod 27
    ),
    code(Char1, Code1),
    code(Char2, Code2). 

caesar(KeyChar, S1, S2) :-
    code(KeyChar, KeyCode),
    ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),
	  maplist(cypherC(KeyCode), L1, L2),
    string_chars(S1, L1),
    string_chars(S2, L2).
