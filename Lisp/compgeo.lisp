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
	
 		  	   