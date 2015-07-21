% Nome Cognome Mat
% Nome Cognome Mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURE BASE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Estrae le coordinate x o y 
x([A|_],A).
y([_|As],As).

% area2 calcola 2 volte l'area del triangolo ABC
% in base a se l'area è positiva, negativa, o nulla, possiamo dedurre come
% C sia posto rispetto al segmento AB

area2([Ax|Ay], [Bx|By], [Cx|Cy], Area):-
    P1 is (Bx-Ax),
    P2 is (Cy-Ay),
    P3 is (By-Ay),
    P4 is (Cx-Ax),
    Area is ((P1*P2)-(P3*P4)).

% Predicato che dato A, B, C, ritorna true solo se C è strettamente a sinistra
% del segmento AB
left([Ax|Ay], [Bx|By], [Cx|Cy]):-
    area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
    Area > 0.

% Predicato che dato A, B, C, ritorna true solo se C è a sinistra
% del segmento AB, o se i 3 punti sono allineati
left-on([Ax|Ay], [Bx|By], [Cx|Cy]):-
    area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
    Area >= 0.

% Predicato che dato A, B, C, ritorna true solo se i tre punti sono allineati
collinear([Ax|Ay], [Bx|By], [Cx|Cy]):-
    area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
    Area == 0.

% Predicato per il calcolo del prodotto scalare
scalarProduct([Ax|Ay], [Bx|By], Num):- 
    P1 is (Ax*Bx),
    P2 is (Ay*By),
    Num is P1+P2.

% Predicato di supporto per la norma
norm1([V],Ris):- Ris is (V*V), !.
norm1([V|Vs], Ris):-
	norm1(Vs,PSol),
	Ris is (V*V) + PSol.

% Ris contiene la norma di V
norm(V, Ris):- norm1(V, PSol), Ris is sqrt(PSol).

% Dati due punti angle2d calcola l'angolo in radianti
angle2d(A, B, R):- scalarProduct(A, B, Num),
    norm(A, X),
    norm(B,Y),
    R is acos(Num/(X*Y)).

% il predicato sort ordina la lista di punti in base alle ordinate
listSort(A, Key, X):-
    sort(Key, @=<, A, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   OPERAZIONI SULLE LISTE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aggiunge in coda alla lista il punto in input
addPointToList([], Fs, [Fs|[]]).
addPointToList([F|Fs], S, [F|Zs]):-
    addPointToList(Fs, S, Zs).

% Elimina l'ultimo elemento inserito dalla coda della lista
listDeleteLast([_], []):-!.
listDeleteLast([X|Xs], [X|T]):- listDelete(Xs, T).

% Elimina l'elemento X dalla lista
% Ricostruisce una lista che non contiene X
listDelete(X, [X|T], T):-!.
listDelete(X, [H|T], [H|S]):- listDelete(X, T, S).

% cerca l'elemento minimo della lista
searchMin([],[]):-!.
searchMin([X], X):-!.
searchMin([L|Ls], X):-
    searchMin(Ls, Y),
    Y<L,
    X is Y, !.
searchMin([L|Ls], X):-
    searchMin(Ls, Y),
    Y>=L,
    X is L.

% data una lista in input e un elemento (certo di essere presente),
% il predicato trova la sua posizione
findPosElement([Ele|_], Ele, 0):-!.
findPosElement([_|T], Ele, Pos):- 
    findPosElement(T, Ele, P1),
    Pos is P1+1.

% data una lista S e una posizione Pos, il predicato mi restituisce l'elemento 
% della lista S alla posizione in Pos.
getElementToList([S|_], 0,S):-!.
getElementToList([_|Ss],Pos,Ele):-
    K is Pos-1,
    getElementToList(Ss,K, Ele).

% Data una lista in input B è la sua lunghezza
listLength([], B):- B = 0.
listLength([_El|Lista], B):- 
	listLength(Lista, C),
	B is (C+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PREDICATI D'APPOGGIO    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% questo predicato permette di "prelevare" il primo elemento della lista
getFirstPointOfList([L|_], L).

% list_angle2d applica ricorsivamente il predicato angle2d con l'elemento in
% testa della lista S e il punto PT
list_angle2d([], _, []):-!.
list_angle2d([S|Sx],Pt, [X|Xs]):-
    angle2d(Pt, S, X),
    list_angle2d(Sx, Pt, Xs).

% trova i punti y minimi dalla lista di tutti i punti ordinati
fpy([X], [X]):-!.
fpy([X, K|Ks], [X|Zs]):-
    y(X,Y1),
    y(K,Y2),
    Y1==Y2,
    fpy([K|Ks],Zs), !.
fpy([X, K|_], [X]):-
    y(X,Y1),
    y(K,Y2),
    Y1<Y2.

% trova il punto x minimo dalla lista di punti y minimi
fpx(X, Z):-
    listSort(X, 1, K),
    getFirstPointOfList(K, Z).

% questo predicato ha una funzione essenziale
% se l'area del triangolo ABC è positiva tengo tutti i punti in lista
% se l'area del triangolo ABC è negativa rimuovo il punto B dalla lista poichè
% non è un punto del bordo, ma un punto incluso nella Chiglia Convessa
calcoloDirezione(Area, B, Hulls_List, R):-
    Area<0,
    listDelete(B, Hulls_List, R).
calcoloDirezione(Area, _B, Hulls_List, Hulls_List):-
    Area>=0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURA PRINCIPALE    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ch(Points, Result):-
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   TROVO PRIMI 2 PUNTI     %
    %   CASO INIZIALE           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ordino la lista rispetto y, e parto con punto con coordinata xy minima
    listSort(Points, 2, Sorted),
    fpy(Sorted,Pt),
    fpx(Pt, PtMin),
    addPointToList([], PtMin, Hulls_List),
    listDelete(PtMin, Sorted, Sorted_Less_PtMin),
    list_angle2d(Sorted_Less_PtMin, PtMin, ListAngle2d),
    %cerca il minimo ListAngle2d
    searchMin(ListAngle2d, MinListAngle2d),

    % trova in Hulls_List l'elemento in posizione Pos della lista S
    findPosElement(ListAngle2d, MinListAngle2d, Pos),

    % prendo dalla lista S l elemento alla posizione Pos
    getElementToList(Sorted_Less_PtMin, Pos, Element),

    % aggiungo l elemento alla lista del risultato finale
    addPointToList(Hulls_List, Element, Hulls_List_Plus_2ndPoint),

    % elimino l elemento dalla lista dei punti di partenza ordinati.
    listDelete(Element, Sorted_Less_PtMin, Sorted_Less_2stPoint),

    % CHIAMATA AL PREDICATO RICORSIVO
    recursive_main(Sorted_Less_2stPoint, Hulls_List_Plus_2ndPoint, Result).


recursive_main([], Hulls_List, Hulls_List):-!.
recursive_main(ListPoint, Hulls_List, R):-
    % 1- Seleziono gli ultimi 2 elementi messi in Hulls_List
    %    in modo da avere il segmento AB
    listLength(Hulls_List, Length_Hulls_List),
    getElementToList(Hulls_List, Length_Hulls_List-1, B),
    J is Length_Hulls_List-2,
    getElementToList(Hulls_List, J, A),

    % 2- Calcolo la list_angle2d con l'ultimo elemento messo in Hulls_List
    list_angle2d(ListPoint, B, ListAngle2d),

    % 3- Inserisco il punto (compatibile) con angolo polare più piccolo
    %cerca il minimo ListAngle2d
    searchMin(ListAngle2d, MinListAngle2d),

    % trova in Hulls_List l'elemento in posizione Pos della lista S
    findPosElement(ListAngle2d, MinListAngle2d, Pos),

    % prendo dalla lista S l elemento alla posizione Pos
    getElementToList(ListPoint, Pos, C),

    % aggiungo l elemento alla lista del risultato finale
    addPointToList(Hulls_List, C, Hulls_List_Plus_C),

    % elimino l elemento dalla lista dei punti di partenza ordinati.
    listDelete(C, ListPoint, ListPoint_Less_C),

    % 4- Controllo l'area degli ultimi 3 punti per capire che tipo
    %    di svolta ho fatto:
        % 4.1 - Se ho una svolta a sinistra (Area>0) lascio il punto
        %       nella Hulls_List
        % 4.2 - Se ho una svolta a destra (Area<0) devo rimuovere il penultimo
        %       punto (B) dalla Hulls_List
    area2(A,B,C, Area),
    calcoloDirezione(Area, B, Hulls_List_Plus_C, Hulls_List_Updated),

    % 5- chiamata ricoriva con 
    recursive_main(ListPoint_Less_C, Hulls_List_Updated, R).









