%% Autores

%% Nome: André Dias Nunes
%% Matrícula: 201665570C

%% Nome: Gabriel Di iorio Silva
%% Matrícula: 201765551AC

:- module(vigenereCypher,
            [ 
                vigenere/3,         % +Keys, ?S1, ?S2
                cypherV/5,          % +Keys, +KeyTam, ?S1, ?S2 , +N
                charCypherV/3,       % +Key, ?Char1, ?Char2
                pairingLists/3,
                completList/4,
                completeListAux/3,
                pairingListsAux/3
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
%Relaciona duas listas criando uma nova com a paridade de cada elemento das outras duas
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
completList(List, [H|T], [H|Y], [N|N1]) :-                   % Lista, Elemento da lista, Resultado, Tamanho esperado
    completList(List, T, Y, N1).                             
completList(List, [], Out, N) :-                             % Quando a minha lista input se encerra Envio novamente a Lista para a recursividade,
    completList(List, List, Out, N).                         % Voltando assim ao primeiro elemento da lista input
completList(List,[H|T],[H|[]],[N|[]]).                       % Encerra quando a Tail do meu contator é vazio.
% Teste: %% completList([a,b],[a,b],X,[1,2,3,4,5,6,7]).
