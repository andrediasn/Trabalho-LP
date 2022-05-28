%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

%% Importação dos Módulos
:- use_module(library(clpfd)).  % Biblioteca para operações aritiméticas 
:- use_module(charCode_db).     % BD dos codigigos das letras
:- use_module(word_db).         % BD das palavras salvas
:- use_module(caesarCypher).    % Modulo da cifra de César
:- use_module(vigenereCypher).  % Modulo da cifra de Vegenere

%% Definição dos arquivos de persistência
:- attach_charCode_db('charCodes.journal').
:- attach_word_db('words.journal').

%% Habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- set_prolog_flag(double_quotes, chars).

    %%%%%%%%%%%%%%%%%%% Predicados Pedidos %%%%%%%%%%%%%%%%%%%%%%
code(Char, Code) :-
    current_charCode(Char, Code).

string2Code(S,L) :-
    (nonvar(S) -> 
        maplist(code, S, L)
    ;   
        maplist(code, Aux, L),
        string_chars(S, Aux)
    ).

    %%%%%%%%%%%%%%%%%%% Predicados Utilitários %%%%%%%%%%%%%%%%%%%%%%

%Função para testar as cifras
cyphers(Input, KC, KV) :-                   % Input, Caesar Key, Vigenere Key                       
    caesar(KC, Input, A),
    caesar(d, B, A),
    vigenere(KV, Input, X),
    vigenere(KV, Y, X),

    format('~n~n Caesar Key: ~w', [KC]),
    format('~n Caesar Encode: ~w', [A]),
    format('~n Caesar Decode: ~w', [B]),
    format('~n~n Vigenere Key: ~w', [KV]),
    format('~n Vigenere Encode: ~w', [X]),
    format('~n Vigenere Decode: ~w', [Y]).
%% teste("aaaaaaaa que linguagem de booa", d, "acabou").

% Cria uma lista com as Palavras salvas
wordSave(L) :- 
    findall(W, current_word(W,_),L).

% Calcula o tamanho de uma lista  -- Deprecated (Usar length no lugar)
size([],0).
size([_|T],N) :-            
    size(T,N1), 
    N is N1+1.

% Conta quantas vezes um Char aparece na String
countChar([], _, 0).
countChar([H|T], Char, Freq) :-                  %Conta a frequencia daquele Char
    countChar(T, Char, F1),
    code(H,A),
    code(Char,B),
    ( A =:= B -> Freq is F1 + 1 ; Freq is F1).

% Retorna o Char mais frequente da String
maxFreqChar(S, MostCommon) :-
    string_chars(S, C),                         
    sort(C, Uniq),                              % Ordena removendo caracteres repetidos
    findall([Freq, X], (                        % Para cada elemento unico
        member(X, Uniq),
        include(=(X), S, XX),
        length(XX, Freq)                        % Conta quantas vezes o char aparece na lista
    ), Freqs),
    sort(Freqs, SFreqs),                        % Ordena pela frequencia
    last(SFreqs, [Freq, MostCommon]).           % Ultima posição é o mais comum

% Cria uma lista de elementos
listConcat([],L,L).
listConcat([X1|L1],L2,[X1|L3]) :- 
    listConcat(L1,L2,L3).

% Extrai palavras de uma lista
split(In, _Sep, [In]).
split(In, Sep, [Left|Rest]) :-
    append(Left, [Sep|Right], In), 
    !, 
    split(Right, Sep, Rest).
splitWords(L,X) :-
    string_chars(L, L1),
    findall(A,split(L1,' ',A),B),
    myLast(X,B).

% Retorna ultimo elemento da lista
myLast(X,[X]).
myLast(X,[_|L]) :- myLast(X,L).

% Remove ultimo caractere da Lista
withoutLast([_], []).
withoutLast([_|T], [_|R]) :-     % Input, Output
    withoutLast(T, R).

% Verifica se existe elemento na lista
contains(X, [X|_]).
contains(X, [_|T]) :- 
    contains(X, T).

% Busca interceção entre duas listas
intersection([X|Y], M, [X|Z]) :-
    contains(X,M),
    intersection(Y,M,Z).
intersection([X|Y],M,Z) :-
    \+ contains(X,M),
    intersection(Y,M,Z).
intersection([],_,[]).





