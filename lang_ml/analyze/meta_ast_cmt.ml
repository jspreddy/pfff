open Typedtree

module Env = struct
    let vof_t x = Ocaml.VUnit
end
module Location = struct
    let vof_t x = Ocaml.VUnit
end
module Path = struct
    let vof_t x = Ocaml.VUnit
end
module Longident = struct
    let vof_t x = Ocaml.VUnit
end
module Ident = struct
    let vof_t x = Ocaml.VUnit
end
module Concr = struct
    let vof_t x = Ocaml.VUnit
end
module Meths = struct
    let vof_t f x = Ocaml.VUnit
end
module Primitive = struct
    let vof_description x = Ocaml.VUnit
end
module Types = struct
    let vof_value_description x = Ocaml.VUnit
    let vof_class_declaration x = Ocaml.VUnit
    let vof_class_type x = Ocaml.VUnit
    let vof_class_signature x = Ocaml.VUnit
    let vof_module_type x = Ocaml.VUnit
    let vof_signature x = Ocaml.VUnit
    let vof_type_declaration x = Ocaml.VUnit
    let vof_exception_declaration x = Ocaml.VUnit
    let vof_class_type_declaration x = Ocaml.VUnit
end

let vof_type_expr x = Ocaml.VUnit
let vof_loc f x = Ocaml.VUnit
let vof_constant x = Ocaml.VUnit
let vof_constructor_description x = Ocaml.VUnit
let vof_label x = Ocaml.VUnit
let vof_row_desc x = Ocaml.VUnit
let vof_label_description x = Ocaml.VUnit
let vof_closed_flag x = Ocaml.VUnit
let vof_rec_flag x = Ocaml.VUnit
let vof_partial x =  Ocaml.VUnit
let vof_optional x = Ocaml.VUnit

let vof_direction_flag x = Ocaml.VUnit
let vof_override_flag x = Ocaml.VUnit
let vof_mutable_flag x = Ocaml.VUnit
let vof_private_flag x = Ocaml.VUnit
let vof_virtual_flag x = Ocaml.VUnit


let rec
  vof_pattern {
                pat_desc = v_pat_desc;
                pat_loc = v_pat_loc;
                pat_extra = v_pat_extra;
                pat_type = v_pat_type;
                pat_env = v_pat_env
              } =
  let bnds = [] in
  let arg = Env.vof_t v_pat_env in
  let bnd = ("pat_env", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_expr v_pat_type in
  let bnd = ("pat_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2) ->
         let v1 = vof_pat_extra v1
         and v2 = Location.vof_t v2
         in Ocaml.VTuple [ v1; v2 ])
      v_pat_extra in
  let bnd = ("pat_extra", arg) in
  let bnds = bnd :: bnds in
  let arg = Location.vof_t v_pat_loc in
  let bnd = ("pat_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_pattern_desc v_pat_desc in
  let bnd = ("pat_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_pat_extra =
  function
  | Tpat_constraint v1 ->
      let v1 = vof_core_type v1 in Ocaml.VSum (("Tpat_constraint", [ v1 ]))
  | Tpat_type ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Tpat_type", [ v1; v2 ]))
  | Tpat_unpack -> Ocaml.VSum (("Tpat_unpack", []))
and vof_pattern_desc =
  function
  | Tpat_any -> Ocaml.VSum (("Tpat_any", []))
  | Tpat_var ((v1, v2)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      in Ocaml.VSum (("Tpat_var", [ v1; v2 ]))
  | Tpat_alias ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = Ident.vof_t v2
      and v3 = vof_loc Ocaml.vof_string v3
      in Ocaml.VSum (("Tpat_alias", [ v1; v2; v3 ]))
  | Tpat_constant v1 ->
      let v1 = vof_constant v1 in Ocaml.VSum (("Tpat_constant", [ v1 ]))
  | Tpat_tuple v1 ->
      let v1 = Ocaml.vof_list vof_pattern v1
      in Ocaml.VSum (("Tpat_tuple", [ v1 ]))
  | Tpat_construct ((v1, v2, v3, v4, v5)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = vof_constructor_description v3
      and v4 = Ocaml.vof_list vof_pattern v4
      and v5 = Ocaml.vof_bool v5
      in Ocaml.VSum (("Tpat_construct", [ v1; v2; v3; v4; v5 ]))
  | Tpat_variant ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = Ocaml.vof_option vof_pattern v2
      and v3 = Ocaml.vof_ref vof_row_desc v3
      in Ocaml.VSum (("Tpat_variant", [ v1; v2; v3 ]))
  | Tpat_record ((v1, v2)) ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3, v4) ->
             let v1 = Path.vof_t v1
             and v2 = vof_loc Longident.vof_t v2
             and v3 = vof_label_description v3
             and v4 = vof_pattern v4
             in Ocaml.VTuple [ v1; v2; v3; v4 ])
          v1
      and v2 = vof_closed_flag v2
      in Ocaml.VSum (("Tpat_record", [ v1; v2 ]))
  | Tpat_array v1 ->
      let v1 = Ocaml.vof_list vof_pattern v1
      in Ocaml.VSum (("Tpat_array", [ v1 ]))
  | Tpat_or ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = vof_pattern v2
      and v3 = Ocaml.vof_option vof_row_desc v3
      in Ocaml.VSum (("Tpat_or", [ v1; v2; v3 ]))
  | Tpat_lazy v1 ->
      let v1 = vof_pattern v1 in Ocaml.VSum (("Tpat_lazy", [ v1 ]))
and
  vof_expression {
                   exp_desc = v_exp_desc;
                   exp_loc = v_exp_loc;
                   exp_extra = v_exp_extra;
                   exp_type = v_exp_type;
                   exp_env = v_exp_env
                 } =
  let bnds = [] in
  let arg = Env.vof_t v_exp_env in
  let bnd = ("exp_env", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_expr v_exp_type in
  let bnd = ("exp_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2) ->
         let v1 = vof_exp_extra v1
         and v2 = Location.vof_t v2
         in Ocaml.VTuple [ v1; v2 ])
      v_exp_extra in
  let bnd = ("exp_extra", arg) in
  let bnds = bnd :: bnds in
  let arg = Location.vof_t v_exp_loc in
  let bnd = ("exp_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_expression_desc v_exp_desc in
  let bnd = ("exp_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_exp_extra =
  function
  | Texp_constraint ((v1, v2)) ->
      let v1 = Ocaml.vof_option vof_core_type v1
      and v2 = Ocaml.vof_option vof_core_type v2
      in Ocaml.VSum (("Texp_constraint", [ v1; v2 ]))
  | Texp_open ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Env.vof_t v3
      in Ocaml.VSum (("Texp_open", [ v1; v2; v3 ]))
  | Texp_poly v1 ->
      let v1 = Ocaml.vof_option vof_core_type v1
      in Ocaml.VSum (("Texp_poly", [ v1 ]))
  | Texp_newtype v1 ->
      let v1 = Ocaml.vof_string v1 in Ocaml.VSum (("Texp_newtype", [ v1 ]))
and vof_expression_desc =
  function
  | Texp_ident ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Types.vof_value_description v3
      in Ocaml.VSum (("Texp_ident", [ v1; v2; v3 ]))
  | Texp_constant v1 ->
      let v1 = vof_constant v1 in Ocaml.VSum (("Texp_constant", [ v1 ]))
  | Texp_let ((v1, v2, v3)) ->
      let v1 = vof_rec_flag v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      and v3 = vof_expression v3
      in Ocaml.VSum (("Texp_let", [ v1; v2; v3 ]))
  | Texp_function ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      and v3 = vof_partial v3
      in Ocaml.VSum (("Texp_function", [ v1; v2; v3 ]))
  | Texp_apply ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = vof_label v1
             and v2 = Ocaml.vof_option vof_expression v2
             and v3 = vof_optional v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v2
      in Ocaml.VSum (("Texp_apply", [ v1; v2 ]))
  | Texp_match ((v1, v2, v3)) ->
      let v1 = vof_expression v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      and v3 = vof_partial v3
      in Ocaml.VSum (("Texp_match", [ v1; v2; v3 ]))
  | Texp_try ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      in Ocaml.VSum (("Texp_try", [ v1; v2 ]))
  | Texp_tuple v1 ->
      let v1 = Ocaml.vof_list vof_expression v1
      in Ocaml.VSum (("Texp_tuple", [ v1 ]))
  | Texp_construct ((v1, v2, v3, v4, v5)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = vof_constructor_description v3
      and v4 = Ocaml.vof_list vof_expression v4
      and v5 = Ocaml.vof_bool v5
      in Ocaml.VSum (("Texp_construct", [ v1; v2; v3; v4; v5 ]))
  | Texp_variant ((v1, v2)) ->
      let v1 = vof_label v1
      and v2 = Ocaml.vof_option vof_expression v2
      in Ocaml.VSum (("Texp_variant", [ v1; v2 ]))
  | Texp_record ((v1, v2)) ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3, v4) ->
             let v1 = Path.vof_t v1
             and v2 = vof_loc Longident.vof_t v2
             and v3 = vof_label_description v3
             and v4 = vof_expression v4
             in Ocaml.VTuple [ v1; v2; v3; v4 ])
          v1
      and v2 = Ocaml.vof_option vof_expression v2
      in Ocaml.VSum (("Texp_record", [ v1; v2 ]))
  | Texp_field ((v1, v2, v3, v4)) ->
      let v1 = vof_expression v1
      and v2 = Path.vof_t v2
      and v3 = vof_loc Longident.vof_t v3
      and v4 = vof_label_description v4
      in Ocaml.VSum (("Texp_field", [ v1; v2; v3; v4 ]))
  | Texp_setfield ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_expression v1
      and v2 = Path.vof_t v2
      and v3 = vof_loc Longident.vof_t v3
      and v4 = vof_label_description v4
      and v5 = vof_expression v5
      in Ocaml.VSum (("Texp_setfield", [ v1; v2; v3; v4; v5 ]))
  | Texp_array v1 ->
      let v1 = Ocaml.vof_list vof_expression v1
      in Ocaml.VSum (("Texp_array", [ v1 ]))
  | Texp_ifthenelse ((v1, v2, v3)) ->
      let v1 = vof_expression v1
      and v2 = vof_expression v2
      and v3 = Ocaml.vof_option vof_expression v3
      in Ocaml.VSum (("Texp_ifthenelse", [ v1; v2; v3 ]))
  | Texp_sequence ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 = vof_expression v2
      in Ocaml.VSum (("Texp_sequence", [ v1; v2 ]))
  | Texp_while ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 = vof_expression v2
      in Ocaml.VSum (("Texp_while", [ v1; v2 ]))
  | Texp_for ((v1, v2, v3, v4, v5, v6)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_expression v3
      and v4 = vof_expression v4
      and v5 = vof_direction_flag v5
      and v6 = vof_expression v6
      in Ocaml.VSum (("Texp_for", [ v1; v2; v3; v4; v5; v6 ]))
  | Texp_when ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 = vof_expression v2
      in Ocaml.VSum (("Texp_when", [ v1; v2 ]))
  | Texp_send ((v1, v2, v3)) ->
      let v1 = vof_expression v1
      and v2 = vof_meth v2
      and v3 = Ocaml.vof_option vof_expression v3
      in Ocaml.VSum (("Texp_send", [ v1; v2; v3 ]))
  | Texp_new ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Types.vof_class_declaration v3
      in Ocaml.VSum (("Texp_new", [ v1; v2; v3 ]))
  | Texp_instvar ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = Path.vof_t v2
      and v3 = vof_loc Ocaml.vof_string v3
      in Ocaml.VSum (("Texp_instvar", [ v1; v2; v3 ]))
  | Texp_setinstvar ((v1, v2, v3, v4)) ->
      let v1 = Path.vof_t v1
      and v2 = Path.vof_t v2
      and v3 = vof_loc Ocaml.vof_string v3
      and v4 = vof_expression v4
      in Ocaml.VSum (("Texp_setinstvar", [ v1; v2; v3; v4 ]))
  | Texp_override ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Path.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_expression v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v2
      in Ocaml.VSum (("Texp_override", [ v1; v2 ]))
  | Texp_letmodule ((v1, v2, v3, v4)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_expr v3
      and v4 = vof_expression v4
      in Ocaml.VSum (("Texp_letmodule", [ v1; v2; v3; v4 ]))
  | Texp_assert v1 ->
      let v1 = vof_expression v1 in Ocaml.VSum (("Texp_assert", [ v1 ]))
  | Texp_assertfalse -> Ocaml.VSum (("Texp_assertfalse", []))
  | Texp_lazy v1 ->
      let v1 = vof_expression v1 in Ocaml.VSum (("Texp_lazy", [ v1 ]))
  | Texp_object ((v1, v2)) ->
      let v1 = vof_class_structure v1
      and v2 = Ocaml.vof_list Ocaml.vof_string v2
      in Ocaml.VSum (("Texp_object", [ v1; v2 ]))
  | Texp_pack v1 ->
      let v1 = vof_module_expr v1 in Ocaml.VSum (("Texp_pack", [ v1 ]))
and vof_meth =
  function
  | Tmeth_name v1 ->
      let v1 = Ocaml.vof_string v1 in Ocaml.VSum (("Tmeth_name", [ v1 ]))
  | Tmeth_val v1 ->
      let v1 = Ident.vof_t v1 in Ocaml.VSum (("Tmeth_val", [ v1 ]))
and
  vof_class_expr {
                   cl_desc = v_cl_desc;
                   cl_loc = v_cl_loc;
                   cl_type = v_cl_type;
                   cl_env = v_cl_env
                 } =
  let bnds = [] in
  let arg = Env.vof_t v_cl_env in
  let bnd = ("cl_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_type v_cl_type in
  let bnd = ("cl_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Location.vof_t v_cl_loc in
  let bnd = ("cl_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_class_expr_desc v_cl_desc in
  let bnd = ("cl_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_expr_desc =
  function
  | Tcl_ident ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Ocaml.vof_list vof_core_type v3
      in Ocaml.VSum (("Tcl_ident", [ v1; v2; v3 ]))
  | Tcl_structure v1 ->
      let v1 = vof_class_structure v1
      in Ocaml.VSum (("Tcl_structure", [ v1 ]))
  | Tcl_fun ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_label v1
      and v2 = vof_pattern v2
      and v3 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_expression v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v3
      and v4 = vof_class_expr v4
      and v5 = vof_partial v5
      in Ocaml.VSum (("Tcl_fun", [ v1; v2; v3; v4; v5 ]))
  | Tcl_apply ((v1, v2)) ->
      let v1 = vof_class_expr v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = vof_label v1
             and v2 = Ocaml.vof_option vof_expression v2
             and v3 = vof_optional v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v2
      in Ocaml.VSum (("Tcl_apply", [ v1; v2 ]))
  | Tcl_let ((v1, v2, v3, v4)) ->
      let v1 = vof_rec_flag v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      and v3 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_expression v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v3
      and v4 = vof_class_expr v4
      in Ocaml.VSum (("Tcl_let", [ v1; v2; v3; v4 ]))
  | Tcl_constraint ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_class_expr v1
      and v2 = Ocaml.vof_option vof_class_type v2
      and v3 = Ocaml.vof_list Ocaml.vof_string v3
      and v4 = Ocaml.vof_list Ocaml.vof_string v4
      and v5 = Concr.vof_t v5
      in Ocaml.VSum (("Tcl_constraint", [ v1; v2; v3; v4; v5 ]))
and
  vof_class_structure {
                        cstr_pat = v_cstr_pat;
                        cstr_fields = v_cstr_fields;
                        cstr_type = v_cstr_type;
                        cstr_meths = v_cstr_meths
                      } =
  let bnds = [] in
  let arg = Meths.vof_t Ident.vof_t v_cstr_meths in
  let bnd = ("cstr_meths", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_signature v_cstr_type in
  let bnd = ("cstr_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_class_field v_cstr_fields in
  let bnd = ("cstr_fields", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_pattern v_cstr_pat in
  let bnd = ("cstr_pat", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_field { cf_desc = v_cf_desc; cf_loc = v_cf_loc } =
  let bnds = [] in
  let arg = Location.vof_t v_cf_loc in
  let bnd = ("cf_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_class_field_desc v_cf_desc in
  let bnd = ("cf_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_field_kind =
  function
  | Tcfk_virtual v1 ->
      let v1 = vof_core_type v1 in Ocaml.VSum (("Tcfk_virtual", [ v1 ]))
  | Tcfk_concrete v1 ->
      let v1 = vof_expression v1 in Ocaml.VSum (("Tcfk_concrete", [ v1 ]))
and vof_class_field_desc =
  function
  | Tcf_inher ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_override_flag v1
      and v2 = vof_class_expr v2
      and v3 = Ocaml.vof_option Ocaml.vof_string v3
      and v4 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = Ocaml.vof_string v1
             and v2 = Ident.vof_t v2
             in Ocaml.VTuple [ v1; v2 ])
          v4
      and v5 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = Ocaml.vof_string v1
             and v2 = Ident.vof_t v2
             in Ocaml.VTuple [ v1; v2 ])
          v5
      in Ocaml.VSum (("Tcf_inher", [ v1; v2; v3; v4; v5 ]))
  | Tcf_val ((v1, v2, v3, v4, v5, v6)) ->
      let v1 = Ocaml.vof_string v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_mutable_flag v3
      and v4 = Ident.vof_t v4
      and v5 = vof_class_field_kind v5
      and v6 = Ocaml.vof_bool v6
      in Ocaml.VSum (("Tcf_val", [ v1; v2; v3; v4; v5; v6 ]))
  | Tcf_meth ((v1, v2, v3, v4, v5)) ->
      let v1 = Ocaml.vof_string v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_private_flag v3
      and v4 = vof_class_field_kind v4
      and v5 = Ocaml.vof_bool v5
      in Ocaml.VSum (("Tcf_meth", [ v1; v2; v3; v4; v5 ]))
  | Tcf_constr ((v1, v2)) ->
      let v1 = vof_core_type v1
      and v2 = vof_core_type v2
      in Ocaml.VSum (("Tcf_constr", [ v1; v2 ]))
  | Tcf_init v1 ->
      let v1 = vof_expression v1 in Ocaml.VSum (("Tcf_init", [ v1 ]))
and
  vof_module_expr {
                    mod_desc = v_mod_desc;
                    mod_loc = v_mod_loc;
                    mod_type = v_mod_type;
                    mod_env = v_mod_env
                  } =
  let bnds = [] in
  let arg = Env.vof_t v_mod_env in
  let bnd = ("mod_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_module_type v_mod_type in
  let bnd = ("mod_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Location.vof_t v_mod_loc in
  let bnd = ("mod_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_module_expr_desc v_mod_desc in
  let bnd = ("mod_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_module_type_constraint =
  function
  | Tmodtype_implicit -> Ocaml.VSum (("Tmodtype_implicit", []))
  | Tmodtype_explicit v1 ->
      let v1 = vof_module_type v1
      in Ocaml.VSum (("Tmodtype_explicit", [ v1 ]))
and vof_module_expr_desc =
  function
  | Tmod_ident ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Tmod_ident", [ v1; v2 ]))
  | Tmod_structure v1 ->
      let v1 = vof_structure v1 in Ocaml.VSum (("Tmod_structure", [ v1 ]))
  | Tmod_functor ((v1, v2, v3, v4)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_type v3
      and v4 = vof_module_expr v4
      in Ocaml.VSum (("Tmod_functor", [ v1; v2; v3; v4 ]))
  | Tmod_apply ((v1, v2, v3)) ->
      let v1 = vof_module_expr v1
      and v2 = vof_module_expr v2
      and v3 = vof_module_coercion v3
      in Ocaml.VSum (("Tmod_apply", [ v1; v2; v3 ]))
  | Tmod_constraint ((v1, v2, v3, v4)) ->
      let v1 = vof_module_expr v1
      and v2 = Types.vof_module_type v2
      and v3 = vof_module_type_constraint v3
      and v4 = vof_module_coercion v4
      in Ocaml.VSum (("Tmod_constraint", [ v1; v2; v3; v4 ]))
  | Tmod_unpack ((v1, v2)) ->
      let v1 = vof_expression v1
      and v2 = Types.vof_module_type v2
      in Ocaml.VSum (("Tmod_unpack", [ v1; v2 ]))
and
  vof_structure {
                  str_items = v_str_items;
                  str_type = v_str_type;
                  str_final_env = v_str_final_env
                } =
  let bnds = [] in
  let arg = Env.vof_t v_str_final_env in
  let bnd = ("str_final_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_signature v_str_type in
  let bnd = ("str_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_structure_item v_str_items in
  let bnd = ("str_items", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_structure_item {
                       str_desc = v_str_desc;
                       str_loc = v_str_loc;
                       str_env = v_str_env
                     } =
  let bnds = [] in
  let arg = Env.vof_t v_str_env in
  let bnd = ("str_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Location.vof_t v_str_loc in
  let bnd = ("str_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_structure_item_desc v_str_desc in
  let bnd = ("str_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_structure_item_desc =
  function
  | Tstr_eval v1 ->
      let v1 = vof_expression v1 in Ocaml.VSum (("Tstr_eval", [ v1 ]))
  | Tstr_value ((v1, v2)) ->
      let v1 = vof_rec_flag v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_pattern v1
             and v2 = vof_expression v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      in Ocaml.VSum (("Tstr_value", [ v1; v2 ]))
  | Tstr_primitive ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_value_description v3
      in Ocaml.VSum (("Tstr_primitive", [ v1; v2; v3 ]))
  | Tstr_type v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_type_declaration v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v1
      in Ocaml.VSum (("Tstr_type", [ v1 ]))
  | Tstr_exception ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_exception_declaration v3
      in Ocaml.VSum (("Tstr_exception", [ v1; v2; v3 ]))
  | Tstr_exn_rebind ((v1, v2, v3, v4)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = Path.vof_t v3
      and v4 = vof_loc Longident.vof_t v4
      in Ocaml.VSum (("Tstr_exn_rebind", [ v1; v2; v3; v4 ]))
  | Tstr_module ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_expr v3
      in Ocaml.VSum (("Tstr_module", [ v1; v2; v3 ]))
  | Tstr_recmodule v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3, v4) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_module_type v3
             and v4 = vof_module_expr v4
             in Ocaml.VTuple [ v1; v2; v3; v4 ])
          v1
      in Ocaml.VSum (("Tstr_recmodule", [ v1 ]))
  | Tstr_modtype ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_type v3
      in Ocaml.VSum (("Tstr_modtype", [ v1; v2; v3 ]))
  | Tstr_open ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Tstr_open", [ v1; v2 ]))
  | Tstr_class v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = vof_class_declaration v1
             and v2 = Ocaml.vof_list Ocaml.vof_string v2
             and v3 = vof_virtual_flag v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v1
      in Ocaml.VSum (("Tstr_class", [ v1 ]))
  | Tstr_class_type v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_class_type_declaration v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v1
      in Ocaml.VSum (("Tstr_class_type", [ v1 ]))
  | Tstr_include ((v1, v2)) ->
      let v1 = vof_module_expr v1
      and v2 = Ocaml.vof_list Ident.vof_t v2
      in Ocaml.VSum (("Tstr_include", [ v1; v2 ]))
and vof_module_coercion =
  function
  | Tcoerce_none -> Ocaml.VSum (("Tcoerce_none", []))
  | Tcoerce_structure v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2) ->
             let v1 = Ocaml.vof_int v1
             and v2 = vof_module_coercion v2
             in Ocaml.VTuple [ v1; v2 ])
          v1
      in Ocaml.VSum (("Tcoerce_structure", [ v1 ]))
  | Tcoerce_functor ((v1, v2)) ->
      let v1 = vof_module_coercion v1
      and v2 = vof_module_coercion v2
      in Ocaml.VSum (("Tcoerce_functor", [ v1; v2 ]))
  | Tcoerce_primitive v1 ->
      let v1 = Primitive.vof_description v1
      in Ocaml.VSum (("Tcoerce_primitive", [ v1 ]))
and
  vof_module_type {
                    mty_desc = v_mty_desc;
                    mty_type = v_mty_type;
                    mty_env = v_mty_env;
                    mty_loc = v_mty_loc
                  } =
  let bnds = [] in
  let arg = Location.vof_t v_mty_loc in
  let bnd = ("mty_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Env.vof_t v_mty_env in
  let bnd = ("mty_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_module_type v_mty_type in
  let bnd = ("mty_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_module_type_desc v_mty_desc in
  let bnd = ("mty_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_module_type_desc =
  function
  | Tmty_ident ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Tmty_ident", [ v1; v2 ]))
  | Tmty_signature v1 ->
      let v1 = vof_signature v1 in Ocaml.VSum (("Tmty_signature", [ v1 ]))
  | Tmty_functor ((v1, v2, v3, v4)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_type v3
      and v4 = vof_module_type v4
      in Ocaml.VSum (("Tmty_functor", [ v1; v2; v3; v4 ]))
  | Tmty_with ((v1, v2)) ->
      let v1 = vof_module_type v1
      and v2 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Path.vof_t v1
             and v2 = vof_loc Longident.vof_t v2
             and v3 = vof_with_constraint v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v2
      in Ocaml.VSum (("Tmty_with", [ v1; v2 ]))
  | Tmty_typeof v1 ->
      let v1 = vof_module_expr v1 in Ocaml.VSum (("Tmty_typeof", [ v1 ]))
and
  vof_signature {
                  sig_items = v_sig_items;
                  sig_type = v_sig_type;
                  sig_final_env = v_sig_final_env
                } =
  let bnds = [] in
  let arg = Env.vof_t v_sig_final_env in
  let bnd = ("sig_final_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_signature v_sig_type in
  let bnd = ("sig_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_signature_item v_sig_items in
  let bnd = ("sig_items", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_signature_item {
                       sig_desc = v_sig_desc;
                       sig_env = v_sig_env;
                       sig_loc = v_sig_loc
                     } =
  let bnds = [] in
  let arg = Location.vof_t v_sig_loc in
  let bnd = ("sig_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Env.vof_t v_sig_env in
  let bnd = ("sig_env", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_signature_item_desc v_sig_desc in
  let bnd = ("sig_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_signature_item_desc =
  function
  | Tsig_value ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_value_description v3
      in Ocaml.VSum (("Tsig_value", [ v1; v2; v3 ]))
  | Tsig_type v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_type_declaration v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v1
      in Ocaml.VSum (("Tsig_type", [ v1 ]))
  | Tsig_exception ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_exception_declaration v3
      in Ocaml.VSum (("Tsig_exception", [ v1; v2; v3 ]))
  | Tsig_module ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_module_type v3
      in Ocaml.VSum (("Tsig_module", [ v1; v2; v3 ]))
  | Tsig_recmodule v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_module_type v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v1
      in Ocaml.VSum (("Tsig_recmodule", [ v1 ]))
  | Tsig_modtype ((v1, v2, v3)) ->
      let v1 = Ident.vof_t v1
      and v2 = vof_loc Ocaml.vof_string v2
      and v3 = vof_modtype_declaration v3
      in Ocaml.VSum (("Tsig_modtype", [ v1; v2; v3 ]))
  | Tsig_open ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Tsig_open", [ v1; v2 ]))
  | Tsig_include ((v1, v2)) ->
      let v1 = vof_module_type v1
      and v2 = Types.vof_signature v2
      in Ocaml.VSum (("Tsig_include", [ v1; v2 ]))
  | Tsig_class v1 ->
      let v1 = Ocaml.vof_list vof_class_description v1
      in Ocaml.VSum (("Tsig_class", [ v1 ]))
  | Tsig_class_type v1 ->
      let v1 = Ocaml.vof_list vof_class_type_declaration v1
      in Ocaml.VSum (("Tsig_class_type", [ v1 ]))
and vof_modtype_declaration =
  function
  | Tmodtype_abstract -> Ocaml.VSum (("Tmodtype_abstract", []))
  | Tmodtype_manifest v1 ->
      let v1 = vof_module_type v1
      in Ocaml.VSum (("Tmodtype_manifest", [ v1 ]))
and vof_with_constraint =
  function
  | Twith_type v1 ->
      let v1 = vof_type_declaration v1 in Ocaml.VSum (("Twith_type", [ v1 ]))
  | Twith_module ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Twith_module", [ v1; v2 ]))
  | Twith_typesubst v1 ->
      let v1 = vof_type_declaration v1
      in Ocaml.VSum (("Twith_typesubst", [ v1 ]))
  | Twith_modsubst ((v1, v2)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      in Ocaml.VSum (("Twith_modsubst", [ v1; v2 ]))
and
  vof_core_type {
                  ctyp_desc = v_ctyp_desc;
                  ctyp_type = v_ctyp_type;
                  ctyp_env = v_ctyp_env;
                  ctyp_loc = v_ctyp_loc
                } =
  let bnds = [] in
  let arg = Location.vof_t v_ctyp_loc in
  let bnd = ("ctyp_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Env.vof_t v_ctyp_env in
  let bnd = ("ctyp_env", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_expr v_ctyp_type in
  let bnd = ("ctyp_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_core_type_desc v_ctyp_desc in
  let bnd = ("ctyp_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_core_type_desc =
  function
  | Ttyp_any -> Ocaml.VSum (("Ttyp_any", []))
  | Ttyp_var v1 ->
      let v1 = Ocaml.vof_string v1 in Ocaml.VSum (("Ttyp_var", [ v1 ]))
  | Ttyp_arrow ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = vof_core_type v2
      and v3 = vof_core_type v3
      in Ocaml.VSum (("Ttyp_arrow", [ v1; v2; v3 ]))
  | Ttyp_tuple v1 ->
      let v1 = Ocaml.vof_list vof_core_type v1
      in Ocaml.VSum (("Ttyp_tuple", [ v1 ]))
  | Ttyp_constr ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Ocaml.vof_list vof_core_type v3
      in Ocaml.VSum (("Ttyp_constr", [ v1; v2; v3 ]))
  | Ttyp_object v1 ->
      let v1 = Ocaml.vof_list vof_core_field_type v1
      in Ocaml.VSum (("Ttyp_object", [ v1 ]))
  | Ttyp_class ((v1, v2, v3, v4)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Ocaml.vof_list vof_core_type v3
      and v4 = Ocaml.vof_list vof_label v4
      in Ocaml.VSum (("Ttyp_class", [ v1; v2; v3; v4 ]))
  | Ttyp_alias ((v1, v2)) ->
      let v1 = vof_core_type v1
      and v2 = Ocaml.vof_string v2
      in Ocaml.VSum (("Ttyp_alias", [ v1; v2 ]))
  | Ttyp_variant ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_list vof_row_field v1
      and v2 = Ocaml.vof_bool v2
      and v3 = Ocaml.vof_option (Ocaml.vof_list vof_label) v3
      in Ocaml.VSum (("Ttyp_variant", [ v1; v2; v3 ]))
  | Ttyp_poly ((v1, v2)) ->
      let v1 = Ocaml.vof_list Ocaml.vof_string v1
      and v2 = vof_core_type v2
      in Ocaml.VSum (("Ttyp_poly", [ v1; v2 ]))
  | Ttyp_package v1 ->
      let v1 = vof_package_type v1 in Ocaml.VSum (("Ttyp_package", [ v1 ]))
and
  vof_package_type {
                     pack_name = v_pack_name;
                     pack_fields = v_pack_fields;
                     pack_type = v_pack_type;
                     pack_txt = v_pack_txt
                   } =
  let bnds = [] in
  let arg = vof_loc Longident.vof_t v_pack_txt in
  let bnd = ("pack_txt", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_module_type v_pack_type in
  let bnd = ("pack_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2) ->
         let v1 = vof_loc Longident.vof_t v1
         and v2 = vof_core_type v2
         in Ocaml.VTuple [ v1; v2 ])
      v_pack_fields in
  let bnd = ("pack_fields", arg) in
  let bnds = bnd :: bnds in
  let arg = Path.vof_t v_pack_name in
  let bnd = ("pack_name", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_core_field_type { field_desc = v_field_desc; field_loc = v_field_loc }
                      =
  let bnds = [] in
  let arg = Location.vof_t v_field_loc in
  let bnd = ("field_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_core_field_desc v_field_desc in
  let bnd = ("field_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_core_field_desc =
  function
  | Tcfield ((v1, v2)) ->
      let v1 = Ocaml.vof_string v1
      and v2 = vof_core_type v2
      in Ocaml.VSum (("Tcfield", [ v1; v2 ]))
  | Tcfield_var -> Ocaml.VSum (("Tcfield_var", []))
and vof_row_field =
  function
  | Ttag ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = Ocaml.vof_bool v2
      and v3 = Ocaml.vof_list vof_core_type v3
      in Ocaml.VSum (("Ttag", [ v1; v2; v3 ]))
  | Tinherit v1 ->
      let v1 = vof_core_type v1 in Ocaml.VSum (("Tinherit", [ v1 ]))
and
  vof_value_description {
                          val_desc = v_val_desc;
                          val_val = v_val_val;
                          val_prim = v_val_prim;
                          val_loc = v_val_loc
                        } =
  let bnds = [] in
  let arg = Location.vof_t v_val_loc in
  let bnd = ("val_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list Ocaml.vof_string v_val_prim in
  let bnd = ("val_prim", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_value_description v_val_val in
  let bnd = ("val_val", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_core_type v_val_desc in
  let bnd = ("val_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_type_declaration {
                         typ_params = v_typ_params;
                         typ_type = v_typ_type;
                         typ_cstrs = v_typ_cstrs;
                         typ_kind = v_typ_kind;
                         typ_private = v_typ_private;
                         typ_manifest = v_typ_manifest;
                         typ_variance = v_typ_variance;
                         typ_loc = v_typ_loc
                       } =
  let bnds = [] in
  let arg = Location.vof_t v_typ_loc in
  let bnd = ("typ_loc", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2) ->
         let v1 = Ocaml.vof_bool v1
         and v2 = Ocaml.vof_bool v2
         in Ocaml.VTuple [ v1; v2 ])
      v_typ_variance in
  let bnd = ("typ_variance", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_option vof_core_type v_typ_manifest in
  let bnd = ("typ_manifest", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_private_flag v_typ_private in
  let bnd = ("typ_private", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_kind v_typ_kind in
  let bnd = ("typ_kind", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2, v3) ->
         let v1 = vof_core_type v1
         and v2 = vof_core_type v2
         and v3 = Location.vof_t v3
         in Ocaml.VTuple [ v1; v2; v3 ])
      v_typ_cstrs in
  let bnd = ("typ_cstrs", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_type_declaration v_typ_type in
  let bnd = ("typ_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list (Ocaml.vof_option (vof_loc Ocaml.vof_string)) v_typ_params in
  let bnd = ("typ_params", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_type_kind =
  function
  | Ttype_abstract -> Ocaml.VSum (("Ttype_abstract", []))
  | Ttype_variant v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3, v4) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = Ocaml.vof_list vof_core_type v3
             and v4 = Location.vof_t v4
             in Ocaml.VTuple [ v1; v2; v3; v4 ])
          v1
      in Ocaml.VSum (("Ttype_variant", [ v1 ]))
  | Ttype_record v1 ->
      let v1 =
        Ocaml.vof_list
          (fun (v1, v2, v3, v4, v5) ->
             let v1 = Ident.vof_t v1
             and v2 = vof_loc Ocaml.vof_string v2
             and v3 = vof_mutable_flag v3
             and v4 = vof_core_type v4
             and v5 = Location.vof_t v5
             in Ocaml.VTuple [ v1; v2; v3; v4; v5 ])
          v1
      in Ocaml.VSum (("Ttype_record", [ v1 ]))
and
  vof_exception_declaration {
                              exn_params = v_exn_params;
                              exn_exn = v_exn_exn;
                              exn_loc = v_exn_loc
                            } =
  let bnds = [] in
  let arg = Location.vof_t v_exn_loc in
  let bnd = ("exn_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_exception_declaration v_exn_exn in
  let bnd = ("exn_exn", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_core_type v_exn_params in
  let bnd = ("exn_params", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_class_type {
                   cltyp_desc = v_cltyp_desc;
                   cltyp_type = v_cltyp_type;
                   cltyp_env = v_cltyp_env;
                   cltyp_loc = v_cltyp_loc
                 } =
  let bnds = [] in
  let arg = Location.vof_t v_cltyp_loc in
  let bnd = ("cltyp_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Env.vof_t v_cltyp_env in
  let bnd = ("cltyp_env", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_type v_cltyp_type in
  let bnd = ("cltyp_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_class_type_desc v_cltyp_desc in
  let bnd = ("cltyp_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_type_desc =
  function
  | Tcty_constr ((v1, v2, v3)) ->
      let v1 = Path.vof_t v1
      and v2 = vof_loc Longident.vof_t v2
      and v3 = Ocaml.vof_list vof_core_type v3
      in Ocaml.VSum (("Tcty_constr", [ v1; v2; v3 ]))
  | Tcty_signature v1 ->
      let v1 = vof_class_signature v1
      in Ocaml.VSum (("Tcty_signature", [ v1 ]))
  | Tcty_fun ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = vof_core_type v2
      and v3 = vof_class_type v3
      in Ocaml.VSum (("Tcty_fun", [ v1; v2; v3 ]))
and
  vof_class_signature {
                        csig_self = v_csig_self;
                        csig_fields = v_csig_fields;
                        csig_type = v_csig_type;
                        csig_loc = v_csig_loc
                      } =
  let bnds = [] in
  let arg = Location.vof_t v_csig_loc in
  let bnd = ("csig_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_signature v_csig_type in
  let bnd = ("csig_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_class_type_field v_csig_fields in
  let bnd = ("csig_fields", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_core_type v_csig_self in
  let bnd = ("csig_self", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_type_field { ctf_desc = v_ctf_desc; ctf_loc = v_ctf_loc } =
  let bnds = [] in
  let arg = Location.vof_t v_ctf_loc in
  let bnd = ("ctf_loc", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_class_type_field_desc v_ctf_desc in
  let bnd = ("ctf_desc", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_class_type_field_desc =
  function
  | Tctf_inher v1 ->
      let v1 = vof_class_type v1 in Ocaml.VSum (("Tctf_inher", [ v1 ]))
  | Tctf_val v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3, v4) ->
             let v1 = Ocaml.vof_string v1
             and v2 = vof_mutable_flag v2
             and v3 = vof_virtual_flag v3
             and v4 = vof_core_type v4
             in Ocaml.VTuple [ v1; v2; v3; v4 ])
      in Ocaml.VSum (("Tctf_val", [ v1 ]))
  | Tctf_virt v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = Ocaml.vof_string v1
             and v2 = vof_private_flag v2
             and v3 = vof_core_type v3
             in Ocaml.VTuple [ v1; v2; v3 ])
      in Ocaml.VSum (("Tctf_virt", [ v1 ]))
  | Tctf_meth v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = Ocaml.vof_string v1
             and v2 = vof_private_flag v2
             and v3 = vof_core_type v3
             in Ocaml.VTuple [ v1; v2; v3 ])
      in Ocaml.VSum (("Tctf_meth", [ v1 ]))
  | Tctf_cstr v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_core_type v1
             and v2 = vof_core_type v2
             in Ocaml.VTuple [ v1; v2 ])
      in Ocaml.VSum (("Tctf_cstr", [ v1 ]))
and vof_class_declaration v = vof_class_infos vof_class_expr v
and vof_class_description v = vof_class_infos vof_class_type v
and vof_class_type_declaration v = vof_class_infos vof_class_type v
and
  vof_class_infos: 'a. ('a -> Ocaml.v) -> 'a class_infos -> Ocaml.v
 = fun _of_a x ->
   match x with
                  {
                    ci_virt = v_ci_virt;
                    ci_params = v_ci_params;
                    ci_id_name = v_ci_id_name;
                    ci_id_class = v_ci_id_class;
                    ci_id_class_type = v_ci_id_class_type;
                    ci_id_object = v_ci_id_object;
                    ci_id_typesharp = v_ci_id_typesharp;
                    ci_expr = v_ci_expr;
                    ci_decl = v_ci_decl;
                    ci_type_decl = v_ci_type_decl;
                    ci_variance = v_ci_variance;
                    ci_loc = v_ci_loc
                  } ->
  let bnds = [] in
  let arg = Location.vof_t v_ci_loc in
  let bnd = ("ci_loc", arg) in
  let bnds = bnd :: bnds in
  let arg =
    Ocaml.vof_list
      (fun (v1, v2) ->
         let v1 = Ocaml.vof_bool v1
         and v2 = Ocaml.vof_bool v2
         in Ocaml.VTuple [ v1; v2 ])
      v_ci_variance in
  let bnd = ("ci_variance", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_type_declaration v_ci_type_decl in
  let bnd = ("ci_type_decl", arg) in
  let bnds = bnd :: bnds in
  let arg = Types.vof_class_declaration v_ci_decl in
  let bnd = ("ci_decl", arg) in
  let bnds = bnd :: bnds in
  let arg = _of_a v_ci_expr in
  let bnd = ("ci_expr", arg) in
  let bnds = bnd :: bnds in
  let arg = Ident.vof_t v_ci_id_typesharp in
  let bnd = ("ci_id_typesharp", arg) in
  let bnds = bnd :: bnds in
  let arg = Ident.vof_t v_ci_id_object in
  let bnd = ("ci_id_object", arg) in
  let bnds = bnd :: bnds in
  let arg = Ident.vof_t v_ci_id_class_type in
  let bnd = ("ci_id_class_type", arg) in
  let bnds = bnd :: bnds in
  let arg = Ident.vof_t v_ci_id_class in
  let bnd = ("ci_id_class", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_loc Ocaml.vof_string v_ci_id_name in
  let bnd = ("ci_id_name", arg) in
  let bnds = bnd :: bnds in
  let arg =
    match v_ci_params with
    | (v1, v2) ->
        let v1 = Ocaml.vof_list (vof_loc Ocaml.vof_string) v1
        and v2 = Location.vof_t v2
        in Ocaml.VTuple [ v1; v2 ] in
  let bnd = ("ci_params", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_virtual_flag v_ci_virt in
  let bnd = ("ci_virt", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
  

