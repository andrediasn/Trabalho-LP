%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(vigenereCypher,
            [ 
                vigenere/3,                             % +Key, ?S1, ?S2
                pairingLists/3,                         % +List1, +List2, ?Result
                decypherVigenerePosition/5,             % +Text, +Hint, +Position, +LengthKey, ?Key
                decypherVigenereHint/4,                 % +Text, +Hint, +LengthKey, ?Result
                decypherVigenereListHints/4             % +Text, +ListHints, +LengthKey, ?Result 
            ]).

    %%%%%%%%%%%%%%%%%% Vigenere Codificador/Decodificador %%%%%%%%%%%%%%%%%%%%%%%%

vigenere(KeyString, S1, S2) :-
    (nonvar(S1) ->                      % Se a entrada  for o texto traduzido
        string_chars(S1, L1)            % Transforma em lista
    ; 
        nonvar(S2) ->                   % Se a entrada for o texto codificado
            string_chars(S2, L2) ),     % Transforma em lista
    string2Code(KeyString, KeyCodes),          % Transfora lista de chars, em lista de codes
    size(KeyCodes, KeyTam),                    % Busca Tamanho da lista
    N is 1,                                    % Seta um contador
    cypherV(KeyCodes, KeyTam, L1, L2, N),      % Envia para a cifra
    string_chars(S1, L1),
    string_chars(S2, L2).                      % Converte para saida em String


cypherV(KeyCodes, KeyTam, [H1|T1], [H2|T2], N) :-
    nth1(N, KeyCodes, Key),                   % Pega o elemento N da chave
    charCypherV(Key, H1, H2),                 % Envia para a cifra
    (N =:= KeyTam ->           % Se o contador é o ultimo elemento da lista de chaves
        N1 is 1                % Volta o contador para o começo
    ; 
        N1 is N+1              % Se não, incrementa o contador
    ),    
    cypherV(KeyCodes, KeyTam, T1, T2, N1).   % Proximo char
cypherV(_,_,[],[],_).                     % Encerra quando a lista de entrada acaba

charCypherV(Key, Char1, Char2) :-      % Segue a mesma logica do Caesar
    ( 
        nonvar(Char1) -> code(Char1, Code1),
        Code2 is (Code1+Key)mod 108
        ; nonvar(Char2) -> code(Char2, Code2),
        Code1 is (Code2-Key+108)mod 108
    ),
    code(Char1, Code1),
    code(Char2, Code2). 


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Vigenere Breaker %%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%% Primeiro predicado pedido:  
% Um predicado de aridade 3 que relaciona duas listas com uma terceira lista de pares, 
% na qual cada par ́e formado por um elemento de cada uma das lista.
% Teste -> pairingLists([a,b,c,d,g,t,e,y,u],[b,c,d],X).
pairingLists(L1, L2, Output) :-
    length(L1, Tam1),                                           % Calcula tamanho das listas
    length(L2, Tam2),                                           % Se Tam2 < Tam1 envia a lista2 para se autocompletar ate o tamanho da primeira lista
    ( Tam2 < Tam1 -> completList(L2, L2, LR2, L1) ; string_chars(L2, LR2 ) ),
    pairingListsAux(L1, LR2, Output).                           % Envia para criar uma nova lista de pares

% Cria uma lista de pares a partir de duas listas de tamanhos iguais.
pairingListsAux([H1|T1], [H2|T2], [[H1,H2]|T]) :-       % Output recebe na Head uma lista de com as Heads das outras listas
    pairingListsAux(T1, T2, T).                           
pairingListsAux([H1|[]],[H2|[]],[[H1,H2]]).             % Se encerra quando for o ultimo elemento das listas
% teste: %%  pairingListsAux([a,b,c],[b,c,d],X).

% Completa uma lista repetindo seus caracteres com o tamanho da outra Lista
completList(List, [H|T], [H|Y], [_|N1]) :-                   % Lista, Elemento da lista, Resultado, Tamanho esperado
    completList(List, T, Y, N1).                             
completList(List, [], Out, N) :-                             % Quando a minha lista input se encerra Envio novamente a Lista para a recursividade,
    completList(List, List, Out, N).                         % Voltando assim ao primeiro elemento da lista input
completList(_,[H|_],[H|[]],[_|[]]).                       % Encerra quando a Tail do meu contator é vazio.
% Teste: %% completList([a,b],[a,b],X,[1,2,3,4,5,6,7]).

%%%%%%%%%%%% Segunto predicado pedido:  
% Um predicado que relaciona uma mensagem cifrada, um tamanho de chave, 
% uma palavra que sabidamente ocorre na mensagem decifrada e sua posição, com a chave.
%% Teste -> decypherVigenerePosition("ÇkfipõerapéCaijppónhovuCagpbÊBôájoé[aGfwoXfuuqf", 6, "finalmentes", 14, Key).
decypherVigenerePosition(Input, TamKey, Hint, PosHint, Key) :-                         
    nth1(PosHint, Input, Elem),
    N is PosHint + 1,                                  % Char da primeira posição correspondente a Hint
    getHintEncrypted(Input, Elem, EncryptedHint, N, Hint),  % Busca a Hint na forma cifrada
    pairingLists(Hint, EncryptedHint, ParHint),             % Forma o par da Hint por char decifrado/cifrado
    getKeyCodes(ParHint, CodesHint),                        % Calculas as keyCodes da Hint
    listConcat(CodesHint, CodesHint, ListKeys),             % Duplico a lista para garantir que a chave esteja presente na sequencia
    decypherVigenerePositionAux(Input, Hint, EncryptedHint, ListKeys, TamKey, Key).

% Seleciona a Hint na forma Cifrada
getHintEncrypted(Input, Elem, [Elem|T], N, [_|TC]) :-
    nth1(N, Input, Elem1),
    N1 is N + 1,
    getHintEncrypted(Input, Elem1, T, N1, TC).
getHintEncrypted(_, Elem, [Elem|[]], _, [_|[]]).        %Encerra quando chega no ultima letra da Hint

% Utiliza o Caesar para pegar a Key da Hint
getKeyCodes([[D,E]|T1], [H|T2]) :-                      
    caesar(H, D, E),                               % Calcula Key 
    getKeyCodes(T1, T2).                           % Pega próxima
getKeyCodes([[D,E]|[]], [H|[]]) :-                 % Encerra na ultima letra da Hint
    caesar(H, D, E).

% Decifrar a Hint
decypherVigenerePositionAux(Text, Hint, EncryptedHint, ListKeys, TamKey, Key) :-
    N is 1, 
    listFirtsElem(ListKeys, N, TamKey, TryKey),             % Supõe que a key esteja na primeira posição da ListKeys
    vigenere(TryKey, TryText, Text),                        % Testa chave
    cleaningChars(TryText, Clean),                          % formata para somente letras minusculas
    splitWords(Clean, O),                            % Separa as palavras
    intersection(O, [Hint], Matchs),                          % Tenta encontrar a Hint no resultado
    length(Matchs, Tam),
    (Tam > 0 ->                                             % Se achou, devolve a Key
        string_chars(Key, TryKey)
    ;                                                       % Se não achou, remove primeiro elemento de ListKeys
        listRemoveFirstElem(ListKeys, ListKeys1),           % E tenta novamente
        decypherVigenerePositionAux(Text, Hint, EncryptedHint, ListKeys1, TamKey, Key)
    ).

% Busca a possivel chave de tamanho TamKey
listFirtsElem([H|T1], N, TamKey, [H|T2]) :-
    (N < TamKey ->                              % Se ainda n pegou todas as letras da Key
        N1 is N + 1, 
        listFirtsElem(T1, N1, TamKey, T2)       % Pega a próxima letra
    ;   
        listFirtsElem([], N, TamKey, T2)        % Se ja completou o tamanho da chave, encerra
    ).
listFirtsElem([], _, _, []).

%Remove primeiro elemento da lista
listRemoveFirstElem([_|T], Output) :-
    listConcat([], T, Output).



%%%%%%%%%%%% Terceiro predicado pedido:  
% Um predicado que relaciona uma mensagem cifrada, um tamanho de chave e uma palavra que 
% ocorre no texto com a mensagem decifrada;
% Teste -> decypherVigenereHint("ÇkfipõerapéCaijppónhovuCagpbÊBôájoé[aGfwoXfuuqf", 6, "finalmentes", Texto).
decypherVigenereHint(Input, TamKey, Hint, Output) :-
    N is 1,                                             % Seta um contador    
    decypherVigenereHintAux(Input, Hint, TamKey, N, Output).    % Chama o loop para tentar achar a Hint  

decypherVigenereHintAux(Input, Hint, TamKey, N, Output) :- 
    length(Input, Max),
    (decypherVigenerePosition(Input, TamKey, Hint, N, Key)  ->  % Se a Hint tiver na posição N, achou a chave
        string_chars(Key, KeyChars),
        vigenere(KeyChars, Output, Input)                       % Recebe palavra decifrada
    ; 
        N < Max ->                                                    %Se ainda existe posições não testadas na lista
            N1 is N + 1,                                            
            decypherVigenereHintAux(Input, Hint, TamKey, N1, Output)
    ).

%%%%%%%%%%%% Quarto predicado pedido: 
%Um predicado que relaciona uma mensagem cifrada, uma lista de possıveis palavras 
% que ocorre no texto e um tamanho de chave com a mensagem decifrada.
% Teste -> decypherVigenereListHints("ÇkfipõerapéCaijppónhovuCagpbÊBôájoé[aGfwoXfuuqf", 6, ["pizza","programação","finalmentes"], Texto).
decypherVigenereListHints(Input, TamKey, [H|T], Output) :-
    (decypherVigenereHint(Input, TamKey, H, Output)             % Testo a Head com a dica
    ;    
        decypherVigenereListHints(Input, TamKey, T, Output)     % Se não achou, testo a próxima
    ).