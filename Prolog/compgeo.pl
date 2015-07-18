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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   OPERAZIONI SULLE LISTE  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aggiunge in coda alla lista il punto in input
%listAdd([], Fs, [Fs|[]]).
%listAdd([F|Fs], S, [F|Zs]):-
%    listAdd(Fs, S, Zs).

% Aggiunge in testa alla lista il punto in input
%listAdd(X, Y, [X|Y]).

% Elimina l'ultimo elemento inserito dalla testa della lista
%listDelete([X|Xs], Xs).

% Elimina l'ultimo elemento inserito dalla coda della lista
listDelete([X], []):-!.
listDelete([X|Xs], [X|T]):- listDelete(Xs, T).











