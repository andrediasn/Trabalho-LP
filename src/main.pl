%% Grupo:

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel
%% Matrícula: 

%% Importação dos Módulos
:- use_module(library(clpfd)).
:- use_module(charCode_db).

%% Definição dos arquivos de persistência
:- attach_charCode_db('charCodes.journal').

%% Habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- set_prolog_flag(double_quotes, chars).

%% Implementação das Consultas
code(Char, Code) :-
    current_charCode(Char, Code).

string2Code(S,L) :-
    ( nonvar(S) -> maplist(code, S, L)
    ; maplist(code, Aux, L),
      string_chars(S, Aux)
    ).
