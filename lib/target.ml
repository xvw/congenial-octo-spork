open Yocaml

let www = Path.rel [ "_www" ]
let cache = Path.(www / "cache")
let css = Path.(www / "css")
let articles = Path.(www / "articles")

let article path =
  path |> Path.change_extension "html" |> Path.move ~into:articles
;;

let article_link path =
  path
  |> Path.change_extension "html"
  |> Path.move ~into:Path.(root / "articles")
;;

let atom = Path.(www / "feed.atom")
