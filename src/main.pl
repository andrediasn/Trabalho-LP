%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

%% Importação dos Módulos
:- use_module(library(clpfd)).
:- use_module(charCode_db).
:- use_module(word_db).
:- use_module(caesarCypher).
:- use_module(vigenereCypher).

%% Definição dos arquivos de persistência
:- attach_charCode_db('charCodes.journal').
:- attach_word_db('words.journal').

%% Habilita que o interpretador swi-prolog mostre toda a lista
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- set_prolog_flag(double_quotes, chars).

%% ==============   Implementação das Consultas ==================================
code(Char, Code) :-
    current_charCode(Char, Code).

string2Code(S,L) :-
    (nonvar(S) -> 
        maplist(code, S, L)
    ;   
        maplist(code, Aux, L),
        string_chars(S, Aux)
    ).




%% ====================== Predicados Úteis =======================================

% Calcula o tamanho de uma lista
size([],0).
size([_|T],N) :-            
    size(T,N1), 
    N is N1+1.

%Função para testar as cifras
teste(Input, KC, KV) :-                         
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

%% teste("aaaaaaaa que linguagem de merda", d, "odio").

% Conta quantas vezes um Char aparece na String
countChar([], _, 0).
countChar([H|T], Char, Freq) :-                  %Conta a frequencia daquele Char
    countChar(T, Char, F1),
    code(H,A),
    code(Char,B),
    ( A =:= B -> Freq is F1 + 1 ; Freq is F1).

% Retorna o Char mais frequente da String
maxFreqChar(S, MostCommon, Freq) :-
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
list_concat([],L,L).
list_concat([X1|L1],L2,[X1|L3]) :- 
    list_concat(L1,L2,L3).



    
    

