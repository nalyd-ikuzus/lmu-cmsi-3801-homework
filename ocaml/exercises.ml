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

let first_then_apply array predicate consumer =
  match List.find_opt predicate array with
  | None -> None
  | Some x -> consumer x;;

let powers_generator base =
  let rec generate_from power () =
    Seq.Cons (power, generate_from (power * base))
  in
  generate_from 1;;

let meaningful_line_count filename =
  let meaningful_line line =
    let trimmed = String.trim line in
    String.length trimmed > 0 && not (String.get trimmed 0 = '#')
  in
  let the_file = open_in filename in
  let finally () = close_in the_file in
  let rec count_lines count =
    try
      let line = input_line the_file in
      if meaningful_line line then
        count_lines (count + 1)
      else
          count_lines count
    with
    | End_of_file -> count
  in
  Fun.protect ~finally (fun () -> count_lines 0);;

type shape = 
  | Sphere of float
  | Box of float * float * float

let volume shape =
  match shape with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h;;

let surface_area shape =
  match shape with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. ((l *. w) +. (w *. h) +. (h *. l))


type 'a binary_search_tree =
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size bst =
  match bst with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right;;

let rec insert value bst =
  match bst with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, nodeValue, right) ->
    if value < nodeValue then
      Node ((insert value left), nodeValue, right)
    else if value > nodeValue then
      Node (left, nodeValue, (insert value right))
    else
      Node (left, nodeValue, right)

let rec contains value bst =
  match bst with
  | Empty -> false
  | Node (left, nodeValue, right) -> 
    if nodeValue = value then
      true
    else if value < nodeValue then
      contains value left
    else
      contains value right;;

let rec inorder bst =
  match bst with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right;;
