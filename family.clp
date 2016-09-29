(clear)

(deftemplate male (slot person))
(deftemplate female (slot person))
(deftemplate father-of  (slot father) (slot child))
(deftemplate mother-of  (slot mother) (slot child))
(deftemplate wife-of    (slot wife) (slot husband))
(deftemplate husband-of (slot husband) (slot wife))

(deftemplate parent-of (slot parent) (slot child))
(deftemplate uncle-of (slot uncle) (slot person))
(deftemplate aunt-of (slot aunt) (slot person))
(deftemplate cousin-of (slot cousin) (slot person))
(deftemplate grandparent-of (slot gp) (slot gc))
(deftemplate grandmother-of (slot gm) (slot gc))
(deftemplate grandfather-of (slot gf) (slot gc))
(deftemplate sister-of (slot sister) (slot person))
(deftemplate brother-of (slot brother) (slot person))

(deffacts my-family
    (mother-of (mother jeanne) (child connie))
    (father-of (father bob) (child connie))
    (sister-of (sister hannah) (person thomas))
    (mother-of (mother hannah) (child barney))
    (mother-of (mother tara) (child connor))
    (sister-of (sister tara) (person connie))
    (brother-of (brother paul) (person victor))
    (father-of (father victor) (child thomas))
    (wife-of (wife connie) (husband victor))
    (father-of (father thomas) (child timmy))
    (father-of (father thomas) (child sally))
    (female (person sally))
    (male (person timmy))
)
(reset)

(defrule cousin-of
  (and
    (parent-of (parent ?a) (child ?c1))
    (parent-of (parent ?b) (child ?c2))
    (parent-of (parent ?g) (child ?a))
    (parent-of (parent ?g) (child ?b))
    (test (neq ?a ?b)))
  =>
  (assert (cousin-of (cousin ?c1) (person ?c2)))
)

(defrule grandmother-of
  (and
    (female (person ?p))
    (grandparent-of (gp ?p) (gc ?c)))
  =>
  (assert (grandmother-of (gm ?p) (gc ?c)))
)

(defrule grandfather-of
  (and
    (male (person ?p))
    (grandparent-of (gp ?p) (gc ?c)))
  =>
  (assert (grandfather-of (gf ?p) (gc ?c)))
)

(defrule aunt-of
  (and
    (parent-of (parent ?p) (child ?c))
    (sister-of (sister ?u) (person ?p)))
  =>
  (assert (aunt-of (aunt ?u) (person ?c)))
)

(defrule uncle-of
  (and
    (parent-of (parent ?p) (child ?c))
    (brother-of (brother ?u) (person ?p)))
  =>
  (assert (uncle-of (uncle ?u) (person ?c)))
)

(defrule husband-of
  (and
    (parent-of (parent ?f) (child ?c))
    (parent-of (parent ?m) (child ?c))
    (male (person ?m))
    (test (neq ?f ?m)))
  =>
  (assert (husband-of (husband ?m) (wife ?f)))
)

(defrule wife-of
  (and
    (parent-of (parent ?f) (child ?c))
    (parent-of (parent ?m) (child ?c))
    (female (person ?f))
    (test (neq ?f ?m)))
  =>
  (assert (wife-of (wife ?f) (husband ?m)))
)

(defrule parent-of
  (or
    (or
      (father-of (father ?p) (child ?c))
      (mother-of (mother ?p) (child ?c)))
    (and
      (parent-of (parent ?p) (child ?s))
      (or
        (sister-of (sister ?s) (person ?c))
        (brother-of (brother ?s) (person ?c)))))
  =>
  (assert (parent-of (parent ?p) (child ?c)))
)

(defrule mother-of
  (or
    (and
      (female (person ?p))
      (parent-of (parent ?p) (child ?c)))
    (and
      (wife-of (wife ?p) (husband ?h))
      (parent-of (parent ?h) (child ?c))))
   =>
  (assert (mother-of (mother ?p) (child ?c)))
)

(defrule father-of
  (or
    (and
      (male (person ?p))
      (parent-of (parent ?p) (child ?c)))
    (and
      (husband-of (husband ?p) (wife ?w))
      (parent-of (parent ?w) (child ?c))))
   =>
  (assert (father-of (father ?p) (child ?c)))
)

(defrule sister-of
  (and
    (female (person ?p1))
    (or
      (and
        (parent-of (parent ?p3) (child ?p1))
        (parent-of (parent ?p3) (child ?p2&: (<> ?p1 ?p2))))
      (and
        (or
          (sister-of (sister ?p2) (person ?p1))
          (brother-of (brother ?p2) (person ?p1))))))
  =>
  (assert (sister-of (sister ?p1) (person ?p2)))
)

(defrule brother-of
  (and
    (male (person ?p1))
    (or
      (and
        (parent-of (parent ?p3) (child ?p1))
        (parent-of (parent ?p3) (child ?p2&: (<> ?p1 ?p2))))
      (and
        (or
          (sister-of (sister ?p2) (person ?p1))
          (brother-of (brother ?p2) (person ?p1))))))
  =>
  (assert (brother-of (brother ?p1) (person ?p2)))
)


(defrule grandparent-of
  (and
    (parent-of (parent ?p1) (child ?m))
    (parent-of (parent ?m) (child ?p2)))
  =>
  (assert (grandparent-of (gp ?p1) (gc ?p2)))
)

(defrule male
  (or
    (father-of (father ?m))
    (husband-of (husband ?m))
    (brother-of (brother ?m))
    (grandfather-of (gf ?m))
    (uncle-of (uncle ?m)))
  =>
  (assert (male (person ?m)))
)

(defrule female
  (or
    (mother-of (mother ?m))
    (wife-of (wife ?m))
    (sister-of (sister ?m))
    (grandmother-of (gm ?m))
    (aunt-of (aunt ?m)))
  =>
  (assert (female (person ?m)))
)

(run)
(facts)
