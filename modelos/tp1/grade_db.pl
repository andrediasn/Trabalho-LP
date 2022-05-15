%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

:- module(grade_db,
          [ attach_grade_db/1,      % +File
            current_grade/2,        % ?Cod_Curso, ?Cod_Disciplina
            add_grade/2,            % +Cod_Curso, +Cod_Disciplina
            del_grade/2             % +Cod_Curso, +Cod_Disciplina
          ]).
:- use_module(library(persistency)).
:- use_module(curso_db).
:- use_module(disciplina_db).

:- persistent grade(cod_curso:atom, cod_disciplina:atom).

attach_grade_db(File) :-
    db_attach(File, []).

current_grade(Cod_Curso, Cod_Disciplina) :-
    grade(Cod_Curso, Cod_Disciplina).

add_grade(Cod_Curso, Cod_Disciplina) :-
    not(grade(Cod_Curso, Cod_Disciplina)),
    current_curso(Cod_Curso, _),
    current_disciplina(Cod_Disciplina, _),
    assert_grade(Cod_Curso, Cod_Disciplina).

del_grade(Cod_Curso, Cod_Disciplina) :-
    grade(Cod_Curso, Cod_Disciplina),
    retractall_grade(Cod_Curso, Cod_Disciplina).