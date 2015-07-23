; Nome Cognome Mat
; Nome Cognome Mat

; funzione che dati due elementi crea un lista
(defun make-point (a b)
(list a b))

; funzione che data in input una lista calcola la sua lunghezza
(defun lengh (lista)
	(cond((null lista)nil)
		(t(+ 1 (length (cdr lista))))))
; funzione che data in input una lista, dopo aver controllato che la lista 
; sia fatta da due elementi mi restituisce il primo
(defun x (lista) 
	(cond ((null lista)nil)
		  ((>(length lista)2) (error "abbiamo un problema"))
		  (t(car lista))))
; funzione che data in input una lista, dopo aver controllato che la lista 
; sia fatta da due elementi mi restituisce il secondo
(defun y (lista) 
	(cond ((null lista)nil)
		  ((>(length lista)2) (error "abbiamo un problema"))
		  (t(car(cdr lista)))))

; funzione che dati tre punti( come liste di due elementi) mi calcola 
;l'area del triangolo che formano
(defun area2 ( a b c)
	(cond ((null a)nil)
		  ((null b)nil)
		  ((null c)nil)
		  (t(-(* (- (x b) (x a)) (- (y c) (y a))) 
		  	  (* (- (y b) (y a)) (- (x c) (x a)))
		  	  ))))
; funzioni che mi servono per capire che tipo di svolta è avvenuta,  
(defun left (a b c)
	(if (> (area2 a b c) 0)T nil))
 

(defun left-on (a b c)
	(if (>= (area2 a b c) 0)T nil))

; la svolta è nulla, nel senso che i tre punti solo collineari
(defun is-collinear (a b c)
	(if (= (area2 a b c) 0)T nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; funzioni di appoggio per definire angle2d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; definizione del prodotto scalare per usare la funzione angle2d
( defun prodScalare (a b)
	(cond((null a )nil)
		((null b)nil)
		(t(+ (* (x a) (x b))
			 (* (y a) (y b))))))
; Crea la funzione norm 
( defun norm (a)
 	(cond ((null  a) nil)
 		  (t(sqrt(+(*(x a) (x a))
 		  	      (* (y a) (y a)))))))

; utiliziamo il prodotto e le norme per calcolarci il coseno dell angolo
; per trovare il valore dell angolo in radianti utilizziamo l arcoseno
(defun angle2d (a b)
    (cond ((null a) nil)
    	  ((null b) nil)
    	  (t(acos(/(prodScalare a b)
	               (* (norm a) (norm b)))))))


; funzione che data come input una lista di listeordina tramite la sort
; rispetto al primo membro di ogni lista	
 (defun ordinax (lista_punti)
 	(cond ((null lista_punti)nil)
 		  (t (sort lista_punti #'< :key #'first))))		
; funzione che data come input una lista di listeordina tramite la sort
; rispetto al secondo membro di ogni lista	
 (defun ordinay (lista_punti)
 	(cond ((null lista_punti)nil)
 		  (t (sort lista_punti #'< :key #'second))))
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; operazioni sulle liste
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;funione che dati un elemento (una lista di due elementi) e una lista 
; aggiunge l'elemento alla lista
; l'aggiunta avviene in testa
(defun inserisci_ele ( Ele lista)
	(cond ((null Ele)nil)
		  (t(push Ele lista))))		  	  	   

; funzione che data una lista elimina l elemento in testa alla lista
; infatti il risultato è l elemento eliminato
(defun elimina_ele (lista)
	(cond ((null lista)nil)
	      (t(pop lista))))	

; dato in ingresso (rest lista) e il primo elemento
; cerca il minimo di una lista
(defun cerca_min (lista ele-min)
	(cond ((null (car lista)) ele-min)	;caso base: ho un solo elemento
										;restituisco l'elemento
        ((< (car lista) ele-min) (cerca_min (rest lista) (car lista)))	;se l'elemento in testa è minore
        																	;dell'elemento min attuale, passo ricorsivo
        																	;cerca_minimo (rest list) (first list)
        (t (cerca_min (cdr lista) ele-min))
    )
)



