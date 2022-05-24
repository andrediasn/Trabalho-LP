:- use_module(library(clpfd)).


%% habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- set_prolog_flag(double_quotes, chars).

cypher(Key, A, B) :-
    B #= 0'a+((A-0'a)+Key).

xcypher(Key, ACh, BCh) :-
   ( nonvar(ACh) -> char_code(ACh, A) ; nonvar(BCh) -> char_code(BCh, B) ),
   cypher(Key, A, B),
   char_code(ACh, A),
   char_code(BCh, B). 

caesar(Key, L1, L2) :-
	maplist(xcypher(Key), L1, L2).
