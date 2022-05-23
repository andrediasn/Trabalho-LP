%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

%% Importação dos Módulos
:- use_module(library(clpfd)).
:- use_module(charCode_db).
:- use_module(caesarCypher).
:- use_module(vigenereCypher).

%% Definição dos arquivos de persistência
:- attach_charCode_db('charCodes.journal').

%% Habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- set_prolog_flag(double_quotes, chars).

%% Implementação das Consultas
code(Char, Code) :-
    current_charCode(Char, Code).

string2Code(S,L) :-
    ( 
        nonvar(S) -> maplist(code, S, L)
        ; maplist(code, Aux, L),
        string_chars(S, Aux)
    ).

size([],0).
size([_|T],N) :- 
    size(T,N1), 
    N is N1+1.

process:-
    guitracer,
    trace,
    vigenere("abc", "aaa", X).

teste(Input, KC, KV) :-
    caesar(KC, Input, A),
    caesar(d, B, A),
    vigenere(KV, Input, X),
    vigenere(KV, Y, X),

    format('~n Input: ~w', [Input]),
    format('~n~n Caesar Key: ~w', [KC]),
    format('~n Caesar Encode: ~w', [A]),
    format('~n Caesar Decode: ~w', [B]),
    format('~n~n Vigenere Key: ~w', [KV]),
    format('~n Vigenere Encode: ~w', [X]),
    format('~n Vigenere Decode: ~w', [Y]).

%% teste("aaaaaaaa que linguagem de merda", d, "odio").