*----------------------------------------------------------------------*
***INCLUDE ZOE_JSON_DATA_TEST01_F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_MAIN_MODEL_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_URL
*&---------------------------------------------------------------------*
FORM get_main_model_data USING p_url.

  DATA: lv_response TYPE string,
        intval      TYPE i.

  DATA: ls_json TYPE zoe_json_st_poke_tab,
        lt_json TYPE TABLE OF zoe_json_st_poke_tab,
        ls_tab  TYPE zoe_json_st_poke,
        lt_tab  TYPE TABLE OF zoe_json_st_poke.

  CLEAR: gs_data.

  CALL FUNCTION 'ZOE_JSON_FM_DATA_02'
    EXPORTING
      iv_url      = p_url
    IMPORTING
      ev_response = lv_response
      et_return   = gt_return.

  IF gt_return IS INITIAL.

    DATA(ref) = zcl_json_data=>convert( json = lv_response ).
    ASSIGN ref->* TO FIELD-SYMBOL(<fs_data>).

    IF <fs_data> IS ASSIGNED.
      ls_json = CORRESPONDING #( <fs_data> ).
    ENDIF.

    CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
      EXPORTING
        p_string      = ls_json-id
      IMPORTING
        p_int         = ls_tab-id
      EXCEPTIONS
        overflow      = 1
        invalid_chars = 2
        OTHERS        = 3.

    ls_tab-name = ls_json-name.

    CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
      EXPORTING
        p_string      = ls_json-base_experience
      IMPORTING
        p_int         = ls_tab-base_experience
      EXCEPTIONS
        overflow      = 1
        invalid_chars = 2
        OTHERS        = 3.

    CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
      EXPORTING
        p_string      = ls_json-height
      IMPORTING
        p_int         = intval
      EXCEPTIONS
        overflow      = 1
        invalid_chars = 2
        OTHERS        = 3.

    ls_tab-height = 10 * intval.
    ls_tab-meins_height = gc_unit_cm.

    ls_tab-is_default = ls_json-is_default.

    CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
      EXPORTING
        p_string      = ls_json-order
      IMPORTING
        p_int         = intval
      EXCEPTIONS
        overflow      = 1
        invalid_chars = 2
        OTHERS        = 3.

    ls_tab-order = intval.

    CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
      EXPORTING
        p_string      = ls_json-weight
      IMPORTING
        p_int         = intval
      EXCEPTIONS
        overflow      = 1
        invalid_chars = 2
        OTHERS        = 3.

    ls_tab-weight = 100 * intval.
    ls_tab-meins_weight = gc_unit_g.

    LOOP AT ls_json-abilities INTO DATA(ls_json_abilities).
      CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
        EXPORTING
          p_string      = ls_json_abilities-slot
        IMPORTING
          p_int         = intval
        EXCEPTIONS
          overflow      = 1
          invalid_chars = 2
          OTHERS        = 3.

      DATA(ls_abilities) = VALUE zoe_poke_st_abilities( ability = CORRESPONDING zoe_poke_st_ability( ls_json_abilities-ability )
                                                        slot    = intval ).
      APPEND ls_abilities TO ls_tab-abilities.
    ENDLOOP.

    LOOP AT ls_json-forms INTO DATA(ls_json_forms).
      DATA(ls_forms) = CORRESPONDING zoe_poke_st_forms( ls_json_forms ).
      APPEND ls_forms TO ls_tab-forms.
    ENDLOOP.

    ASSIGN COMPONENT 'GAME_INDICES' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_game_indices>).
    IF <fs_game_indices> IS ASSIGNED AND <fs_game_indices> IS  NOT INITIAL.
      DATA(lt_json_game_indices) = CORRESPONDING zoe_poke_tt_game_ind( <fs_game_indices> ).

      LOOP AT lt_json_game_indices INTO DATA(ls_json_game_indices).
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = ls_json_game_indices-game_index
          IMPORTING
            p_int         = intval
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        DATA(ls_game_indices) = VALUE zoe_poke_st_game_ind( game_index  = intval
                                                            version     = CORRESPONDING zoe_poke_st_version( ls_json_game_indices-version ) ).
        APPEND ls_game_indices TO ls_tab-game_indices.
      ENDLOOP.

    ENDIF.

    ASSIGN COMPONENT 'HELD_ITEMS' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_held_items>).
    IF <fs_held_items> IS ASSIGNED AND <fs_held_items> IS NOT INITIAL.
      DATA(lt_json_held_items) = CORRESPONDING zoe_poke_tt_held_items_tab( <fs_held_items> ).

      LOOP AT lt_json_held_items INTO DATA(ls_json_held_items).
        DATA(ls_held_items) = VALUE zoe_poke_st_held_items( item = CORRESPONDING zoe_poke_st_item( ls_json_held_items-item ) ).

        LOOP AT ls_json_held_items-version_details INTO DATA(ls_version_details).
          CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
            EXPORTING
              p_string      = ls_version_details-rarity
            IMPORTING
              p_int         = intval
            EXCEPTIONS
              overflow      = 1
              invalid_chars = 2
              OTHERS        = 3.

          DATA(lv_rarity) = intval.
          DATA(ls_version_detail) = VALUE zoe_poke_st_ver_det( rarity   = lv_rarity
                                                               version  = CORRESPONDING zoe_poke_st_version( ls_version_details-version ) ).
          APPEND ls_version_detail TO ls_held_items-version_details.
        ENDLOOP.

        APPEND ls_held_items TO ls_tab-held_items.
      ENDLOOP.
    ENDIF.

    ls_tab-location_area_encounters = ls_json-location_area_encounters.

    LOOP AT ls_json-moves INTO DATA(ls_json_moves).
      DATA(ls_moves) = VALUE zoe_poke_st_moves( move = CORRESPONDING zoe_poke_st_move( ls_json_moves-move ) ).

      LOOP AT ls_json_moves-version_group_details INTO DATA(ls_json_vgd).
        CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
          EXPORTING
            p_string      = ls_json_vgd-level_learned_at
          IMPORTING
            p_int         = intval
          EXCEPTIONS
            overflow      = 1
            invalid_chars = 2
            OTHERS        = 3.

        DATA(ls_vgd) = VALUE zoe_poke_st_vgd( level_learned_at  = intval
                                              move_learn_method = CORRESPONDING zoe_poke_st_mlm( ls_json_vgd-move_learn_method )
                                              version_group     = CORRESPONDING zoe_poke_st_vg( ls_json_vgd-version_group ) ).
        APPEND ls_vgd TO ls_moves-version_group_details.
      ENDLOOP.

      APPEND ls_moves TO ls_tab-moves.
    ENDLOOP.

    ls_tab-species = CORRESPONDING zoe_poke_st_species( ls_json-species ).

    ls_tab-sprites = CORRESPONDING zoe_poke_st_sprites( ls_json-sprites ).

    LOOP AT ls_json-stats INTO DATA(ls_json_stats).
      CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
        EXPORTING
          p_string      = ls_json_stats-base_stat
        IMPORTING
          p_int         = intval
        EXCEPTIONS
          overflow      = 1
          invalid_chars = 2
          OTHERS        = 3.

      DATA(lv_base_stat) = intval.

      CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
        EXPORTING
          p_string      = ls_json_stats-effort
        IMPORTING
          p_int         = intval
        EXCEPTIONS
          overflow      = 1
          invalid_chars = 2
          OTHERS        = 3.

      DATA(lv_effort) = intval.
      DATA(ls_stats) = VALUE zoe_poke_st_stats( base_stat = lv_base_stat
                                                effort    = lv_effort
                                                stat      = CORRESPONDING zoe_poke_st_stat( ls_json_stats-stat ) ).
      APPEND ls_stats TO ls_tab-stats.
    ENDLOOP.

    LOOP AT ls_json-types INTO DATA(ls_json_types).
      CALL FUNCTION 'CONVERT_STRING_TO_INTEGER'
        EXPORTING
          p_string      = ls_json_types-slot
        IMPORTING
          p_int         = intval
        EXCEPTIONS
          overflow      = 1
          invalid_chars = 2
          OTHERS        = 3.

      DATA(lv_slot) = intval.
      DATA(ls_types) = VALUE zoe_poke_st_types( slot = lv_slot
                                                type = CORRESPONDING zoe_poke_st_type( ls_json_types-type ) ).
      APPEND ls_types TO ls_tab-types.
    ENDLOOP.

    gs_tab = CORRESPONDING #( ls_tab ).
    APPEND gs_tab TO gt_tab.

*    LOOP AT gt_tab INTO gs_tab.
*      CLEAR: gs_data.
    gs_data = VALUE #( id                        = gs_tab-id
                       name                      = gs_tab-name
                       base_experience           = gs_tab-base_experience
                       height                    = gs_tab-height
                       meins_height              = gs_tab-meins_height
                       is_default                = gs_tab-is_default
                       order                     = gs_tab-order
                       weight                    = gs_tab-weight
                       meins_weight              = gs_tab-meins_weight
                       abilities                 = gc_icon_table
                       forms                     = gc_icon_table
                       game_indices              = gc_icon_table
                       held_items                = gc_icon_table
                       location_area_encounters  = gc_icon_url
                       moves                     = gc_icon_table
                       species                   = VALUE #( name  = gs_tab-species-name
                                                            url   = gc_icon_url )
                       sprites                   = VALUE #( back_female         = gc_icon_jpg
                                                            back_shiny_female   = gc_icon_jpg
                                                            back_default        = gc_icon_jpg
                                                            front_female        = gc_icon_jpg
                                                            front_shiny_female  = gc_icon_jpg
                                                            back_shiny          = gc_icon_jpg
                                                            front_default       = gc_icon_jpg
                                                            front_shiny         = gc_icon_jpg )
                       stats                     = gc_icon_table
                       types                     = gc_icon_table ).
    APPEND gs_data TO gt_data.
*      CLEAR: gs_data.
*    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_ANY_MODEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_URL
*&      --> P_
*&---------------------------------------------------------------------*
FORM get_any_model USING p_url  TYPE url.

  DATA: lt_return TYPE bapiret2_t,
        lv_column TYPE lvc_fname,
        lv_text1  TYPE scrtext_l,
        lv_text2  TYPE scrtext_m,
        lv_text3  TYPE scrtext_s.

  DATA: lo_struct  TYPE REF TO cl_abap_structdescr,
        lo_dyn_str TYPE REF TO cl_abap_structdescr,
        lo_dyn_tab TYPE REF TO cl_abap_tabledescr,
        lo_table   TYPE REF TO cl_abap_tabledescr,
        ls_dynamic TYPE abap_componentdescr,
        lt_dynamic TYPE abap_component_tab,
        lo_column  TYPE REF TO cl_salv_column_table.

  DATA: data_tab TYPE REF TO data,
        data_str TYPE REF TO data.

  FIELD-SYMBOLS: <fs_tab> TYPE INDEX TABLE,
                 <fs_str> TYPE any,
                 <fs_ind> TYPE INDEX TABLE.

  CALL FUNCTION `ZOE_JSON_FM_DATA_02`
    EXPORTING
      iv_url      = p_url
    IMPORTING
      ev_response = gv_any_model_response
      et_return   = lt_return.

  IF gv_any_model_response = `[]`
  OR gv_any_model_response = `{}`.
    MESSAGE TEXT-067 TYPE `S` DISPLAY LIKE `E`.
    RETURN.
  ENDIF.

  IF lt_return IS INITIAL.

    DATA(ref) = zcl_json_data=>convert( json = gv_any_model_response ).
    ASSIGN ref->* TO FIELD-SYMBOL(<fs_data>).

    IF gv_any_model_response(1) = `[`.
      lo_table ?= cl_abap_tabledescr=>describe_by_data_ref( ref ).
      lo_struct ?= lo_table->get_table_line_type( ).
    ELSEIF gv_any_model_response(1) = `{`.
      lo_struct ?= cl_abap_structdescr=>describe_by_data_ref( ref ).
    ENDIF.


    IF <fs_data> IS ASSIGNED.

      DATA(lt_comp) = lo_struct->components.
      DELETE lt_comp WHERE type_kind = cl_abap_typedescr=>typekind_table
                     OR    type_kind = cl_abap_typedescr=>typekind_struct2.

      LOOP AT lt_comp INTO DATA(ls_comp).
        ls_dynamic = VALUE #( name = ls_comp-name ).
        ls_dynamic-type ?= cl_abap_elemdescr=>describe_by_name( `CSTRING` ).
        APPEND ls_dynamic TO lt_dynamic.
      ENDLOOP.

      ls_dynamic-name = `JSON`.
      ls_dynamic-type ?= cl_abap_elemdescr=>describe_by_name( `ICON_D` ).
      APPEND ls_dynamic TO lt_dynamic.

      IF lines( lt_dynamic ) - 1  <> 0.
        lo_dyn_str = cl_abap_structdescr=>create( p_components = lt_dynamic ).

        lo_dyn_tab = cl_abap_tabledescr=>create( lo_dyn_str ).

        CREATE DATA data_str TYPE HANDLE lo_dyn_str.
        CREATE DATA data_tab TYPE HANDLE lo_dyn_tab.

        ASSIGN: data_tab->* TO <fs_tab>,
                data_str->* TO <fs_str>.

      ELSE.
        PERFORM show_model_json.
      ENDIF.

      IF <fs_tab> IS ASSIGNED AND <fs_str> IS ASSIGNED.
        <fs_str> = CORRESPONDING #( <fs_data> ).
        ASSIGN COMPONENT `JSON` OF STRUCTURE <fs_str> TO FIELD-SYMBOL(<fs_icon>).
        IF <fs_icon> IS ASSIGNED.
          <fs_icon> = `@TD@`.
        ENDIF.
        APPEND <fs_str> TO <fs_tab>.


        TRY.
            cl_salv_table=>factory(
              IMPORTING
                r_salv_table = DATA(lo_salv)
              CHANGING
                t_table      = <fs_tab> ).
          CATCH cx_salv_msg.
        ENDTRY.

        DATA(lo_columns) = lo_salv->get_columns( ).

        LOOP AT lt_dynamic INTO ls_dynamic.
          lv_column = ls_dynamic-name.
          TRY.
              lo_column ?= lo_columns->get_column( lv_column ).
            CATCH cx_salv_not_found.
          ENDTRY.
          lv_text1 = to_lower( lv_column ).
          REPLACE ALL OCCURRENCES OF `_` IN lv_text1 WITH ` `.
          lv_text2 = lv_text3 = lv_text1.
          IF lv_column = `JSON`.
            lo_column->set_alignment( if_salv_c_alignment=>centered ).
            lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
          ENDIF.
          lo_column->set_long_text( lv_text1 ).
          lo_column->set_medium_text( lv_text2  ).
          lo_column->set_short_text( lv_text3 ).
          lo_column->set_tooltip( lv_text1 ).
        ENDLOOP.

        lo_salv->get_functions( )->set_all( abap_true ).

        DATA(lo_handle) = NEW lcl_handle_events( ).
        DATA(lo_events) = lo_salv->get_event( ).
        SET HANDLER lo_handle->on_link_click FOR lo_events.

        lo_salv->set_screen_popup( start_column = 1
                                   end_column   = 100
                                   start_line   = 1
                                   end_line     = 20 ).

        lo_salv->display( ).

      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.
