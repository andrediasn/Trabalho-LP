%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(charCode_db, [ 
                attach_charCode_db/1,      % +File
                current_charCode/2,        % ?Char, ?Code
                add_charCode/2,            % +Char, +Code
                set_charCode/2,            % +Char, +Code
                del_charCode/1             % +Char
            ]).

:- use_module(library(persistency)). 

:- persistent charCode(char:atom, code:integer).

attach_charCode_db(File) :-
    db_attach(File, []).

current_charCode(Char, Code) :-
    charCode(Char, Code).

add_charCode(Char, Code) :-
    not(charCode(Char, _)),
    not(charCode(_, Code)),
    assert_charCode(Char, Code).

del_charCode(Char) :-
    charCode(Char, _),
    retractall_charCode(Char, _).

set_charCode(OldChar, OldCode, NewChar, NewCode) :-
    retractall_charCode(OldChar, OldCode),
    add_charCode(NewChar, NewCode).