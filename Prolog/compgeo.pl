% Nome Cognome Mat
% Nome Cognome Mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURE BASE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Estrae le coordinate x o y 
x([A, _], A).
y([_, As], As).

% area2 calcola 2 volte l'area del triangolo ABC
% in base a se l'area è positiva, negativa, o nulla, possiamo dedurre come
% C sia posto rispetto al segmento AB

area2([Ax, Ay], [Bx, By], [Cx, Cy], Area):-
    P1 is (Bx - Ax),
    P2 is (Cy - Ay),
    P3 is (By - Ay),
    P4 is (Cx - Ax),
    Area is ((P1 * P2) - (P3 * P4)).

% Predicato che dato A, B, C, ritorna true solo se C è strettamente a sinistra
% del segmento AB
left([Ax, Ay], [Bx, By], [Cx, Cy]):-
    area2([Ax, Ay], [Bx, By], [Cx, Cy], Area),
    Area > 0.

% Predicato che dato A, B, C, ritorna true solo se C è a sinistra
% del segmento AB, o se i 3 punti sono allineati
left-on([Ax, Ay], [Bx, By], [Cx, Cy]):-
    area2([Ax, Ay], [Bx, By], [Cx, Cy], Area),
    Area >= 0.

% Predicato che dato A, B, C, ritorna true solo se i tre punti sono allineati
is-collinear([Ax, Ay], [Bx, By], [Cx, Cy]):-
    area2([Ax, Ay], [Bx, By], [Cx, Cy], Area),
    Area == 0.

% Dati due punti angle2d calcola l'angolo polare
angle2d(A, B, R):- y(B, Yb),
    y(A, Ya),
    X2 is (Yb - Ya),
    X2==0,  % qui la arco-tangente non è definita
    R is 10000, !.
angle2d(A, B, R):- x(B, Xb),
    x(A, Xa),
    X1 is (Xb - Xa),
    y(B, Yb),
    y(A, Ya),
    X2 is (Yb - Ya),
    X2 \= 0,
    X3 is X1 / X2,
    R is atan(X3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   OPERAZIONI SULLE LISTE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% il predicato sort ordina la lista di punti in base alle ordinate
listSort(A, Key, X):-
    sort(Key, @=<, A, X).

% Aggiunge in coda alla lista il punto in input
addPointToList([], Fs, [Fs|[]]).
addPointToList([F|Fs], S, [F|Zs]):-
    addPointToList(Fs, S, Zs).

% Elimina l'elemento X dalla lista
% Ricostruisce una lista che non contiene X
listDelete(X, [X|T], T):-!.
listDelete(X, [H|T], [H|S]):- listDelete(X, T, S).

% Rimuovo l'elemento alla posizione K
% Ricostruisco la lista senza il K-esimo elemento
listDeleteAt([_|Xs], 0, Xs):-!.
listDeleteAt([Y|Xs], K, [Y|Ys]) :- 
	K > 0,
   	K1 is K - 1, 
	listDeleteAt(Xs, K1, Ys).

% cerca l'elemento massimo della lista
searchMax([], []):-!.
searchMax([X], X):-!.
searchMax([L|Ls], X):-
    searchMax(Ls, Y),
    Y > L,
    X is Y, !.
searchMax([L|Ls], X):-
    searchMax(Ls, Y),
    Y =< L,
    X is L.

% data una lista in input e un elemento (certo di essere presente),
% il predicato trova la sua posizione
findPosElement([Ele|_], Ele, 0):-!.
findPosElement([_|T], Ele, Pos):- 
    findPosElement(T, Ele, P1),
    Pos is P1 + 1.

% data una lista S e una posizione Pos, il predicato mi restituisce l'elemento 
% della lista S alla posizione in Pos.
getElementToList([S|_], 0, S):-!.
getElementToList([_|Ss], Pos, Ele):-
    K is Pos - 1,
    getElementToList(Ss, K, Ele).

% Data una lista in input B è la sua lunghezza
listLength([], B):- B = 0.
listLength([_El|Lista], B):- 
	listLength(Lista, C),
	B is (C + 1).

% il predicato rmDuplicati rimuove tutti i duplicati dalla lista
rmDuplicati([X], [X]):-!.
rmDuplicati([L|Ls], K):-
    findPosElement(Ls, L, _Pos),
    rmDuplicati(Ls, K), !.
rmDuplicati([L|Ls], [L|K]):-
    rmDuplicati(Ls, K).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PREDICATI D'APPOGGIO    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% questo predicato permette di "prelevare" il primo elemento della lista
getFirstPointOfList([L|_], L).

% list_angle2d applica ricorsivamente il predicato angle2d con l'elemento in
% testa della lista S e il punto PT
list_angle2d([], _, []):-!.
list_angle2d([S|Sx], Pt, [X|Xs]):-
    angle2d(Pt, S, X),
    list_angle2d(Sx, Pt, Xs).

% trova i punti y minimi assoluti della lista di tutti i punti ordinati
fpy([X], [X]):-!.
fpy([X, K|Ks], [X|Zs]):-
    y(X, Y1),
    y(K, Y2),
    Y1 == Y2,
    fpy([K|Ks], Zs), !.
fpy([X, K|_], [X]):-
    y(X, Y1),
    y(K, Y2),
    Y1 < Y2.

% trova il punto x minimo dalla lista di punti y minimi assluti
fpx(X, Z):-
    listSort(X, 1, K),
    getFirstPointOfList(K, Z).

% trova punto con angolo polare minimo, aggiorna le liste punti e angoli
% e restituisce il punto
trova_pt(ListAngle2d, Sorted_Less_PtMin,
            ListAngle2dLessMin, Sorted_Less_Element, Element):-
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   trova punto
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %cerca il minimo ListAngle2d
    searchMax(ListAngle2d, MinListAngle2d),

    % trova in Hulls_List l'elemento in posizione Pos della lista S
    findPosElement(ListAngle2d, MinListAngle2d, Pos),

    % prendo dalla lista S l'elemento alla posizione Pos
    getElementToList(Sorted_Less_PtMin, Pos, Element),

    % elimino l'elemento dalla lista dei punti di partenza ordinati. 
    listDelete(Element, Sorted_Less_PtMin, Sorted_Less_Element),

    % elimino l'elemento dalla lista degli angoli polari. 
    listDeleteAt(ListAngle2d, Pos, ListAngle2dLessMin).

% questo predicato ha una funzione essenziale
% se l'area del triangolo ABC è positiva tengo tutti i punti in lista
% se l'area del triangolo ABC è negativa rimuovo il punto B dalla lista poichè
% non è un punto del bordo, ma un punto incluso nella Chiglia Convessa
calcoloDirezione([A], _, [A]):- !.
calcoloDirezione(Hulls_List, C, Hulls_List):-
    % Seleziono gli ultimi 2 elementi messi in Hulls_List
    % in modo da avere il segmento AB
    listLength(Hulls_List, Length_Hulls_List),
    getElementToList(Hulls_List, Length_Hulls_List - 1, B),
    J is Length_Hulls_List - 2,
    getElementToList(Hulls_List, J, A),
    area2(A, B, C, Area),
    Area >= 0, !.
calcoloDirezione(Hulls_List, C, Hulls_List_Update):-
    % Seleziono gli ultimi 2 elementi messi in Hulls_List
    % in modo da avere il segmento AB
    listLength(Hulls_List, Length_Hulls_List),
    getElementToList(Hulls_List, Length_Hulls_List - 1, B),
    J is Length_Hulls_List - 2,
    getElementToList(Hulls_List, J, A),
    area2(A, B, C, Area),
    Area < 0,
    listDelete(B, Hulls_List, Hulls_List_Less_B),
    calcoloDirezione(Hulls_List_Less_B, C, Hulls_List_Update).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   LETTURA DA FILE    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_points(File, List):-
    csv_read_file(File, R, [functor(point), separator(0'\t)]),
    maplist(assert, R),
    setof([X, Y], point(X, Y), List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURA PRINCIPALE    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% goal di prova
% ch([[3,2], [8,3], [13,1], [11,9], [7,6], [2,4], [15,7], [11,5]], CH).

ch(Points, Result):-
    % 1- controllo se l'input è corretto:
    % inizializzo la stringa di punti in modo da non avere duplicati
    rmDuplicati(Points, Points_Less_Duplicates),

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2- TROVO PRIMI 3 PUNTI    %
    %     CASO INIZIALE         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ordino la lista rispetto y, e parto con punto con coordinata xy minima
    listSort(Points_Less_Duplicates, 2, Sorted),
    fpy(Sorted, Pty),
    fpx(Pty, PtMin),
    addPointToList([], PtMin, Hulls_List),
    
    % elimino il punto dalla lista dei punti ordinati e il suo relativo angolo
    listDelete(PtMin, Sorted, Sorted_Less_PtMin),
    list_angle2d(Sorted_Less_PtMin, PtMin, ListAngle2d),
    
    % trovo secondo punto
    trova_pt(ListAngle2d, Sorted_Less_PtMin, L_A, L_P, Pt2),

    % aggiungo l'elemento alla lista del risultato finale
    addPointToList(Hulls_List, Pt2, Hulls_List_Plus_2ndPt),

    % trovo terzo punto
    trova_pt(L_A, L_P, ListAngle2d_Update, Sorted_Update, Pt3),

    % aggiungo l'elemento alla lista del risultato finale
    addPointToList(Hulls_List_Plus_2ndPt, Pt3, Hulls_List_Plus_3ndPt),

    % CHIAMATA AL PREDICATO RICORSIVO
    recursive_main(Sorted_Update, Hulls_List_Plus_3ndPt,
                  ListAngle2d_Update, Result), !.
    %reverse(K, Result).


recursive_main([], Hulls_List, [], Hulls_List):-!.
recursive_main(ListPoint, Hulls_List, ListAngle2d, R):-
    

    % 3- Cerco il prossimo punto da aggiungere alla Hulls List
    %cerca il minimo ListAngle2d
    searchMax(ListAngle2d, MinListAngle2d),

    % trova in Hulls_List l'elemento in posizione Pos della lista S
    findPosElement(ListAngle2d, MinListAngle2d, Pos),

    % prendo dalla lista S l'elemento alla posizione Pos
    getElementToList(ListPoint, Pos, C),

    % elimino l'elemento dalla lista dei punti di partenza ordinati.
    listDelete(C, ListPoint, ListPoint_Less_C),

    % elimino l'elemento dalla lista degli angoli polari. 
    listDeleteAt(ListAngle2d, Pos, ListAngle2dLessMin),

    % 4- Controllo l'area degli ultimi 3 punti per capire che tipo
    %    di svolta ho fatto:
        % 4.1 - Se ho una svolta a sinistra (Area>=0) lascio il punto
        %       nella Hulls_List
        % 4.2 - Se ho una svolta a destra (Area<0) devo rimuovere il penultimo
        %       punto (B) dalla Hulls_List, e ricontrollare la svolta
        %       sugli ultimi 3 punti in lista
    
    calcoloDirezione(Hulls_List, C, Hulls_List_Updated),

     % aggiungo l'elemento alla lista del risultato finale
    addPointToList(Hulls_List_Updated, C, Hulls_List_Plus_C),

    % 5- chiamata ricorsiva
    recursive_main(ListPoint_Less_C, Hulls_List_Plus_C,
                    ListAngle2dLessMin, R).
