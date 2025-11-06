 module Point = struct 
    type t = {
        x : int;
        y : int;
    } 
    let compare p1 p2 =
       match compare p1.x p2.x with
       | 0 -> compare p1.y p2.y
       | d -> d
end

module Points = Set.Make(Point)

let read_char () =
try Some (input_char stdin) with _ -> None

let rec count_houses i santa robot visited = 
    let open Point in
    let santa_move = i mod 3 = 0 in
    match read_char () with
    | None   -> Points.cardinal visited
    | Some c -> 
            let pos = if santa_move then santa else robot in
            let next_pos = match c with
                | '<' -> { pos with x = pos.x - 1 } 
                | '>' -> { pos with x = pos.x + 1 }
                | '^' -> { pos with y = pos.y + 1 }
                | 'v' -> { pos with y = pos.y - 1 }
                | _   ->  pos in
            if santa_move then
                count_houses (i + 1) next_pos robot (Points.add next_pos visited)
            else
                count_houses (i + 1) santa next_pos (Points.add next_pos visited)

let solution: int =
    let open Point in
    let start = { x = 0; y = 0; } in
    let visited = Points.add start Points.empty in
    count_houses 0 start start visited

let () = 
    Printf.printf "Houses: %d" solution
