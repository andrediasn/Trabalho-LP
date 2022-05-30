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
        Code2 is (Code1+Key)mod 108       % Ouput recebe o valor cifrado
    ; nonvar(Char2) -> 
        code(Char2, Code2),
        Code1 is (Code2-Key+108)mod 108    % Output recebe o valor decifrado
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
    maxFreqChar(Input, CharFreq),                           % Recebe letra mais frequente do input
    code(CharFreq, CodeFreq),                               % Busca seu código
    listConcat([],[1,6,16,20,19,10,15,5,14,22,21,3,13,17,23,8,9,18,2,7,27,11,25,12,24,26,0,4,28,29,30,31,32,33,34,35,36,37,38,39],A),  % letras minusculas
    listConcat(A,[40,45,55,59,58,49,54,44,53,61,60,42,52,56,62,47,48,57,41,46,66,50,64,51,63,65,43,67,68,69,70,71,72,73,74,75,76,77,78],B),  % letras Maiusculas
    listConcat(B,[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107],ListFreqPort),  % Pontuação
    wordSave(Words),                                        % Recebe lista de palavras salvas
    decypherC(Input, CodeFreq, ListFreqPort, Words).

decypherC(_,_,[],_).
decypherC(Input, C, [H|T], Words) :-
    KeyCode is (C - H + 108)mod 108,
    code(KeyChar, KeyCode),
    caesar(KeyChar, Output, Input),
    string_lower(Output, Lower),
    cleaningChars(Lower, Clean),
    splitWords(Clean, O),
    intersection(O, Words, Matchs),
    length(Matchs, Tam),
    ( Tam > 0 ->
        format('~n Key: ~w  ~n Result: ~w', [KeyChar, Output])
    ;
        decypherC(Input, C, T, Words)
    ).


