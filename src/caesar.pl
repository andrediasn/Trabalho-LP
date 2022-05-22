:- [main].

cypher(Key, Char1, Char2) :-
  ( nonvar(Char1) -> code(Char1, Code1),
    Code2 is (Code1+Key)mod 27
   ; nonvar(Char2) -> code(Char2, Code2),
    Code1 is (Code2-Key+27)mod 27
  ),
  code(Char1, Code1),
  code(Char2, Code2). 

caesar(Key, S1, S2) :-
  code(Key, KeyCode),
  ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),
	maplist(cypher(KeyCode), L1, L2),
  string_chars(S1, L1),
  string_chars(S2, L2).
  

process:-
  guitracer,
  trace,
  caesar(b, "ab yz", X).
