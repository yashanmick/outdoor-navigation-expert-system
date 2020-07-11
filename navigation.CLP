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
	(slot guide-path (type STRING) (default "NONe"))
	)


;--------------------------------
;salience - is all about priority
;--------------------------------


;--------------------------------
;rule 1 - (length to object from the begining is > 1 & frame point is near to left boarder) 
;--------------------------------

(defrule offu-one "Object Far From User & near to left boarder"
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
			(guide-path "Right")
		)
	)


	;--------------------------------
;rule 2 - (length to object from the begining is > 1 & frame point is near to right boarder) 
;--------------------------------


(defrule offu-two "Object Far From User & near to right boarder "
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
			(guide-path "Left")
		)
	)



;--------------------------------
;rule 3 - (length to object from the begining is > 1 & in safe range) 
;--------------------------------


(defrule offu-three "Object Far From User & in safe tange "
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
			(guide-path "Straight")
		)
	)



