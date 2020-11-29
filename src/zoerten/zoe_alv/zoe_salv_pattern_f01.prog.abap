*&---------------------------------------------------------------------*
*& Include          ZOE_SALV_PATTERN_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM mara
    UP TO 50 ROWS
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE matnr IN @so_matnr
    AND   matkl IN @so_matkl
    AND   mtart IN @so_mtart.

  LOOP AT gt_data INTO gs_data.

    SELECT SINGLE maktx
      FROM makt
      INTO @gs_data-maktx
      WHERE matnr = @gs_data-matnr
      AND   spras = @sy-langu.

    MODIFY gt_data FROM gs_data.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data .

  DATA: salv_exception TYPE REF TO cx_salv_msg.
  DATA: salv_columns   TYPE REF TO cl_salv_columns.
  DATA: salv_layout  TYPE REF TO cl_salv_layout,
        salv_variant TYPE slis_vari,
        salv_key     TYPE salv_s_layout_key.
  DATA: salv_events TYPE REF TO cl_salv_events_table.
  DATA: salv_selections TYPE REF TO cl_salv_selections.
  TRY.
      cl_salv_table=>factory(
            IMPORTING
              r_salv_table = gr_table
            CHANGING
              t_table      = gt_data
          ).

      gr_table->get_display_settings( )->set_striped_pattern( abap_true ).
      gr_table->get_columns( )->set_optimize( abap_true ).
      gr_table->get_functions( )->set_all( abap_true ).

      gr_table->set_screen_status(
        EXPORTING
          report        = sy-repid
          pfstatus      = 'SALV_STANDARD'
          set_functions = gr_table->c_functions_all
      ).
      salv_selections = gr_table->get_selections( ).
      salv_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      salv_layout = gr_table->get_layout( ).
      salv_columns = gr_table->get_columns( ).
      salv_columns->set_optimize( abap_true ).
      salv_key-report = sy-repid.
      salv_layout->set_key( salv_key ).
      salv_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

      salv_events = gr_table->get_event( ).
      CREATE OBJECT gr_events.
      SET HANDLER gr_events->on_user_command FOR salv_events.
      SET HANDLER gr_events->on_link_click FOR salv_events.
      SET HANDLER gr_events->on_double_click FOR salv_events.

      PERFORM change_column USING salv_columns:
      "FIELD       TECH  INVS HOTS  KEY  CURR QUAN  L-M Text   S Text
      'MANDT' '' 'X' '' '' '' '' '' ''.

      gr_table->display( ).

    CATCH cx_salv_msg INTO salv_exception.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command  USING i_ucomm TYPE salv_de_function.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING p_row TYPE salv_de_row
                                p_column TYPE salv_de_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_LINK_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_link_click  USING p_row TYPE salv_de_row
                              p_column TYPE salv_de_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_COLUMN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SALV_COLUMNS
*&      --> GR_TABLE_>DISPLAY(
*&      --> )
*&---------------------------------------------------------------------*
FORM change_column  USING po_columns TYPE REF TO cl_salv_columns
                          pv_fieldname TYPE c
                          pv_technical TYPE c
                          pv_invisible TYPE c
                          pv_hotspot   TYPE c
                          pv_key       TYPE c
                          pv_currref   TYPE c
                          pv_quanref   TYPE c
                          pv_fieldtextlm TYPE c
                          pv_fieldtexts TYPE c.

  DATA lo_column  TYPE REF TO cl_salv_column_table.
  DATA lv_short TYPE scrtext_s.
  DATA lv_medium TYPE scrtext_m.
  DATA lv_long TYPE scrtext_l.
  TRY .
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
    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
  ENDTRY.

ENDFORM.
