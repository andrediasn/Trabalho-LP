%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(caesarCypher, [ 
              caesar/3,       % +Key, ?S1, ?S2
              decypherCaesar/1
            ]).

%% ========================= Caesar Cypher ===========================



cypherC(Key, Char1, Char2) :-
    (nonvar(Char1) ->                     % Se recebeu o para Cncode
        code(Char1, Code1),              % Pega o code do Char1
        Code2 is (Code1+Key)mod 27       % Ouput recebe o valor cifrado
    ; nonvar(Char2) -> 
        code(Char2, Code2),
        Code1 is (Code2-Key+27)mod 27    % Output recebe o valor decifrado
    ),
    code(Char1, Code1), 
    code(Char2, Code2).                      % Traduz o Char output

caesar(KeyChar, S1, S2) :-
    code(KeyChar, KeyCode),                 % Pega o código do Char Key
    (nonvar(S1) ->                          % Se Recebeu a String para Encodar, transforma em Chars
        string_chars(S1, L1) 
    ; 
        nonvar(S2) -> 
            string_chars(S2, L2) 
    ),
	maplist(cypherC(KeyCode), L1, L2),     % Pra cada elemento, executa o cypher com a Key
    string_chars(S1, L1),
    string_chars(S2, L2).                    % Transforma a nova lista em String


%% ========================= Caesar Breaker =====================

%Teste -> decypherCaesar("eeeeeeeeduyidpmrkyekiqdhidfsse").
decypherCaesar(Input) :- 
    maxFreqChar(Input, CharFreq),
    code(CharFreq, CodeFreq),
    listConcat([],[1,5,15,19,18,9,14,4,13,21,20,3,12,16,22,7,8,17,2,6,26,10,24,11,23,25,0],ListFreqPort),
    wordSave(Words),
    decypherC(Input, CodeFreq, ListFreqPort, Words).

decypherC(_,_,[],_).
decypherC(Input, C, [H|T], Words) :-
    KeyCode is (C - H + 27)mod 27,
    code(KeyChar, KeyCode),
    caesar(KeyChar, Output, Input),
    splitWords(Output, O),
    intersection(O, Words, Matchs),
    length(Matchs, Tam),
    ( Tam > 0 ->
        format('~n Key: ~w  ~n Result: ~w', [KeyChar, Output])
    ;
        decypherC(Input, C, T, Words)
    ).


