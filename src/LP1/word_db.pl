%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(word_db, [ 
                attach_word_db/1,      % +File
                current_word/1,        % ?Char, ?Tam
                add_word/1,            % +Char
                set_word/2,            % +Char
                del_word/1             % +Char
            ]).

:- use_module(library(persistency)). 

:- persistent word(chars:list).

attach_word_db(File) :-
    db_attach(File, []).

current_word(Chars) :-
    word(Chars).

add_word(Chars) :-
    string_chars(Aux, Chars),
    string_lower(Aux, Lower),
    string_chars(Lower, Word),
    not(word(Word)),
    assert_word(Word).

del_word(Chars) :-
    string_chars(Aux, Chars),
    string_lower(Aux, Lower),
    string_chars(Lower, Word),
    retractall_word(Chars).

set_word(Old, New) :-
    retractall_word(Old),
    add_word(New).