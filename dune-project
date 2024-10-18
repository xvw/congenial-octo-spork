(lang dune 3.16)
(name blog)
(version dev)
(generate_opam_files)
(executables_implicit_empty_intf)

(source (github xvw/congenial-octo-spork))
(license MIT)
(authors "Xavier Van de Woestyne <xaviervdw@gmail.com>")
(maintainers "Xavier Van de Woestyne <xaviervdw@gmail.com>")

(package
 (name blog)
 (synopsis "A simple blog generator")
 (description "A simple blog generator example")
 (depends

  ;; Build dependencies 
  (ocaml (>= 5.2.0))
  (dune (>= 3.16.0))

  cmarkit

  ;; Yocaml dependencies 
  (yocaml (>= 2.0.0))
  (yocaml_eio (>= 2.0.0))
  (yocaml_cmarkit (>= 2.0.0))
  (yocaml_jingoo (>= 2.0.0))
  (yocaml_syndication (>= 2.0.0))
  (yocaml_yaml (>= 2.0.0))
  (yocaml_otoml (>= 2.0.0))

  ;; Test utils
  (ppx_expect :with-test)
   
  ;; Dev setup
  (utop :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
