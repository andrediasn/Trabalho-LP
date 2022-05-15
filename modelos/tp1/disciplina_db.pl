%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

:- module(disciplina_db,
          [ attach_disciplina_db/1,      % +File
            current_disciplina/2,        % ?Codigo, ?Nome
            add_disciplina/2,            % +Codigo, +Nome
            set_disciplina/2,            % +Codigo, +Nome
            del_disciplina/1             % +Codigo
          ]).
:- use_module(library(persistency)).
:- use_module(grade_db).
:- use_module(cursou_db).

:- persistent disciplina(codigo:atom, nome:atom).

attach_disciplina_db(File) :-
    db_attach(File, []).

current_disciplina(Codigo, Nome) :-
    disciplina(Codigo, Nome).

add_disciplina(Codigo, Nome) :-
    not(disciplina(Codigo, _)),
    assert_disciplina(Codigo, Nome).

del_disciplina(Codigo) :-
    disciplina(Codigo, _),
    del_grade(_, Codigo),
    del_cursou(_, Codigo),
    retractall_disciplina(Codigo, _).

set_disciplina(Codigo, Nome) :-
    disciplina(Codigo, _),
    retractall_disciplina(Codigo, _),
    add_disciplina(Codigo, Nome).