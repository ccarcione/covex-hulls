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

; cerca il minimo di una lista
(defun cerca_minimo (lista)
	(cerca_min_ric (cdr lista) (car lista)))

(defun cerca_min_ric (lista ele-min)
	(cond ((null (car lista)) ele-min)	;caso base: ho un solo elemento
										;restituisco l'elemento
        ((< (car lista) ele-min) (cerca_min_ric (rest lista) (car lista)))
        ;se l'elemento in testa è minore
        ;dell'elemento min attuale, passo ricorsivo
        ;cerca_minimo (rest list) (first list)
        (t (cerca_min_ric (cdr lista) ele-min))
    )
)

; cerca la posizione dell'elemento nella lista
(defun cerca_elemento (lista ele)
  (if (null lista) ()
	(cond ((eql (car lista) ele) 0)
		  (t(+ 1 (cerca_elemento (cdr lista) ele))))))

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
          (t (car lista))
    )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	IMPLEMENTAZIONE DELL'ARGORITMO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; predicati d'appoggio al main
(defun seleziona_primo_punto (listaPt)
	(cons
		(car(ordinax (lista_y_min (listaPt))))
		(seleziona_secondo_punto (elimina_ele listaPt))
	)
)

(defun seleziona_secondo_punto (listaPt)
  (listaPt)
)

(defun ch (Points)
	(if (>= 3 (lengh (rimuovi_duplicati Points)))
		(seleziona_primo_punto (ordinay (rimuovi_duplicati Points)))
	)
)

