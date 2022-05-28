%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(vigenereCypher,
            [ 
                vigenere/3,             % +Keys, ?S1, ?S2
                cypherV/5,              % +Keys, +KeyTam, ?S1, ?S2 , +Contador
                charCypherV/3,          % +Key, ?Char1, ?Char2
                pairingLists/3,         % +List1, +List2, ?Result
                pairingListsAux/3,      % +List1, +List2, ?Result
                completList/4,          % +List, +List, ?Result, +ListContador
                decypherVigenereWord/4,
                getHintEncrypted/5,
                decypherVigenereWordAux/5,
                listFirtsElem/4
            ]).

    %%%%%%%%%%%%%%%%%% Vigenere Codificador/Decodificador %%%%%%%%%%%%%%%%%%%%%%%%

vigenere(KeyString, S1, S2) :-
    ( nonvar(S1) -> string_chars(S1, L1) ; nonvar(S2) -> string_chars(S2, L2) ),  % Garante que seja lista
    string2Code(KeyString, KeyCodes),                   % Transfora lista de chars, em lista de codes
    size(KeyCodes, KeyTam),                             % Busca Tamanho da lista
    N is 1,                                             % Seta um contador
    cypherV(KeyCodes, KeyTam, L1, L2, N),               % Chama a cifra
    string_chars(S1, L1),
    string_chars(S2, L2).                               % Converte para saida em String


cypherV(KeyCodes, KeyTam, [H1|T1], [H2|T2], N) :-       % List de codes, Tamanho, Decifrado, Cifrado
    nth1(N, KeyCodes, Key),                             % Pega o a chave da vez (definido pelo contador)  da lista de chaves
    charCypherV(Key, H1, H2),                           % Envia para a cifra de char
    ( N =:= KeyTam -> N1 is 1 ; N1 is N+1),             % Se o contador é o ultimo elemento da lista de chaves, volta ao começo
    cypherV(KeyCodes, KeyTam, T1, T2, N1).              % Chama a recursividade
cypherV(_,_,[],[],_).                                   % Encerra quando a lista de entrada acaba

charCypherV(Key, Char1, Char2) :-                       % Segue a mesma logica do Caesar
    ( 
        nonvar(Char1) -> code(Char1, Code1),
        Code2 is (Code1+Key)mod 27
        ; nonvar(Char2) -> code(Char2, Code2),
        Code1 is (Code2-Key+27)mod 27
    ),
    code(Char1, Code1),
    code(Char2, Code2). 


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Vigenere Breaker %%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%% Primeiro predicado pedido:  
% Um predicado de aridade 3 que relaciona duas listas com uma terceira lista de pares, 
% na qual cada par ́e formado por um elemento de cada uma das lista.
pairingLists(L1, L2, Output) :-
    length(L1, Tam1),                                           % Calcula tamanho das listas
    length(L2, Tam2),                                           % Se Tam2 < Tam1 envia a lista2 para se autocompletar ate o tamanho da primeira lista
    ( Tam2 < Tam1 -> completList(L2, L2, LR2, L1) ; string_chars(L2, LR2 ) ),
    pairingListsAux(L1, LR2, Output).                           % Envia para criar uma nova lista de pares
% teste: pairingLists([a,b,c,d,g,t,e,y,u],[b,c,d],X).

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
%% Teste -> decypherVigenereWord("jjaxgi jobtahjfitagnobfna","testar", 10, 2).
decypherVigenereWord(Input, Hint, PosHint, TamKey) :-                                         % Tamanho da Hint
    nth1(PosHint, Input, Elem),
    N is PosHint + 1,                                  % Char da primeira posição correspondente a Hint
    getHintEncrypted(Input, Elem, EncryptedHint, N, Hint),  % Busca a Hint na forma cifrada
    pairingLists(Hint, EncryptedHint, ParHint),             % Forma o par da Hint por char decifrado/cifrado
    getKeyCodes(ParHint, CodesHint),                        % Calculas as keyCodes da Hint
    listConcat(CodesHint, CodesHint, ListKeys),            % Duplico a lista para garantir que a chave esteja presente na sequencia
    decypherVigenereWordAux(Hint, EncryptedHint, ListKeys, TamKey, KeyChars), 
    writeln(KeysCodes).

% Seleciona a Hint na forma Cifrada
getHintEncrypted(_, Elem, [Elem|[]], _, [_|[]]).
getHintEncrypted(Input, Elem, [Elem|T], N, [_|TC]) :-
    nth1(N, Input, Elem1),
    N1 is N + 1,
    getHintEncrypted(Input, Elem1, T, N1, TC).

% Utiliza o Caesar para pegar a Key da Hint
getKeyCodes([[D,E]|T1], [H|T2]) :-
    caesar(H, D, E),
    getKeyCodes(T1, T2).
getKeyCodes([[D,E]|[]], [H|[]]) :-
    caesar(H, D, E).

% Decifrar a Hint
%% Teste -> decypherVigenereWordAux("testar","btahjf","ioioioioioio",10,"dg").
decypherVigenereWordAux(Hint, EncryptedHint, ListKeys, TamKey, KeyChars) :-
    N is 1,
    listFirtsElem(ListKeys, N, TamKey, TryKey),
    writeln(TryKey).

% Busca a possivel chave de tamanho TamKey
listFirtsElem([H|T1], N, TamKey, [H|T2]) :-
    (N < TamKey -> 
        N1 is N + 1, 
        listFirtsElem(T1, N1, TamKey, T2)
    ;   
        listFirtsElem([], N1, TamKey, T2)
    ).
listFirtsElem([], _, _, []).





%%%%%%%%%%%% Terceiro predicado pedido:  
% Um predicado que relaciona uma mensagem cifrada, um tamanho de chave e uma palavra que 
% ocorre no texto com a mensagem decifrada;


/* 
    Logica:
     - 
 */


%decypherVigenereHint(Input, TamKey, Hint).
