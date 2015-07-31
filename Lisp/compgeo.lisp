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

; la svolta è nulla, nel senso che i tre punti solo allineati
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

; applico il predicato angle2d a ogni elemento della lista
(defun lista_angle2d (lista punto)
	(cond ((null lista) nil)
		((cons (angle2d (car lista) punto)
		  		   (lista_angle2d (cdr lista) punto)))))

; funzione che ha come input una lista di punti e
; li ordina rispetto alle x	
 (defun ordinax (lista_punti)
 	(cond ((null lista_punti)nil)
 		  (t (sort lista_punti #'< :key #'first))))	

; funzione che ha come input una lista di punti e
; li ordina rispetto alle y
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

; funzione che data una lista restituisce l elemento in testa alla lista
(defun pop-lista (lista)
	(cond ((null lista)nil)
	      (t(pop lista))))	

; predicato che elimina l'elemento Ele dalla lista
(defun elimina_ele (Ele lista)
	(cond ((equal Ele (car lista)) (cdr lista))
		(t(cons (car lista) (elimina_ele Ele (cdr lista))))
	)
)

; cerca il massimo in una lista
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

; predicato che cerca la posizione dell'elemento nella lista
(defun cerca_pos_elemento (lista ele)
  (if (null lista) ()
	(cond ((eql (car lista) ele) 0)
		  (t(+ 1 (cerca_pos_elemento (cdr lista) ele))))))

; predicato che restituisce l'elemento in posizione n della lista
(defun get_elemento (lista n)
	(cond((= n 0) (car lista))
		 (t(get_elemento (cdr lista) (- n 1)))))

; funzione che data una lista di punti, rimuove i doppioni
(defun rimuovi_duplicati (lista)
	(cond ((null (cdr lista)) (car lista))
          (t(remove-duplicates lista :test #'equal :from-end t) )))

; predicato che restituisce una lista con tutti i punti con y minore assoluta
 (defun lista_y_min (lista)
   	(cond ((null lista) nil)
          ((eql (y(first lista)) (y(second lista))) 
                  (cons (first lista) (lista_y_min (rest lista))))
          (t (list (car lista)))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	IMPLEMENTAZIONE DELL'ARGORITMO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; predicato d'appoggio al main usato per trovare il 
; punto successivo da includere nella Hulls List
(defun get_nextPt (points listaAngoli)
	(get_elemento points
				(cerca_pos_elemento listaAngoli
  									(cerca_massimo listaAngoli)
  				)
  	)
)

; predicato d'appoggio al main usato per eliminare
; l'angolo del punto scelto da aggiungere alla Hulls List 
(defun elimina_ele_listaAngoli (listaAngoli)
	(elimina_ele (cerca_massimo listaAngoli) listaAngoli)
)

; questo predicato decide quale saranno i punti a far parte della Hulls List
; in base al calcolo dell'area degli ultimi 3 punti pila
(defun calcoloDirezione (pila ptC)
	(if (not(left-on (second pila) (first pila) ptC))
		(calcoloDirezione (rest pila) ptC)	;elimina B e ricorsione
		(push_lista ptC pila)	;push ptC e concludi
	)
)

; predicati d'appoggio al main per trovare i primi 3 punti iniziali
(defun primo_punto (listaPt)
	(secondo_punto (elimina_ele (car(ordinax (lista_y_min listaPt)))listaPt)
				(push_lista (car(ordinax (lista_y_min listaPt))) (list))
				(rest (lista_angle2d listaPt
									(car(ordinax (lista_y_min listaPt)))))
	)
)

(defun secondo_punto (listaPt pila listaAngoli)
  (terzo_punto (elimina_ele (get_nextPt listaPt listaAngoli) listaPt)	;passo la lista dei punti aggiornata
  			(push_lista (get_nextPt listaPt listaAngoli) pila)			;passo la pila aggiornata
  			(elimina_ele (cerca_massimo listaAngoli) listaAngoli)		;elimino relativo angolo del punto aggiunto in pila
  )
)

(defun terzo_punto (listaPt pila listaAngoli)
  (recursive_main (elimina_ele (get_nextPt listaPt listaAngoli) listaPt)
  			(push_lista (get_nextPt listaPt listaAngoli) pila)
  			(elimina_ele_listaAngoli listaAngoli)
  )
)

; passo main ricorsivo, quando la lista è vuota chiama un predicato che svuota la pila
(defun recursive_main (listaPt pila listaAngoli)
	(if (null listaPt) (stampa_pila pila)
		(recursive_main (elimina_ele (get_nextPt listaPt listaAngoli) listaPt)	;passo la lista dei punti aggiornata
	  			(calcoloDirezione pila (get_nextPt listaPt listaAngoli))			;controlla che gli ultimi 3 punti (ABC) abbiano area>=0
	  																		; altrimenti cancella B e ricontrolla
	  																		;alla fine ho la pila aggiornata
	  			(elimina_ele_listaAngoli listaAngoli)						;elimino relativo angolo del punto aggiunto in pila
		)
	)
)

; predicato che mostra la pila su monitor
(defun stampa_pila (pila)
	(cons (car pila) (rest pila))
)

; goal di prova
; (defparameter app3 (list (list 5 1) (list 3 3) (list -4 1) (list 1 5) (list -1 1) (list 4 -2) (list -2 -1) (list 2 -2) (list 1 -1)))
; chiamata principale del programma
(defun ch (Points)
	(if (>= (lengh (rimuovi_duplicati Points)) 3)
		(primo_punto (ordinay (rimuovi_duplicati Points)))
		nil
	)
)

; predicato per lettura punti da file
(defun read-points (filename)
	(with-open-file (stream filename)
	    (do ((line (read-line stream nil)
	               (read-line stream nil)))
	        ((null line))
	      (print line))
	)
)
