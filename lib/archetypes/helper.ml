type ex_pp = PP : (string * 'a * (Format.formatter -> 'a -> unit)) -> ex_pp

let pp_field key value pp = PP (key, value, pp)

let rec pp_fields ppf = function
  | [] -> ()
  | PP (k, v, pp) :: (_ :: _ as xs) ->
    let () = Format.fprintf ppf "%s: %a;@ " k pp v in
    pp_fields ppf xs
  | PP (k, v, pp) :: xs ->
    let () = Format.fprintf ppf "%s: %a" k pp v in
    pp_fields ppf xs
;;

let pp_record record_name ppf repr =
  Format.fprintf ppf "%s {@[<hov 1>%a@]}" record_name pp_fields repr
;;

let pp_quoted_string ppf str = Format.fprintf ppf {|"%s"|} str
