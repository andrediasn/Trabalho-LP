%% Grupo:

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel
%% Matrícula: 

:- module(code_db,
          [ attach_code_db/1,      % +File
            current_code/2,        % ?Char, ?Code
            add_code/2,            % +Char, +Code
            set_code/2,            % +Char, +Code
            del_code/1             % +Char
          ]).

:- use_module(library(persistency)). 

:- persistent code(codigo:atom, nome:atom).