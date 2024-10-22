exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

let first_then_apply array predicate consumer = (* Find the optional first item in the array that satisfies the predicate and then consume it*)
  match List.find_opt predicate array with
  | None -> None
  | Some x -> consumer x;;

let powers_generator base = (* Recursively generate a sequence of powers *)
  let rec generate_from power () =
    Seq.Cons (power, generate_from (power * base))
  in
  generate_from 1;;

let meaningful_line_count filename = (* Counts the number of meaningful lines in a file *)
  let meaningful_line line = (* a meaningful line is defined as a non-whitespace line that doesn't start with "#" *)
    let trimmed = String.trim line in
    String.length trimmed > 0 && not (String.get trimmed 0 = '#')
  in
  let the_file = open_in filename in (* Open the file *)
  let finally () = close_in the_file in (* Make sure we close the file at the end *)
  let rec count_lines count = (* Recursively go through the lines and compare to the meaningful_line definition above *)
    try
      let line = input_line the_file in
      if meaningful_line line then
        count_lines (count + 1)
      else
          count_lines count
    with
    | End_of_file -> count (* Return count at the end of the file *)
  in
  Fun.protect ~finally (fun () -> count_lines 0);; (* Protect the function so it auto-closes and then start counting *)

type shape =  (* Shape type *)
  | Sphere of float
  | Box of float * float * float

let volume shape = (* Returns volume of a shape *)
  match shape with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h;;

let surface_area shape = (* Returns surface area of a shape *)
  match shape with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. ((l *. w) +. (w *. h) +. (h *. l))


type 'a binary_search_tree = (* BST of generic type 'a *)
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size bst = (* Returns size of a BST *)
  match bst with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right;;

let rec insert value bst = (* Inserts a value into a BST *)
  match bst with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, nodeValue, right) ->
    if value < nodeValue then
      Node ((insert value left), nodeValue, right)
    else if value > nodeValue then
      Node (left, nodeValue, (insert value right))
    else
      Node (left, nodeValue, right)

let rec contains value bst = (* Checks to see if the given value is in the BST *)
  match bst with
  | Empty -> false
  | Node (left, nodeValue, right) -> 
    if nodeValue = value then
      true
    else if value < nodeValue then
      contains value left
    else
      contains value right;;

let rec inorder bst = (* Returns in order traversal of a BST *)
  match bst with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right;;
