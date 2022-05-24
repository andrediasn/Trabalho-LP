%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

:- module(estudante_db,
          [ attach_estudante_db/1,      % +File
            current_estudante/3,        % ?Matricula, ?Nome, +Cod_Curso
            add_estudante/3,            % +Matricula, +Nome, +Cod_Curso
            set_estudante/3,            % +Matricula, +Nome, +Cod_Curso
            del_estudante/1             % +Matricula
          ]).
:- use_module(library(persistency)).
:- use_module(curso_db).
:- use_module(cursou_db).

:- persistent estudante(matricula:atom, nome:atom, cod_curso:atom).

attach_estudante_db(File) :-
    db_attach(File, []).

current_estudante(Matricula, Nome, Cod_Curso) :-
    estudante(Matricula, Nome, Cod_Curso).

add_estudante(Matricula, Nome, Cod_Curso) :-
    not(estudante(Matricula, _, _)),
    current_curso(Cod_Curso, _),
    assert_estudante(Matricula, Nome, Cod_Curso).

del_estudante(Matricula) :-
    estudante(Matricula, _, _),
    del_cursou(Matricula, _),
    retractall_estudante(Matricula, _, _).

set_estudante(Matricula, Nome, Cod_Curso) :-
    estudante(Matricula, _, _),
    retractall_estudante(Matricula, _, _),
    add_estudante(Matricula, Nome, Cod_Curso).