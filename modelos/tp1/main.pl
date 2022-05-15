%% Autor: Oromar Voit de Rezende
%% Matrícula: 201765122C

%% importação dos módulos
:- use_module(estudante_db).
:- use_module(curso_db).
:- use_module(disciplina_db).
:- use_module(cursou_db).
:- use_module(grade_db).

%% definição dos arquivos de persistência
:- attach_estudante_db('estudantes.journal').
:- attach_curso_db('cursos.journal').
:- attach_disciplina_db('disciplinas.journal').
:- attach_cursou_db('cursous.journal').
:- attach_grade_db('grades.journal').

%% habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).

%% Implementação das consultas

%% Funções auxiliares
average( List, Average ):- 
    sumlist( List, Sum ),
    length( List, Length ),
    Length > 0, 
    Average is Sum / Length.

ira(Matricula, Ira) :-
    findall(Nota, current_cursou(Matricula, _, Nota), Notas),
    average(Notas, Ira).

%% histórico escolar de um estudante
historico(Matricula, Disciplinas, Ira) :-
    findall([Codigo,Nota], current_cursou(Matricula, Codigo, Nota), Disciplinas),
    ira(Matricula, Ira).    

%% matriz curricular de um curso
matriz(Curso, Matriz) :-
    findall(Disciplina, current_grade(Curso, Disciplina), Matriz).

%% relação de estudantes que já cursaram uma dada disciplina
rel_estudantes(Disciplina, Estudantes) :-
    findall([Matricula, Nota], current_cursou(Matricula, Disciplina, Nota), Estudantes).

%% ... incluindo critério de seleção por nota
rel_estudantes_nota(Disciplina, Estudantes, [Min, Max]) :-
    findall([Matricula, Nota], (current_cursou(Matricula, Disciplina, Nota), Nota >= Min, Nota =< Max), Estudantes).

%% relação de disciplinas que faltam ser cursadas para um dado estudante
rel_disc_faltantes(Matricula, Disciplinas) :- 
    findall(
        Codigo,
        (
            current_estudante(Matricula, _, Curso),
            current_grade(Curso, Codigo),
            not(current_cursou(Matricula, Codigo, _))
        ),
        Disciplinas).

%% relação de estudantes de um dado curso
rel_estudantes_curso(Curso, Matriculas) :-
    findall(
        Matricula,
        current_estudante(Matricula, _, Curso),
        Matriculas
    ).

%% ... incluindo criterio de seleção por nota
rel_estudantes_curso_disciplina_nota(Curso, Matriculas, Disciplina, [Min, Max]) :-
    findall(
        Matricula,
        (
            current_estudante(Matricula, _, Curso),
            current_grade(Curso, Disciplina),
            current_cursou(Matricula, Disciplina, Nota),
            Nota >= Min,
            Nota =< Max
        ),
        Matriculas
    ).

%% ... incluindo criterio de seleção por IRA
rel_estudantes_curso_ira(Curso, Matriculas, [Min, Max]) :-
    findall(
        Matricula,
        (
            current_estudante(Matricula, _, Curso),
            ira(Matricula, Ira),
            Ira >= Min,
            Ira =< Max
        ),
        Matriculas
    ).

%% relação de cursos que contém uma dada disciplina
rel_cursos_disciplina(Disciplina, Cursos) :-
    findall(Curso, current_grade(Curso, Disciplina), Cursos).