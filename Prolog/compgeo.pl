% Nome Cognome Mat
% Nome Cognome Mat

%%%%%%%%%%%%%%%%%%%%%%%%
%   PROCEDURE BASE    %
%%%%%%%%%%%%%%%%%%%%%%%%

% Estrae le coordinate x o y 
x([A|As],A).
y([A|As],As).

% area2 calcola 2 volte l'area del triangolo ABC
% in base a se l'area è positiva negativa o nulla possiamo dedurre come
% C sia posto rispetto al segmenprdoto AB

area2([Ax|Ay], [Bx|By], [Cx|Cy], Area):- P1 is (Bx-Ax),
                                    P2 is (Cy-Ay),
                                    P3 is (By-Ay),
                                    P4 is (Cx-Ax),
                                    Area is ((P1*P2)-(P3*P4)).

left([Ax|Ay], [Bx|By], [Cx|Cy]):-
                                 area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
                                 Area > 0.

left-on([Ax|Ay], [Bx|By], [Cx|Cy]):-
                                 area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
                                 Area >= 0.

collinear([Ax|Ay], [Bx|By], [Cx|Cy]):-
                                 area2([Ax|Ay], [Bx|By], [Cx|Cy], Area),
                                 Area == 0.

%funzione per il calcolo del prodotto scalare
scalarProduct([Ax|Ay], [Bx|By], Num):- 
	P1 is (Ax*Bx),
    P2 is (Ay*By),
    Num is P1+P2.

% Funzione di supporto per la norma
norm1([V],Ris):- Ris is (V*V), !.
norm1([V|Vs], Ris):-
	norm1(Vs,PSol),
	Ris is (V*V) + PSol.

% Ris contiene la norma di V
norm(V, Ris):- norm1(V, PSol), Ris is sqrt(PSol).

angle2d(A, B, R):- scalarProduct(A, B, Num),
                norm(A, X),
                norm(B,Y),
                R is acos(Num/(X*Y)).




