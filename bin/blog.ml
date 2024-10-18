let target = Lib.Target.www

let () =
  match Sys.argv.(1) with
  | "w" | "watch" ->
    Yocaml_eio.serve ~level:`Info ~port:8888 ~target Lib.Action.all
  | _ | (exception _) -> Yocaml_eio.run ~level:`Debug Lib.Action.all
;;
