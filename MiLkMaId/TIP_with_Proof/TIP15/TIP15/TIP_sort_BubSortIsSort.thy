(* This Isabelle theory is produced using the TIP tool offered at the following website: 
     https://github.com/tip-org/tools 
   This file was originally provided as part of TIP benchmark at the following website:
     https://github.com/tip-org/benchmarks 
   Yutaka Nagashima at CIIRC, CTU changed the TIP output theory file slightly 
   to make it compatible with Isabelle2017.
\:w
   Some proofs were added by Yutaka Nagashima.*)
  theory TIP_sort_BubSortIsSort
  imports "../../Test_Base"
begin

datatype ('a, 'b) pair = pair2 "'a" "'b"

datatype 'a list = nil2 | cons2 "'a" "'a list"

fun insert :: "int => int list => int list" where
  "insert x (nil2) = cons2 x (nil2)"
| "insert x (cons2 z xs) =
     (if x <= z then cons2 x (cons2 z xs) else cons2 z (insert x xs))"

fun isort :: "int list => int list" where
  "isort (nil2) = nil2"
| "isort (cons2 y xs) = insert y (isort xs)"

fun bubble :: "int list => (bool, (int list)) pair" where
  "bubble (nil2) = pair2 False (nil2)"
| "bubble (cons2 y (nil2)) = pair2 False (cons2 y (nil2))"
| "bubble (cons2 y (cons2 y2 xs)) =
     (if y <= y2 then
        (case bubble (cons2 y2 xs) of
           pair2 b22 ys22 => pair2 b22 (cons2 y ys22))
        else
        (case bubble (cons2 y xs) of
           pair2 b2 ys2 => pair2 True (cons2 y2 ys2)))"

(*fun did not finish the proof*)
function bubsort :: "int list => int list" where
  "bubsort x =
   (case bubble x of pair2 b1 ys => (if b1 then bubsort ys else x))"
  by pat_completeness auto

theorem property0 :
  "((bubsort xs) = (isort xs))"
  oops

end
