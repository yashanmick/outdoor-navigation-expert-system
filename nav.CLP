;------------------------------
;template for navigation facts
;------------------------------

(deftemplate nav "Structure of navigation"
	(slot object-width (type NUMBER))
	(slot object-depth-from-begining (type NUMBER))
	(slot object-to-left-boarder (type NUMBER))
	(slot object-to-right-boarder (type NUMBER))
	(slot road-width (type NUMBER))
	(slot frame-point (type NUMBER))
	)

(deftemplate guidelines "directions"
	(slot guide-path (type STRING) (allowed-strings "LEFT" "RIGHT" "STRAIGHT" ""))
	)


;--------------------------------
;salience - is all about priority
;--------------------------------


;--------------------------------
;rule 1 - (length to object from the begining is > 1 & frame point is near to left boarder) 
;--------------------------------

(defrule OFFU01 "Object Far From User & near to left boarder"
	(declare (salience 50))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: ( >
			?v_object-depth-from-begining 1))
			(frame-point
			?v_frame-point&: (< ?v_frame-point 0.5))
		)

	=>
		(assert  (guidelines (guide-path "RIGHT")))
	)


;--------------------------------
;rule 2 - (length to object from the begining is > 1 & frame point is near to right boarder) 
;--------------------------------


(defrule OFFU02 "Object Far From User & near to right boarder "
	(declare (salience 50))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: ( >
			?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(frame-point
			?v_frame-point&: (> ?v_frame-point (- ?v_road-width 0.5)))
		)

	=>
		(assert  (guidelines (guide-path "LEFT")))
	)



;--------------------------------
;rule 3 - (length to object from the begining is > 1 & in safe range) 
;--------------------------------


(defrule OFFU03 "Object Far From User & in safe range "
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: ( >
			?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(frame-point
			?v_frame-point&: (and (numberp ?v_frame-point) 
			(< ?v_frame-point (- ?v_road-width 0.5))
			(> ?v_frame-point 0.5)))

		)

	=>
		(assert  (guidelines (guide-path "STRAIGHT")))
	)


;--------------------------------
;rule 4 - (length to object from the begining is < 1 & closer to left boarder ) 
;--------------------------------

(defrule ONTU01 "Object Near To User & frame point closer to left boarder"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(frame-point
			?v_frame-point&: (< ?v_frame-point 0.5)
			)
		)

	=>
		(assert  (guidelines (guide-path "RIGHT")))
	)



;--------------------------------
;rule 5 - (length to object from the begining is < 1 & closer to right boarder ) 
;--------------------------------

(defrule ONTU02 "Object Near To User & frame point closer to right boarder"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(frame-point
			?v_frame-point&: (> ?v_frame-point (- ?v_road-width 0.5))
			)
		)

	=>
		(assert  (guidelines (guide-path "LEFT")))
	)


;--------------------------------
;rule 6 - (length to object from the begining is < 1 & at left half of the road ) 
;--------------------------------

(defrule ONTU03 "Object Near To User & in the left half of the road"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(object-width ?v_object-width)
			(object-to-left-boarder ?v_object-to-left-boarder)
			(frame-point
			?v_frame-point&: (and (numberp ?v_frame-point) 
			(> ?v_frame-point (- ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(< ?v_frame-point (+ ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(< ?v_frame-point (- (* ?v_road-width 0.5) (* ?v_object-width 0.5))))
			)
		)

	=>
		(assert  (guidelines (guide-path "RIGHT")))
	)



;--------------------------------
;rule 7 - (length to object from the begining is < 1 & at right half of the road ) 
;--------------------------------

(defrule ONTU04 "Object Near To User & in the right half of the road"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(object-width ?v_object-width)
			(object-to-left-boarder ?v_object-to-left-boarder)
			(frame-point
			?v_frame-point&: (and (numberp ?v_frame-point) 
			(> ?v_frame-point (- ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(< ?v_frame-point (+ ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(> ?v_frame-point (+ (* ?v_road-width 0.5) (* ?v_object-width 0.5))))
			)
		)

	=>
		(assert  (guidelines (guide-path "LEFT")))
	)


;--------------------------------
;rule 8 - (length to object from the begining is < 1 & at left half of the road, but no object directly infront of user ) 
;--------------------------------

(defrule ONTU05 "Object Near To User & in the left half of the road , but not infront of"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(object-width ?v_object-width)
			(object-to-left-boarder ?v_object-to-left-boarder)
			(frame-point
			?v_frame-point&: (and (numberp ?v_frame-point) 
			(< ?v_frame-point (- ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(> ?v_frame-point 0.5)
			(< ?v_frame-point (- (* ?v_road-width 0.5) (* ?v_object-width 0.5))))
			)
		)

	=>
		(assert  (guidelines (guide-path "STRAIGHT")))
	)



;--------------------------------
;rule 9 - (length to object from the begining is < 1 & at right half of the road, but no object directly infront of user ) 
;--------------------------------

(defrule ONTU06 "Object Near To User & in the right half of the road , but not infront of"
	(declare (salience 40))
	?f <- (nav
			(object-depth-from-begining
			?v_object-depth-from-begining&: (< ?v_object-depth-from-begining 1))
			(road-width ?v_road-width)
			(object-width ?v_object-width)
			(object-to-left-boarder ?v_object-to-left-boarder)
			(frame-point
			?v_frame-point&: (and (numberp ?v_frame-point) 
			(> ?v_frame-point (+ ?v_object-to-left-boarder (* ?v_object-width 0.5)))
			(< ?v_frame-point (- ?v_road-width 0.5))
			(> ?v_frame-point (+ (* ?v_road-width 0.5) (* ?v_object-width 0.5))))
			)
		)

	=>
		(assert  (guidelines (guide-path "STRAIGHT")))
	)









































