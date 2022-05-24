%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(word_db, [ 
                attach_word_db/1,      % +File
                current_word/2,        % ?Char, ?Tam
                add_word/1,            % +Char
                set_word/1,            % +Char
                del_word/1             % +Char
            ]).

:- use_module(library(persistency)). 

:- persistent word(char:atom, tam:integer).

attach_word_db(File) :-
    db_attach(File, []).

current_word(Char, Tam) :-
    word(Char, Tam).

add_word(Char) :-
    not(word(Char, _)),
    string_chars(Char, S),
    size(S, Tam),
    assert_word(Char, Tam).

del_word(Char) :-
    word(Char, _),
    retractall_word(Char, _).

set_word(Char) :-
    word(Char, _),
    retractall_word(Char, _),
    add_word(Char).