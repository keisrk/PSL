(* This Isabelle theory is produced using the TIP tool offered at the following website: 
     https://github.com/tip-org/tools 
   This file was originally provided as part of TIP benchmark at the following website:
     https://github.com/tip-org/benchmarks 
   Yutaka Nagashima at CIIRC, CTU changed the TIP output theory file slightly 
   to make it compatible with Isabelle2017.
\:w
   Some proofs were added by Yutaka Nagashima.*)
  theory TIP_sort_NMSortTDPermutes
  imports "../../Test_Base"
begin

datatype 'a list = nil2 | cons2 "'a" "'a list"

fun take :: "int => 'a list => 'a list" where
  "take x y =
   (if x <= 0 then nil2 else
      (case y of
         nil2 => nil2
         | cons2 z xs => cons2 z (take (x - 1) xs)))"

(*fun did not finish the proof*)
function nmsorttdhalf1 :: "int => int" where
  "nmsorttdhalf1 x =
   (if (x = 1) then 0 else
      (if (x = 0) then 0 else 1 + (nmsorttdhalf1 (x - 2))))"
  by pat_completeness auto

fun lmerge :: "int list => int list => int list" where
  "lmerge (nil2) y = y"
| "lmerge (cons2 z x2) (nil2) = cons2 z x2"
| "lmerge (cons2 z x2) (cons2 x3 x4) =
     (if z <= x3 then cons2 z (lmerge x2 (cons2 x3 x4)) else
        cons2 x3 (lmerge (cons2 z x2) x4))"

fun length :: "'a list => int" where
  "length (nil2) = 0"
| "length (cons2 y l) = 1 + (length l)"

fun elem :: "'a => 'a list => bool" where
  "elem x (nil2) = False"
| "elem x (cons2 z xs) = ((z = x) | (elem x xs))"

fun drop :: "int => 'a list => 'a list" where
  "drop x y =
   (if x <= 0 then y else
      (case y of
         nil2 => nil2
         | cons2 z xs1 => drop (x - 1) xs1))"

(*fun did not finish the proof*)
function nmsorttd :: "int list => int list" where
  "nmsorttd (nil2) = nil2"
| "nmsorttd (cons2 y (nil2)) = cons2 y (nil2)"
| "nmsorttd (cons2 y (cons2 x2 x3)) =
     (let k :: int = nmsorttdhalf1 (length (cons2 y (cons2 x2 x3)))
     in lmerge
          (nmsorttd (take k (cons2 y (cons2 x2 x3))))
          (nmsorttd (drop k (cons2 y (cons2 x2 x3)))))"
  by pat_completeness auto

fun deleteBy :: "('a => ('a => bool)) => 'a => 'a list =>
                 'a list" where
  "deleteBy x y (nil2) = nil2"
| "deleteBy x y (cons2 y2 ys) =
     (if (x y) y2 then ys else cons2 y2 (deleteBy x y ys))"

fun isPermutation :: "'a list => 'a list => bool" where
  "isPermutation (nil2) (nil2) = True"
| "isPermutation (nil2) (cons2 z x2) = False"
| "isPermutation (cons2 x3 xs) y =
     ((elem x3 y) &
        (isPermutation
           xs (deleteBy (% (x4 :: 'a) => % (x5 :: 'a) => (x4 = x5)) x3 y)))"

theorem property0 :
  "isPermutation (nmsorttd xs) xs"
  oops

end
