(clear)

(deftemplate person
  (slot name)
  (slot credit)
  (slot age)
  (slot distance)
  (slot offenses)
  (slot cost))

(deftemplate policy
  (slot name)
  (slot risk)
  (slot cost))

(deftemplate to_add
  (slot name)
  (slot risk))

(defrule init
  (person (name ?n))  
  =>
  (assert (policy (name ?n) (risk 0) (cost 0))))

(defrule set_cost
  (declare (salience -1) (no-loop TRUE))
  ?po <- (policy (name ?n) (risk ?r) (cost ?c))
  =>
  (modify ?po (cost (* 700 (+ 1 (/ (/ ?r 100) 5))))))

(defrule print_out
  (declare (salience -2))
  (policy (name ?n) (cost ?c) (risk ?r))
  =>
  (printout t ?n ":: risk " ?r " -- $" ?c crlf))

(defrule add
  ?po <- (policy (name ?n) (risk ?r1))
  ?x <- (to_add(name ?n) (risk ?r2))
  =>
  (retract ?x)
  (modify ?po (risk (+ ?r1 ?r2))))

(defrule age
  (person (name ?n)(age ?x))
  =>
  (bind ?value 0)
  (if (and (>= ?x 75) (<= ?x 18)) then (bind ?value 5))
  (assert (to_add (name ?n)(risk ?value))))

(defrule credit
  (person (name ?n)(offenses ?x))
  =>
  (bind ?value 0)
  (if (and (> ?x 600) (<= ?x 700)) then (bind ?value 2))
  (if (< ?x 600) then (bind ?value 5))
  (assert (to_add (name ?n)(risk ?value))))

(defrule offenses
  (person (name ?n)(offenses ?x))
  =>
  (bind ?value 0)
  (if (and (> ?x 10) (<= ?x 20)) then (bind ?value 2))
  (if (> ?x 20) then (bind ?value 10))
  (assert (to_add (name ?n)(risk ?value))))

(defrule distance
  (person (name ?n)(distance ?x))
  =>
  (bind ?value 0)
  (if (and (> ?x 20) (<= ?x 50)) then (bind ?value 2))
  (if (> ?x 50) then (bind ?value 5))
  (assert (to_add (name ?n)(risk ?value))))

(defrule cost
  (person (name ?n)(cost ?x))
  =>
  (bind ?value 0)
  (if (and (> ?x 5000) (<= ?x 20000)) then (bind ?value 5))
  (if (> ?x 20000) then (bind ?value 10))
  (assert (to_add (name ?n)(risk ?value))))

(deffacts drivers
  (person
    (name Sarah)
    (age 18.5)
    (cost 5000)
    (distance 20)
    (offenses 10)
    (credit 700.5))
  (person
    (name Daniel)
    (age 18)
    (cost 5001)
    (distance 20.5)
    (offenses 11)
    (credit 700)))

(reset)

(run)
(facts)
