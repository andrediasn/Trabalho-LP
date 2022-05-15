%% Grupo:

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel
%% Matrícula: 

%% Importação dos Módulos
:- use_module(code_db).
:- use_module(words_db).

%% Definição dos arquivos de persistência
:- attach_code_db('code.journal').
:- attach_words_db('words.journal').

%% Implementação das Consultas
code(Char, Code)

string2Code(S, L)