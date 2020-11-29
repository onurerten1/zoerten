FUNCTION zoe_json_fm_data_test.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_STRING) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(ET_TAB) TYPE  ZOE_JSON_TT_POKE
*"     REFERENCE(ES_TAB) TYPE  ZOE_JSON_ST_POKE
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA: http_client   TYPE REF TO if_http_client,
        url           TYPE string,
        ls_return     TYPE bapiret2,
        lx_exception  TYPE REF TO cx_root,
        lv_response   TYPE string,
        lv_code       TYPE i,
        lv_err_string TYPE string,
        len           TYPE i,
        strval        TYPE string,
        intval        TYPE i,
        numval        TYPE cats_its_fields-num_value,
        negatif       TYPE xfeld,
        url_json      TYPE ad_uriscr.

  DATA: ls_json TYPE zoe_json_st_poke_tab,
        lt_json TYPE TABLE OF zoe_json_st_poke_tab,
        ls_tab  TYPE zoe_json_st_poke,
        lt_tab  TYPE TABLE OF zoe_json_st_poke.

  CONSTANTS: lc_unit_cm(2) VALUE `CM`,
             lc_unit_g     VALUE `G`.

  FIELD-SYMBOLS: <fs_t_data> TYPE ANY TABLE,
                 <fs_s_data> TYPE any,
                 <fs_val>    TYPE any.

  url_json = `https://pokeapi.co/api/v2/pokemon/`.

  DATA(lv_string) = to_lower( iv_string ).

  url_json = |{ url_json }{ lv_string }/|.

  IF to_upper( url_json(4) ) NE 'HTTP'.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'URL'
                    message_v2 = 'Hatalı URL adresi, HTTP veya HTTPS eksik.'
                    message_v3 = url_json ) TO et_return.
    EXIT.
  ELSE.
    url = url_json.
  ENDIF.

  cl_http_client=>create_by_url( EXPORTING
                                  url                    = url
                                 IMPORTING
                                  client                 = http_client
                                 EXCEPTIONS
                                  argument_not_found     = 1
                                  plugin_not_active      = 2
                                  internal_error         = 3
                                  OTHERS                 = 4 ).

  IF sy-subrc <> 0.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'CREATE_BY_URL'
                    message_v3 = url_json
                    message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'ARGUMENT_NOT_FOUND'
                                                    WHEN '2' THEN 'PLUGIN_NOT_ACTIVE'
                                                    WHEN '3' THEN 'INTERNAL_ERROR'
                                                    WHEN '4' THEN 'HTTP ERROR' ) ) TO et_return.
  ELSE.
    http_client->request->set_method( if_http_request=>co_request_method_get ).
  ENDIF.

  CHECK http_client IS NOT INITIAL.
  http_client->propertytype_logon_popup = if_http_client=>co_disabled.
  http_client->send( EXCEPTIONS http_communication_failure = 1
                                http_invalid_state         = 2
                                http_processing_failed     = 3
                                http_invalid_timeout       = 4
                                OTHERS                     = 5 ).

  IF sy-subrc <> 0.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'SEND'
                    message_v3 = url_json
                    message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'HTTP_COMMUNICATION_FAILURE'
                                                    WHEN '2' THEN 'HTTP_INVALID_STATE'
                                                    WHEN '3' THEN 'HTTP_PROCESSING_FAILED'
                                                    WHEN '4' THEN 'HTTP_INVALID_TIMEOUT'
                                                    WHEN '5' THEN 'HTTP ERROR' ) ) TO et_return.
  ENDIF.

  TRY.
      http_client->receive( EXCEPTIONS
                              http_communication_failure = 1
                              http_invalid_state         = 2
                              http_processing_failed     = 3
                              OTHERS                     = 4 ).
      IF sy-subrc <> 0.
        APPEND VALUE #( type = 'E'
                        message_v1 = 'RECEIVE'
                        message_v3 = url_json
                        message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'HTTP_COMMUNICATION_FAILURE'
                                                        WHEN '2' THEN 'HTTP_INVALID_STATE'
                                                        WHEN '3' THEN 'HTTP_PROCESSING_FAILED'
                                                        WHEN '4' THEN 'HTTP ERROR' ) ) TO et_return.
      ENDIF.

      "200 başarılı, 404 bulunamadı, 500 server hatası
      http_client->response->get_status( IMPORTING
                                            code = lv_code
                                            reason = lv_err_string ).
    CATCH cx_root INTO lx_exception.
      lv_err_string = lx_exception->get_text( ).
      APPEND VALUE #( type = 'E'
                      message_v1 = 'CX_ROOT'
                      message_v2 = lv_err_string ) TO et_return.
  ENDTRY.

  IF lv_code NE '200'.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'HTTP STATUS ERROR'
                    message_v3 = url_json
                    message_v2 = |HTTP ERROR: { lv_code }| ) TO et_return.
  ENDIF.

  CHECK lv_code EQ '200'. " 200 başarılı

  lv_response = http_client->response->get_cdata( ).

  DATA(ref) = zcl_json_data=>convert( json = lv_response ).

  ASSIGN ref->* TO <fs_s_data>.

  IF <fs_s_data> IS ASSIGNED.
    ls_json = CORRESPONDING #( <fs_s_data> ).
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
  ls_tab-name(1) = to_upper( ls_tab-name(1) ).

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
  ls_tab-meins_height = lc_unit_cm.

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
  ls_tab-meins_weight = lc_unit_g.

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

  ASSIGN COMPONENT 'GAME_INDICES' OF STRUCTURE <fs_s_data> TO FIELD-SYMBOL(<fs_game_indices>).
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

  ASSIGN COMPONENT 'HELD_ITEMS' OF STRUCTURE <fs_s_data> TO FIELD-SYMBOL(<fs_held_items>).
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

        DATA(ls_version_detail) = VALUE zoe_poke_st_ver_det( rarity = lv_rarity
                                                             version = CORRESPONDING zoe_poke_st_version( ls_version_details-version ) ).

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
                                              effort = lv_effort
                                              stat = CORRESPONDING zoe_poke_st_stat( ls_json_stats-stat ) ).

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

  es_tab = CORRESPONDING #( ls_tab ).

  APPEND es_tab TO et_tab.

ENDFUNCTION.
