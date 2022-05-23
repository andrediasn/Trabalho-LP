:- [main].

%Encriptação de Cesar

translate(Key, Code1, Code2) :- 
  ( Code1 =:= 32 -> Aux #= ((Code1 + 91 - 0'a)+Key)mod 27
  ; Aux #= ((Code1-0'a)+Key)mod 27
  ),
  ( Aux =:= 26 -> Code2 #= 32
  ; Code2 #= 0'a + Aux
  ).


cypher(Key, Char1, Char2) :-
  ( nonvar(Char1) -> char_code(Char1, Code1) ; nonvar(Char2) -> char_code(Char2, Code2) ),
  translate(Key, Code1, Code2),
  char_code(Char1, Code1),
  char_code(Char2, Code2). 

caesar(Key, L1, L2) :-
	maplist(cypher(Key), L1, S2),
  string_chars(L2, S2).
  

process:-
  guitracer,
  trace,
  caesar(2, "ab yz", X).
