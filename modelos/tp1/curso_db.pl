%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

:- module(curso_db,
          [ attach_curso_db/1,      % +File
            current_curso/2,        % ?Codigo, ?Nome
            add_curso/2,            % +Codigo, +Nome
            set_curso/2,            % +Codigo, +Nome
            del_curso/1             % +Codigo
          ]).
:- use_module(library(persistency)).
:- use_module(grade_db).

:- persistent curso(codigo:atom, nome:atom).

attach_curso_db(File) :-
    db_attach(File, []).

current_curso(Codigo, Nome) :-
    curso(Codigo, Nome).

add_curso(Codigo, Nome) :-
    not(curso(Codigo, _)),
    assert_curso(Codigo, Nome).

del_curso(Codigo) :-
    curso(Codigo, _),
    del_grade(Codigo, _),
    retractall_curso(Codigo, _).

set_curso(Codigo, Nome) :-
    curso(Codigo, _),
    retractall_curso(Codigo, _),
    add_curso(Codigo, Nome).