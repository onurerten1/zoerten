*&---------------------------------------------------------------------*
*& Include          ZOE_JSON_DATA_TEST01_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  DATA: lv_url TYPE url.

  CLEAR: gs_data,
         gt_data[],
         gt_return[].

  IF p_single = abap_true AND p_string IS NOT INITIAL.
    lv_url = |https://pokeapi.co/api/v2/pokemon/{ p_string }/|.
    PERFORM get_main_model_data USING lv_url.
  ELSEIF p_multi = abap_true AND s_text[] IS NOT INITIAL.
    LOOP AT s_text INTO DATA(ls_text).
      lv_url = |https://pokeapi.co/api/v2/pokemon/{ ls_text-low }/|.
      PERFORM get_main_model_data USING lv_url.
    ENDLOOP.
  ENDIF.

  CASE abap_true.
    WHEN p_gen1.
      DO gc_gen1 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen2.
      DO gc_gen2 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen3.
      DO gc_gen3 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 + gc_gen2 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen4.
      DO gc_gen4 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 + gc_gen2 + gc_gen3 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen5.
      DO gc_gen5 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 + gc_gen2 + gc_gen3 + gc_gen4 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen6.
      DO gc_gen6 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 + gc_gen2 + gc_gen3 + gc_gen4 + gc_gen5 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_gen7.
      DO gc_gen7 TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + gc_gen1 + gc_gen2 + gc_gen3 + gc_gen4 + gc_gen5 + gc_gen6 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN p_alt.
      DO gc_alt TIMES.
        lv_url = |https://pokeapi.co/api/v2/pokemon/{ sy-index + 10000 }/|.
        PERFORM get_main_model_data USING lv_url.
      ENDDO.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_0100.

  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.

  PERFORM create_splitter.

  PERFORM create_alv USING gv_position
                           gv_table.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXIT_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exit_command.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SPLITTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_splitter.

  IF go_container_top IS NOT BOUND.
    go_container_top = NEW #( 'CONTAINER_TOP' ).
  ENDIF.

  IF go_container_bottom IS NOT BOUND.
    go_container_bottom = NEW #( 'CONTAINER_BOTTOM' ).
  ENDIF.

  IF go_splitter IS NOT BOUND.
    go_splitter = NEW #( parent  = go_container_bottom
                         rows    = 1
                         columns = 3 ).
  ENDIF.

  IF go_container_left IS NOT BOUND.
    go_container_left = go_splitter->get_container( row    = 1
                                                    column = 1 ).
  ENDIF.

  IF go_container_middle IS NOT BOUND.
    go_container_middle = go_splitter->get_container( row     = 1
                                                      column  = 2 ).
  ENDIF.

  IF go_container_right IS NOT BOUND.
    go_container_right = go_splitter->get_container( row    = 1
                                                     column = 3 ).
  ENDIF.

  IF go_picture_viewer IS NOT BOUND.
    go_picture_viewer = NEW #( go_container_right ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM create_alv USING p_position
                      p_table.

  DATA: lo_columns   TYPE REF TO cl_salv_columns,
        lo_functions TYPE REF TO cl_salv_functions_list,
        lv_header    TYPE lvc_title.

  FIELD-SYMBOLS: <fs_otable> TYPE REF TO cl_salv_table,
                 <fs_events> TYPE REF TO lcl_handle_events.

  DATA(lv_position) = |GO_CONTAINER{ p_position }|.
  ASSIGN (lv_position) TO FIELD-SYMBOL(<fs_container>).

  DATA(lv_otable) = |GO_TABLE{ p_position }|.
  ASSIGN (lv_otable) TO <fs_otable>.

  DATA(lv_events) = |GO_EVENTS{ p_position }|.
  ASSIGN (lv_events) TO <fs_events>.

  DATA(lv_table) = |GT_DATA{ p_table }|.
  ASSIGN (lv_table) TO FIELD-SYMBOL(<fs_table>).

  IF <fs_container> IS ASSIGNED AND <fs_table> IS ASSIGNED AND <fs_otable> IS ASSIGNED.

    TRY.
        IF <fs_otable> IS NOT BOUND.
          cl_salv_table=>factory(
                             EXPORTING
                               r_container     = <fs_container>
                               container_name  = lv_position
                             IMPORTING
                               r_salv_table    = <fs_otable>
                             CHANGING
                               t_table         = <fs_table> ).
        ELSE.
          TRY.
              <fs_otable>->set_data(
                               CHANGING
                                 t_table = <fs_table> ).
            CATCH cx_salv_no_new_data_allowed.
          ENDTRY.
        ENDIF.


        <fs_otable>->get_display_settings( )->set_striped_pattern( abap_true ).

        DATA(lo_selections) = <fs_otable>->get_selections( ).
        lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

        lo_columns = <fs_otable>->get_columns( ).
        lo_columns->set_optimize( abap_true ).

        CASE p_table.
          WHEN ''.
            PERFORM change_column USING lo_columns:
            "FIELD                        TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'ID'                          ' '   ' '   ' '   ' '   'X' ' '   ' '   ' '   TEXT-001  TEXT-001,
            'NAME'                        ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-002  TEXT-002,
            'BASE_EXPERIENCE'             ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-003  TEXT-004,
            'HEIGHT'                      ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-005  TEXT-005,
            'MEINS_HEIGHT'                ' '   ' '   ' '   ' '   ' ' ' '   'X'   ' '   ' '       ' ' ,
            'IS_DEFAULT'                  ' '   ' '   ' '   'X'   ' ' ' '   ' '   ' '   TEXT-006  TEXT-006,
            'ORDER'                       ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-007  TEXT-007,
            'WEIGHT'                      ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-008  TEXT-008,
            'MEINS_WEIGHT'                ' '   ' '   ' '   ' '   ' ' ' '   'X'   ' '   ' '       ' ',
            'ABILITIES'                   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-009  TEXT-009,
            'FORMS'                       ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-010  TEXT-010,
            'GAME_INDICES'                ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-011  TEXT-012,
            'HELD_ITEMS'                  ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-013  TEXT-014,
            'LOCATION_AREA_ENCOUNTERS'    ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-015  TEXT-016,
            'MOVES'                       ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-017  TEXT-017,
            'SPECIES-NAME'                ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-018  TEXT-018,
            'SPECIES-URL'                 ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019,
            'SPRITES-BACK_FEMALE'         ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-020  TEXT-021,
            'SPRITES-BACK_SHINY_FEMALE'   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-022  TEXT-023,
            'SPRITES-BACK_DEFAULT'        ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-024  TEXT-025,
            'SPRITES-FRONT_FEMALE'        ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-026  TEXT-027,
            'SPRITES-FRONT_SHINY_FEMALE'  ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-028  TEXT-029,
            'SPRITES-BACK_SHINY'          ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-030  TEXT-031,
            'SPRITES-FRONT_DEFAULT'       ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-032  TEXT-033,
            'SPRITES-FRONT_SHINY'         ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-034  TEXT-035,
            'STATS'                       ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-036  TEXT-036,
            'TYPES'                       ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-037  TEXT-037.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              DATA(lo_events_top) = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_top.
              SET HANDLER <fs_events>->on_user_command FOR lo_events_top.
            ENDIF.

            lo_functions = <fs_otable>->get_functions( ).
            lo_functions->set_all( abap_true ).

            PERFORM add_function USING lo_functions:
            "NAME   ICON    TEXT      TOOLTIP   POSITION(R/L)
            'ZXML'  '@R4@'  TEXT-061  TEXT-062  'R',
            'PXML'  '@0P@'  TEXT-065  TEXT-066  'R'.

            DATA(lo_layout) = <fs_otable>->get_layout( ).
            DATA(ls_layout_key) = VALUE salv_s_layout_key( report = sy-repid ).
            lo_layout->set_key( ls_layout_key ).
            lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).


          WHEN '_ABILITIES'.
            PERFORM change_column USING lo_columns:
            "FIELD          TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'          'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'ABILITY-NAME'  ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-038  TEXT-038,
            'ABILITY-URL'   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019,
            'IS_HIDDEN'     ' '   ' '   ' '   'X'   ' ' ' '   ' '   ' '   TEXT-039  TEXT-039,
            'SLOT'          ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-040  TEXT-040.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              DATA(lo_events_left) = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_left.
            ENDIF.

            lv_header = |{ TEXT-009 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_FORMS'.
            PERFORM change_column USING lo_columns:
            "FIELD  TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'  'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'NAME'  ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-041  TEXT-041,
            'URL'   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_left.
            ENDIF.

            lv_header = |{ TEXT-010 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_GAME_INDICES'.
            PERFORM change_column USING lo_columns:
            "FIELD            TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'            'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'GAME_INDEX'      ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-042  TEXT-042,
            'VERSION_G-NAME'  ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-043  TEXT-043,
            'VERSION_G-URL'   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_left.
            ENDIF.

            lv_header = |{ TEXT-011 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_HELD_ITEMS'.
            PERFORM change_column USING lo_columns:
            "FIELD            TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'            'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'ITEM-NAME'       ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-044  TEXT-044,
            'ITEM-URL'        ' '   ' '   'X'   ' '   ' ' ' '   ' '   ' '   TEXT-019  TEXT-019,
            'VERSION_DETAILS' ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-045  TEXT-046.

            lv_header = |{ TEXT-013 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_left.
            ENDIF.

          WHEN '_VERSION_DETAILS'.
            PERFORM change_column USING lo_columns:
            "FIELD          TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'          'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'RARITY'        ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-047  TEXT-047,
            'VERSION_H-NAME'  ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-043  TEXT-043,
            'VERSION_H-URL'   ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              DATA(lo_events_middle) = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_middle.
            ENDIF.

            lv_header = |{ TEXT-045 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_MOVES'.
            PERFORM change_column USING lo_columns:
            "FIELD                  TECH INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'                  'X'  ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'MOVE-NAME'             ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-048  TEXT-048,
            'MOVE-URL'              ' '  ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019,
            'VERSION_GROUP_DETAILS' ' '  ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-049  TEXT-050.

            lv_header = |{ TEXT-017 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_left.
            ENDIF.

          WHEN '_VERSION_GROUP_DETAILS'.
            PERFORM change_column USING lo_columns:
            "FIELD                    TECH INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'                    'X'  ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'URL3'                    'X'  ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'LEVEL_LEARNED_AT'        ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-051  TEXT-052,
            'MOVE_LEARN_METHOD-NAME'  ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-053  TEXT-054,
            'MOVE_LEARN_METHOD-URL'   ' '  ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019,
            'VERSION_GROUP-NAME'      ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-055  TEXT-056,
            'VERSION_GROUP-URL'       ' '  ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_middle = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_middle.
            ENDIF.

            lv_header = |{ TEXT-049 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_STATS'.
            PERFORM change_column USING lo_columns:
            "FIELD      TECH INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'      'X'  ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'BASE_STAT' ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-057  TEXT-057,
            'EFFORT'    ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-058  TEXT-058,
            'STAT-NAME' ' '  ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-059  TEXT-059,
            'STAT-URL'  ' '  ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_middle.
            ENDIF.

            lv_header = |{ TEXT-036 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN '_TYPES'.
            PERFORM change_column USING lo_columns:
            "FIELD      TECH  INVS  HOTS  CHBX  KEY CURR  QUAN  ALGN  L-M Text  S Text
            'URL2'      'X'   ' '   ' '   ' '   ' ' ' '   ' '   ' '   ' '       ' ',
            'SLOT'      ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-040  TEXT-040,
            'TYPE-NAME' ' '   ' '   ' '   ' '   ' ' ' '   ' '   ' '   TEXT-060  TEXT-060,
            'TYPE-URL'  ' '   ' '   'X'   ' '   ' ' ' '   ' '   'X'   TEXT-019  TEXT-019.

            IF <fs_events> IS NOT BOUND.
              <fs_events> = NEW #(  ).
              lo_events_left = <fs_otable>->get_event( ).
              SET HANDLER <fs_events>->on_link_click FOR lo_events_middle.
            ENDIF.

            lv_header = |{ TEXT-037 } ({ gv_name })|.
            <fs_otable>->get_display_settings( )->set_list_header( lv_header ).

          WHEN OTHERS.
        ENDCASE.

        <fs_otable>->display( ).
      CATCH cx_salv_msg INTO DATA(lx_msg).
    ENDTRY.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_COLUMN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LO_COLUMNS
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> TEXT_001
*&      --> TEXT_001
*&---------------------------------------------------------------------*
FORM change_column  USING po_columns TYPE REF TO cl_salv_columns
                          pv_fieldname    TYPE c
                          pv_technical    TYPE c
                          pv_invisible    TYPE c
                          pv_hotspot      TYPE c
                          pv_checkbox     TYPE c
                          pv_key          TYPE c
                          pv_currref      TYPE c
                          pv_quanref      TYPE c
                          pv_align        TYPE c
                          pv_fieldtextlm  TYPE c
                          pv_fieldtexts   TYPE c.

  DATA: lo_column TYPE REF TO cl_salv_column_table,
        lv_short  TYPE scrtext_s,
        lv_medium TYPE scrtext_m,
        lv_long   TYPE scrtext_l.

  TRY.
      lo_column ?= po_columns->get_column( pv_fieldname ).
      IF pv_technical IS NOT INITIAL.
        lo_column->set_technical( abap_true ).
      ENDIF.
      IF pv_invisible IS NOT INITIAL.
        lo_column->set_visible( abap_false ).
        RETURN.
      ENDIF.
      IF pv_key IS NOT INITIAL.
        lo_column->set_key( value = if_salv_c_bool_sap=>true ).
      ENDIF.
      IF pv_hotspot IS NOT INITIAL.
        lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
      ENDIF.
      IF pv_currref IS NOT INITIAL.
        lo_column->set_currency_column( pv_currref ).
      ELSEIF pv_quanref IS NOT INITIAL.
        lo_column->set_quantity_column( pv_quanref ).
      ENDIF.
      IF pv_fieldtextlm IS NOT INITIAL.
        lv_medium = lv_long = pv_fieldtextlm.
        lo_column->set_medium_text( lv_medium ).
        lo_column->set_long_text( lv_long ).
      ENDIF.
      IF pv_fieldtexts IS NOT INITIAL.
        lv_short = pv_fieldtexts.
        lo_column->set_short_text( lv_short ).
      ENDIF.
      IF pv_checkbox IS NOT INITIAL.
        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
      ENDIF.
      IF pv_align IS NOT INITIAL.
        lo_column->set_alignment( value = if_salv_c_alignment=>centered ).
      ENDIF.
    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_LINK_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_link_click  USING p_row
                              p_column.

  DATA: lv_url TYPE url,
        lv_col TYPE string.

  IF p_column CS 'SPRITES'.
    DATA(lv_sprite) = substring_after( val = p_column
                                       sub = '-' ).

    p_column = substring_before( val = p_column
                                 sub = '-' ).
  ENDIF.

  IF p_column CS 'URL'.
    IF p_column = 'URL'.
      lv_col = 'FORM'.
    ELSE.
      lv_col = substring_before( val = p_column
                         sub = '-' ).

      p_column = substring_after( val = p_column
                                  sub = '-' ).
    ENDIF.
  ENDIF.

  CASE p_column.
    WHEN 'ABILITIES'.
      PERFORM get_abilities USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'FORMS'.
      PERFORM get_forms USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'GAME_INDICES'.
      PERFORM get_game_indices USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'HELD_ITEMS'.
      PERFORM get_held_items USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'VERSION_DETAILS'.
      PERFORM get_version_details USING p_row.
      go_table_left->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'MOVES'.
      PERFORM get_moves USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'VERSION_GROUP_DETAILS'.
      PERFORM get_version_group_details USING p_row.
      go_table_left->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'STATS'.
      PERFORM get_stats USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'TYPES'.
      PERFORM get_types USING p_row.
      go_table_top->refresh( ).
      cl_gui_cfw=>set_new_ok_code( 'XXXX' ).
    WHEN 'SPRITES'.
      PERFORM get_sprites USING p_row
                                lv_sprite.
      go_table_top->refresh( ).
    WHEN 'URL'.
      PERFORM get_url USING p_row
                            lv_col.
    WHEN 'LOCATION_AREA_ENCOUNTERS'.
      TRY.
          lv_url = gt_tab[ p_row ]-location_area_encounters.
        CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
      PERFORM get_any_model USING lv_url.
      go_table_top->refresh( ).
    WHEN 'JSON'.
      PERFORM show_model_json.
    WHEN OTHERS.
  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_ABILITIES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
FORM get_abilities USING p_row.

  CLEAR: gs_data_abilities,
       gt_data_abilities.

  TRY.
      DATA(lt_abilities) = gt_tab[ p_row ]-abilities.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_abilities INTO DATA(ls_abilities).
    gs_data_abilities = VALUE #( ability    = VALUE #( name  = ls_abilities-ability-name
                                                       url   = gc_icon_url )
                                 is_hidden  = ls_abilities-is_hidden
                                 slot       = ls_abilities-slot
                                 url2       = ls_abilities-ability-url ).
    APPEND gs_data_abilities TO gt_data_abilities.
  ENDLOOP.
  SORT gt_data_abilities BY slot.

  gv_position = '_LEFT'.
  gv_table    = '_ABILITIES'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FORMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_forms USING p_row.

  CLEAR: gs_data_forms,
       gt_data_forms.

  TRY.
      DATA(lt_forms) = gt_tab[ p_row ]-forms.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_forms INTO DATA(ls_forms).
    gs_data_forms = VALUE #( name = ls_forms-name
                             url  = gc_icon_url
                             url2 = ls_forms-url ).
    APPEND gs_data_forms TO gt_data_forms.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_FORMS'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_GAME_INDICES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_game_indices USING p_row.

  CLEAR: gs_data_game_indices,
       gt_data_game_indices.

  gv_game_index_row = p_row.
  TRY.
      DATA(lt_game_indices) = gt_tab[ p_row ]-game_indices.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_game_indices INTO DATA(ls_game_indices).
    gs_data_game_indices = VALUE #( game_index  = ls_game_indices-game_index
                                    version_g   = VALUE #( name = ls_game_indices-version-name
                                                           url  = gc_icon_url )
                                    url2        = ls_game_indices-version-url ).
    APPEND gs_data_game_indices TO gt_data_game_indices.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_GAME_INDICES'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_HELD_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_held_items USING p_row.

  CLEAR: gs_data_held_items,
       gt_data_held_items.

  gv_held_item_row = p_row.
  TRY.
      DATA(lt_held_items) = gt_tab[ p_row ]-held_items.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_held_items INTO DATA(ls_held_items).
    gs_data_held_items = VALUE #( item            = VALUE #( name  = ls_held_items-item-name
                                                             url   = gc_icon_url )
                                  version_details = gc_icon_table
                                  url2            = ls_held_items-item-url ).
    APPEND gs_data_held_items TO gt_data_held_items.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_HELD_ITEMS'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_VERSION_DETAILS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_version_details USING p_row.

  CLEAR: gs_data_version_details,
       gt_data_version_details.

  TRY.
      DATA(lt_version_details) = gt_tab[ gv_held_item_row ]-held_items[ p_row ]-version_details.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_version_details INTO DATA(ls_version_details).
    gs_data_version_details = VALUE #( rarity     = ls_version_details-rarity
                                       version_h  = VALUE #( name  = ls_version_details-version-name
                                                             url   = gc_icon_url )
                                       url2       = ls_version_details-version-url ).
    APPEND gs_data_version_details TO gt_data_version_details.
  ENDLOOP.

  gv_position = '_MIDDLE'.
  gv_table    = '_VERSION_DETAILS'.
  gv_name = gt_tab[ gv_held_item_row ]-held_items[ p_row ]-item-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_MOVES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_moves USING p_row.

  CLEAR: gs_data_moves,
       gt_data_moves.

  gv_moves_row = p_row.
  TRY.
      DATA(lt_moves) = gt_tab[ p_row ]-moves.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_moves INTO DATA(ls_moves).
    gs_data_moves = VALUE #( move                  = VALUE #( name = ls_moves-move-name
                                                              url  = gc_icon_url )
                             version_group_details = gc_icon_table
                             url2                  = ls_moves-move-url ).
    APPEND gs_data_moves TO gt_data_moves.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_MOVES'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_VERSION_GROUP_DETAILS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_version_group_details USING p_row.

  CLEAR: gs_data_version_group_details,
       gt_data_version_group_details.

  TRY.
      DATA(lt_vgd) = gt_tab[ gv_moves_row ]-moves[ p_row ]-version_group_details.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_vgd INTO DATA(ls_vgd).
    gs_data_version_group_details = VALUE #( level_learned_at   = ls_vgd-level_learned_at
                                             move_learn_method  = VALUE #( name = ls_vgd-move_learn_method-name
                                                                           url  = gc_icon_url )
                                             url2               = ls_vgd-move_learn_method-url
                                             version_group      = VALUE #( name = ls_vgd-version_group-name
                                                                           url  = gc_icon_url )
                                             url3               = ls_vgd-version_group-url ).
    APPEND gs_data_version_group_details TO gt_data_version_group_details.
  ENDLOOP.

  gv_position = '_MIDDLE'.
  gv_table    = '_VERSION_GROUP_DETAILS'.
  gv_name = gt_tab[ gv_moves_row ]-moves[ p_row ]-move-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_STATS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_stats USING p_row.

  CLEAR: gs_data_stats,
       gt_data_stats.

  TRY.
      DATA(lt_stats) = gt_tab[ p_row ]-stats.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_stats INTO DATA(ls_stats).
    gs_data_stats = VALUE #( base_stat = ls_stats-base_stat
                             effort    = ls_stats-effort
                             stat      = VALUE #( name  = ls_stats-stat-name
                                                  url   = gc_icon_url )
                             url2      = ls_stats-stat-url ).
    APPEND gs_data_stats TO gt_data_stats.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_STATS'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_TYPES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&---------------------------------------------------------------------*
FORM get_types USING p_row.

  CLEAR: gs_data_types,
       gt_data_types.

  TRY.
      DATA(lt_types) = gt_tab[ p_row ]-types.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  LOOP AT lt_types INTO DATA(ls_types).
    gs_data_types = VALUE #( slot = ls_types-slot
                             type = VALUE #( name = ls_types-type-name
                                             url  = gc_icon_url )
                             url2 = ls_types-type-url ).
    APPEND gs_data_types TO gt_data_types.
  ENDLOOP.

  gv_position = '_LEFT'.
  gv_table    = '_TYPES'.
  gv_name = gt_tab[ p_row ]-name.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SPRITES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&      --> LV_SPRITE
*&---------------------------------------------------------------------*
FORM get_sprites USING p_row
                       p_sprite.

  DATA: lv_tooltip TYPE string.

  TRY.
      DATA(ls_sprites) = gt_tab[ p_row ]-sprites.
    CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
      RETURN.
  ENDTRY.

  DATA(lv_lower) = to_lower( p_sprite ).

  lv_tooltip = replace( val   = lv_lower
                        regex = `_`
                        with  = ` ` ).

  ASSIGN COMPONENT p_sprite OF STRUCTURE ls_sprites TO FIELD-SYMBOL(<fs_sprite>).
  IF <fs_sprite> IS ASSIGNED AND <fs_sprite> IS NOT INITIAL.

    go_picture_viewer->load_picture_from_url_async( url = <fs_sprite> ).
    go_picture_viewer->set_display_mode( display_mode = cl_gui_picture=>display_mode_fit_center ).
    go_picture_viewer->set_tooltip( lv_tooltip ).

  ELSEIF <fs_sprite> IS ASSIGNED AND <fs_sprite> IS INITIAL.

    CLEAR: lv_tooltip.
    go_picture_viewer->clear_picture( ).
    go_picture_viewer->set_tooltip( lv_tooltip ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_URL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ROW
*&      --> LV_URL
*&---------------------------------------------------------------------*
FORM get_url USING p_row
                   p_url.

  DATA: lv_url TYPE url.

  CASE p_url.
    WHEN 'SPECIES'.
      TRY.
          lv_url = gt_tab[ p_row ]-species-url.
        CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'ABILITY'.
      TRY.
          lv_url = gt_data_abilities[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'FORM'.
      TRY.
          lv_url = gt_data_forms[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'VERSION_G'.
      TRY.
          lv_url = gt_data_game_indices[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'ITEM'.
      TRY.
          lv_url = gt_data_held_items[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'VERSION_H'.
      TRY.
          lv_url = gt_data_version_details[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'MOVE'.
      TRY.
          lv_url = gt_data_moves[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'MOVE_LEARN_METHOD'.
      TRY.
          lv_url = gt_data_version_group_details[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'VERSION_GROUP'.
      TRY.
          lv_url = gt_data_version_group_details[ p_row ]-url3.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'STAT'.
      TRY.
          lv_url = gt_data_stats[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN 'TYPE'.
      TRY.
          lv_url = gt_data_types[ p_row ]-url2.
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
    WHEN OTHERS.
  ENDCASE.

  PERFORM get_any_model USING lv_url.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command USING p_ucomm TYPE salv_de_function.

  DATA(lo_selections) = go_table_top->get_selections( ).
  DATA(lt_selected_rows) = lo_selections->get_selected_rows( ).

  CASE p_ucomm.
    WHEN 'ZXML'.
      PERFORM get_xml_transformations USING lt_selected_rows
                                            'T'.
    WHEN 'PXML'.
      PERFORM get_xml_transformations USING lt_selected_rows
                                            'S'.
    WHEN OTHERS.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FUNCTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SALV_FUNCTIONS
*&      --> P_
*&      --> P_
*&      --> TEXT_061
*&      --> TEXT_062
*&      --> P_
*&---------------------------------------------------------------------*
FORM add_function USING p_functions TYPE REF TO cl_salv_functions_list
                        p_name    TYPE c
                        p_icon    TYPE string
                        p_text    TYPE string
                        p_tooltip TYPE string
                        p_pos     TYPE c.

  DATA: lv_name TYPE salv_de_function,
        lv_pos  TYPE salv_de_function_pos.

  IF p_name IS NOT INITIAL.
    lv_name = p_name.
  ENDIF.

  IF p_pos = 'L'.
    lv_pos = if_salv_c_function_position=>left_of_salv_functions.
  ELSE.
    lv_pos = if_salv_c_function_position=>right_of_salv_functions.
  ENDIF.

  TRY.
      p_functions->add_function( name     = lv_name
                                 icon     = p_icon
                                 text     = p_text
                                 tooltip  = p_tooltip
                                 position = lv_pos ).
    CATCH cx_salv_existing cx_salv_wrong_call.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_XML_TRANSFORMATIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_SELECTED_ROWS
*&---------------------------------------------------------------------*
FORM get_xml_transformations USING p_selected_rows TYPE salv_t_row
                                   p_mode TYPE c.

  DATA: ls_source TYPE zoe_json_st_poke,
        lt_source TYPE zoe_json_tt_poke.

  DATA: lv_path         TYPE string,
        lv_fullpath     TYPE string,
        lv_filename     TYPE string,
        lv_file         TYPE localfile,
        lv_raw_data     TYPE string,
        lv_action       TYPE int4,
        lv_window_title TYPE string.

  IF lines( p_selected_rows ) = 0.
    MESSAGE TEXT-064 TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ELSEIF lines( p_selected_rows ) = 1.
    TRY.
        ls_source = gt_tab[ p_selected_rows[ 1 ] ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lx_msg).
        MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
        RETURN.
    ENDTRY.
    CALL TRANSFORMATION zoe_to_xml_trans_poke_s
    SOURCE zoe_poke_s = ls_source
    RESULT XML lv_raw_data.
  ELSE.
    LOOP AT p_selected_rows INTO DATA(ls_selected_rows).
      TRY.
          ls_source = gt_tab[ ls_selected_rows ].
        CATCH cx_sy_itab_line_not_found INTO lx_msg.
          MESSAGE lx_msg->get_text( ) TYPE `S` DISPLAY LIKE `E`.
          RETURN.
      ENDTRY.
      APPEND ls_source TO lt_source.
    ENDLOOP.
    CALL TRANSFORMATION zoe_to_xml_trans_poke_t
    SOURCE zoe_poke_t = lt_source
    RESULT XML lv_raw_data.
  ENDIF.

  DATA(lo_xml_doc) = NEW cl_xml_document( ).

  IF p_mode = 'T'.
    lv_window_title = TEXT-063.

    cl_gui_frontend_services=>file_save_dialog(
                                  EXPORTING
                                    window_title      = lv_window_title
                                    default_extension = `xml`
                                    default_file_name = `export`
                                    file_filter       = `*.xml`
                                  CHANGING
                                    filename    = lv_filename
                                    path        = lv_path
                                    fullpath    = lv_fullpath
                                    user_action = lv_action
                                  EXCEPTIONS
                                    cntl_error                = 1
                                    error_no_gui              = 2
                                    not_supported_by_gui      = 3
                                    invalid_default_file_name = 4
                                    OTHERS                    = 5 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_action = 0.

      lv_file = lv_fullpath.
      lo_xml_doc->export_to_file( lv_file ).

    ENDIF.

  ELSEIF p_mode = 'S'.

    cl_abap_browser=>show_xml( xml_string   = lv_raw_data
                               title        = TEXT-070
                               format       = cl_abap_browser=>portrait ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_MODEL_JSON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_model_json.

  CALL TRANSFORMATION sjson2html
  SOURCE XML gv_any_model_response
  RESULT XML DATA(lv_html).

  cl_abap_browser=>show_html( title        = TEXT-071
                              html_string  = cl_abap_codepage=>convert_from( lv_html )
                              format       = cl_abap_browser=>portrait ).

ENDFORM.
