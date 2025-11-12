(defn operate
  [op lhs &opt rhs]
  (def u16-bnot |(+ (mod (bnot $) 0xffff) 1))
  (case op
    "NOT" (u16-bnot lhs)
    "AND" (band lhs rhs)
    "OR"  (bor lhs rhs)
    "LSHIFT" (blshift lhs rhs)
    "RSHIFT" (brshift lhs rhs)))

(def npeg (peg/compile '(number (some :d))))
(defn try-number
  [str]
  (def result (peg/match npeg str))
  (if result (first result)
  result))

(defn read-wire
  [wire wire-map]
  (def w (wire-map wire))
  (def num (try-number wire))
  (cond
    num num
    (number? w) w
    (set (wire-map wire)
         (case (length w)
            1 (read-wire (first w) wire-map)
            2 (let [[x y] w]
                assert (= x "NOT")
                (operate x (read-wire y wire-map)))
            3 (let [[x y z] w]
                (def lhs (read-wire x wire-map))
                (def rhs (read-wire z wire-map))
                (operate y lhs rhs))))))

(defn load-wire-map
  [file]
  (def content (string/trim (slurp file)))
  (def wirings (map |(string/split " -> " $) (string/split "\n" content)))

  (def wire-map @{})
  (each w wirings
    (put wire-map (w 1) (string/split " " (w 0))))
  wire-map)

# Goofin
(def wire-map (load-wire-map "input.txt"))
(var wm (table/clone wire-map))

(def a-signal (read-wire "a" wm))
(print "Part 1: " a-signal)

(set wm (table/clone wire-map))
(set (wm "b") a-signal)
(print "Part 2: " (read-wire "a" wm)))
