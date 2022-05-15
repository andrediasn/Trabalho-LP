%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

:- module(cursou_db,
          [ attach_cursou_db/1,      % +File
            current_cursou/3,        % ?Matricula, ?Codigo, ?Nota
            add_cursou/3,            % +Matricula, +Codigo, +Nota
            set_cursou/3,            % +Matricula, +Codigo, +Nota
            del_cursou/2             % +Matricula, +Codigo, +Nota
          ]).
:- use_module(library(persistency)).
:- use_module(estudante_db).
:- use_module(disciplina_db).

:- persistent cursou(matricula:atom, codigo:atom, nota:number).

attach_cursou_db(File) :-
    db_attach(File, []).

current_cursou(Matricula, Codigo, Nota) :-
    cursou(Matricula, Codigo, Nota).

add_cursou(Matricula, Codigo, Nota) :-
    not(cursou(Matricula, Codigo, _)),
    current_estudante(Matricula, _, _),
    current_disciplina(Codigo, _),
    assert_cursou(Matricula, Codigo, Nota).

del_cursou(Matricula, Codigo) :-
    cursou(Matricula, Codigo, _),
    retractall_cursou(Matricula, Codigo, _).

set_cursou(Matricula, Codigo, Nota) :-
    del_cursou(Matricula, Codigo),
    add_cursou(Matricula, Codigo, Nota).