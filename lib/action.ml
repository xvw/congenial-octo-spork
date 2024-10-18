open Yocaml

let track_binary = Pipeline.track_file Path.(rel [ Sys.argv.(0) ])

let process_css =
  Action.batch
    ~only:`Files
    ~where:(Path.has_extension "css")
    Path.(rel [ "assets"; "css" ])
    (Action.copy_file ~into:Target.css)
;;

let process_article file =
  let target = Target.article file in
  Action.Static.write_file_with_metadata
    target
    (let open Task in
     track_binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Archetype.Article)
           file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Article)
           Path.(rel [ "assets"; "templates"; "article.html" ])
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Article)
           Path.(rel [ "assets"; "templates"; "layout.html" ]))
;;

let process_articles =
  Action.batch
    ~only:`Files
    ~where:(Path.has_extension "md")
    Path.(rel [ "content"; "articles" ])
    process_article
;;

let process_index =
  let file = Path.(rel [ "content"; "index.md" ])
  and target = Path.(Target.www / "index.html") in
  let compute_index =
    Archetype.Articles.compute_index
      (module Yocaml_yaml)
      ~where:(Path.has_extension "md")
      ~compute_link:Target.article_link
      Path.(rel [ "content"; "articles" ])
  in
  Action.Static.write_file_with_metadata
    target
    (let open Task in
     track_binary
     >>> Pipeline.track_file Path.(rel [ "content"; "articles" ])
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Archetype.Page)
           file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Static.on_metadata compute_index
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Articles)
           Path.(rel [ "assets"; "templates"; "index.html" ])
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Articles)
           Path.(rel [ "assets"; "templates"; "layout.html" ]))
;;

let generate_atom =
  let authors =
    Yocaml.Nel.singleton (Yocaml_syndication.Person.make "Didier Plaindoux")
  in
  Action.Static.write_file
    Target.atom
    (let open Task in
     Archetype.Articles.fetch
       (module Yocaml_yaml)
       ~where:(Path.has_extension "md")
       ~compute_link:Target.article_link
       Path.(rel [ "content"; "articles" ])
     >>> Yocaml_syndication.Atom.from_articles
           ~site_url:"https://xvw.lol"
           ~authors
           ~title:(Yocaml_syndication.Atom.text "My feed")
           ~feed_url:"https://xvw.lol/atom"
           ())
;;

let all () =
  let open Eff in
  Action.restore_cache Target.cache
  >>= process_css
  >>= process_articles
  >>= process_index
  >>= generate_atom
  >>= Action.store_cache Target.cache
;;
