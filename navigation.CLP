;------------------------------
;template for navigation facts
;------------------------------

(deftemplate nav "Structure of navigation"
	(slot object-width (type FLOAT))
	(slot object-depth-from-begining (type FLOAT))
	(slot object-to-left-boarder (type FLOAT))
	(slot object-to-right-boarder (type FLOAT))
	(slot road-width (type FLOAT))
	(slot frame-point (type FLOAT))
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
		(modify ?f
			(guide-path "RIGHT")
		)
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
		(modify ?f
			(guide-path "LEFT")
		)
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
		(modify ?f
			(guide-path "STRAIGHT")
		)
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
		(modify ?f
			(guide-path "RIGHT")
		)
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
		(modify ?f
			(guide-path "RIGHT")
		)
	)




