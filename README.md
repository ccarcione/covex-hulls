# covex-hulls
Calcolo delle chiglie convesse (convex hulls) secondo la cosiddetta “Graham’s Scan” (la scansione di Graham).

I.4.2 Algoritmo Graham Scan
Questo algoritmo è incrementale. Si parte da un punto che sicuramente appartiene al
bordo (ad esempio da quello con coordinate x e y minime) e ad ogni iterazione si va a
considerare un punto aggiuntivo; si valuta se questo punto sta a destra o a sinistra rispetto
al segmento immediatamente precedente (in base alla misura dell’angolo tra i segmenti).
Se non si effettua una voltata a sinistra, il punto appartiene al bordo, altrimenti il punto
non appartiene al bordo e va a scartato.
La struttura dati più adatta per implementare questo algoritmo è la pila, in cui memorizzo
i punti estremi candidati, infatti si va sempre a considerare l’ultimo elemento (o
al massimo il penultimo).
L’algoritmo è il seguente:

Algoritmo I.3 GrahamScan(P)
|
|    1: p0 ← punto con coordinata y minima
|
|    2: p1 . . . pn ordinati in senso orario rispetto a P0
|
|    3: Push(p0, S)
|
|    4: Push(p1, S)
|
|    5: Push(p2, S)
|
|    6: for i ← 3 . . . n do
|
|    7:      while angolo NextToTop(S), Top(S), pi non gira a destra do
|
|    8:          Pop(S)
|
|    9:      Push(S, pi)
|
|   10: RETURN (S)
|
Per maggiori informazioni pagina 10 geocomp.pdf

Noi non utilizziamo la pila ma una lista.
