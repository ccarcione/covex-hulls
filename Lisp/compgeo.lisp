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
    	  ((= (- (y b) (y a)) 0)10)
    	  (t(atan(/(- (x b) (x a))
	               (- (y b) (y a)))))))

(defun lista_angle2d (lista punto)
	(cond ((null lista) nil)
		((cons (angle2d (car lista) punto)
		  		   (lista_angle2d (cdr lista) punto)))))
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

;funzione che dati un elemento (una lista di due elementi) e una lista 
; aggiunge l'elemento alla lista
; l'aggiunta avviene in testa
(defun push_lista (Ele lista)
	(cond ((null Ele)nil)
		  (t(push Ele lista))))		  	  	   

; funzione che data una lista elimina l elemento in testa alla lista
; infatti il risultato è l elemento eliminato
(defun pop-lista (lista)
	(cond ((null lista)nil)
	      (t(pop lista))))	

; predicato che elimina l'elemento Ele dalla lista
(defun elimina_ele (Ele lista)
	(cond ((equal Ele (car lista)) (cdr lista))
		(t(cons (car lista) (elimina_ele Ele (cdr lista))))
	)
)

; cerca il minimo di una lista
(defun cerca_massimo (lista)
	(cerca_max_ric (cdr lista) (car lista)))

(defun cerca_max_ric (lista ele-min)
	(cond ((null (car lista)) ele-min)	;caso base: ho un solo elemento
										;restituisco l'elemento
        ((> (car lista) ele-min) (cerca_max_ric (rest lista) (car lista)))
        ;se l'elemento in testa è massimo
        ;dell'elemento max attuale, passo ricorsivo
        ;cerca_massimo (rest list) (first list)
        (t (cerca_max_ric (cdr lista) ele-min))
    )
)

; cerca la posizione dell'elemento nella lista
(defun cerca_pos_elemento (lista ele)
  (if (null lista) ()
	(cond ((eql (car lista) ele) 0)
		  (t(+ 1 (cerca_pos_elemento (cdr lista) ele))))))

; restituisce l'elemento in posizione n della lista
(defun get_elemento (lista n)
	(cond((= n 0) (car lista))
		 (t(get_elemento (cdr lista) (- n 1)))))

; funzione che data una lista di liste, rimuove i doppioni
(defun rimuovi_duplicati (lista)
	(cond ((null (cdr lista)) (car lista))
          (t(remove-duplicates lista :test #'equal :from-end t) )))

; preducato che restituisce una lista con tutti i punti con y min assoluta
 (defun lista_y_min (lista)
   	(cond ((null lista) nil)
          ((eql (y(first lista)) (y(second lista))) 
                  (cons (first lista) (lista_y_min (rest lista))))
          (t (list (car lista)))
    )
)

(defun get_nextPt (points listaAngoli)
	(get_elemento points
				(cerca_pos_elemento listaAngoli
  									(cerca_massimo listaAngoli)
  				)
  	)
)

(defun elimina_ele_listaAngoli (listaAngoli)
	(elimina_ele (cerca_massimo listaAngoli) listaAngoli)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	IMPLEMENTAZIONE DELL'ARGORITMO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; predicati d'appoggio al main
(defun primo_punto (listaPt)
	(secondo_punto (elimina_ele (car(ordinax (lista_y_min listaPt)))listaPt)	;passo la lista aggiornata
				(push_lista (car(ordinax (lista_y_min listaPt))) (list))
				(rest (lista_angle2d listaPt
									(car(ordinax (lista_y_min listaPt)))))
	)
)

(defun secondo_punto (listaPt pila listaAngoli)
  (terzo_punto (elimina_ele (get_nextPt listaPt listaAngoli) listaPt)
  			(push_lista (get_nextPt listaPt listaAngoli) pila)
  			(elimina_ele (cerca_massimo listaAngoli) listaAngoli)
  )
)

(defun terzo_punto (listaPt pila listaAngoli)
  (recursive_main (elimina_ele (get_nextPt listaPt listaAngoli) listaPt)
  			(push_lista (get_nextPt listaPt listaAngoli) pila)
  			(elimina_ele_listaAngoli listaAngoli)
  )
)

(defun recursive_main (listaPt pila listaAngoli)
	(cons (car pila) (rest pila))
)

;(defparameter app3 (list (list 5 1) (list 3 3) (list -4 1) (list 1 5) (list -1 1) (list 4 -2) (list -2 -1) (list 2 -2) (list 1 -1)))
(defun ch (Points)
	(if (>= (lengh (rimuovi_duplicati Points)) 3)
		(primo_punto (ordinay (rimuovi_duplicati Points)))
		nil
	)
)

