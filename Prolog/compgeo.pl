% Nome Cognome Mat
% Nome Cognome Mat

%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURE BASE  %
%%%%%%%%%%%%%%%%%%%%%

% Estrae le coordinate x o y 
x([A|As],A).
y([A|As],As).

% area2 calcola 2 volte l'area del triangolo ABC
% in base a se l'area è positiva negativa o nulla possiamo dedurre come
% C sia posto rispetto al segmenprdoto AB

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
listSort(A,X):-
    sort(2, @<, A, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   OPERAZIONI SULLE LISTE  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aggiunge in coda alla lista il punto in input
listAdd([], Fs, [Fs|[]]).
listAdd([F|Fs], S, [F|Zs]):-
    listAdd(Fs, S, Zs).

% Aggiunge in testa alla lista il punto in input
listAddTesta(X, Y, [X|Y]).

% Elimina l'ultimo elemento inserito dalla testa della lista
%listDelete([X|Xs], Xs).

% Elimina l'ultimo elemento inserito dalla coda della lista
listDelete([X], []):-!.
listDelete([X|Xs], [X|T]):- listDelete(Xs, T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURA PRINCIPALE    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ch(Points, Result).
% casi base da rivedere quando ho lista vuota uno o tre punti.

% predicati d'appoggio
addPointToList([Y|Ys], [Y]).
rmPointToList([S|Sx], Sx).

list_angle2d([], LPt, []):-!.
list_angle2d([S|Sx],Pt, [X|Xs]):-
    angle2d(Pt, S, X),
    list_angle2d(Sx, Pt, Xs).
simpleSort(X, Z):-
    sort(X,Z).
setPt([ListPt|ListPts], ListPt).
findPoint([X,Y|Xs],[X|Zs]):- (y(X))==(y(Y)),
    (x(X))<(x(Y)).
    
      




% 1- ordino la lista rispetto y, e parto con punto con coordinata xy minima
ch(Points, Result):-
    listSort(Points, Sorted),
    findPoin(Sorted,Result).
    





    %addPointToList(Sorted, ListPt),
    %setPt(ListPt, Pt), % in caso di due punti min con stessa y?
    %rmPointToList(Sorted, S),
% 2- p1 . . . pn ordinati in senso orario rispetto a P0 [angle2d]
    %list_angle2d(S, Pt, Result).
% 3- butto in lista i primi 3 punti e guardo le "svolte"








).
      
