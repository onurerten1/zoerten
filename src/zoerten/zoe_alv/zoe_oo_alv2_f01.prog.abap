*&---------------------------------------------------------------------*
*& Include          ZOE_OO_ALV2_F01
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
  SELECT * FROM zoe_head_ekko
    INTO CORRESPONDING FIELDS OF TABLE gt_data_left
    WHERE ebeln IN so_ebeln
    AND kunnr IN so_kunnr
    AND bukrs IN so_bukrs.


  SORT gt_data_left BY ebeln.

  IF gt_data_left[] IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_FCAT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_fcat1 USING gv_char.

  DATA: lv_text(30).

  lv_text = |GT_DATA{ gv_char }|.
  ASSIGN (lv_text) TO <fs1>.
  lv_text = |GT_FCAT{ gv_char }|.
  ASSIGN (lv_text) TO <fs3>.
  lv_text = |GT_FIELDCAT{ gv_char }|.
  ASSIGN (lv_text) TO <fs4>.
  lv_text = |GS_DATA{ gv_char }|.
  ASSIGN lv_text TO <fs2>.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = <fs2>
*     I_STRUCTURE_NAME       =
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_inclname             = 'ZOE_OO_ALV2_TOP'
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = <fs3>
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = <fs3>
*     IT_SORT_ALV     =
*     IT_FILTER_ALV   =
*     IS_LAYOUT_ALV   =
    IMPORTING
      et_fieldcat_lvc = <fs4>
*     ET_SORT_LVC     =
*     ET_FILTER_LVC   =
*     ES_LAYOUT_LVC   =
    TABLES
      it_data         = <fs1>
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_LAYOUT1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_layout1 .

  IF gv_check = 1.
    ASSIGN gs_layout_left TO <fs_lay>.
    <fs_lay>-info_fname = 'COLOR'.
    <fs_lay>-cwidth_opt = 'X'.
  ELSEIF gv_check = 2.
    ASSIGN gs_layout_right TO <fs_lay>.
    <fs_lay>-sel_mode = 'A'.
    <fs_lay>-stylefname = 'CELLSTYLES'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv1 USING value.

  DATA: lv_grid(30),
        lv_cont(30).

  lv_grid = |grid{ value }|.
  lv_cont = |container{ value }|.

  ASSIGN (lv_grid) TO <fs_grid>.
  ASSIGN (lv_cont) TO <fs_cont>.

  IF <fs_grid> IS INITIAL.

    CREATE OBJECT <fs_grid>
      EXPORTING
        i_parent = <fs_cont>.

    CALL METHOD <fs_grid>->set_table_for_first_display
      EXPORTING
        is_layout            = <fs_lay>
        it_toolbar_excluding = gt_exclude
      CHANGING
        it_outtab            = <fs1>
        it_fieldcatalog      = <fs4>.

    IF gv_check = 1.
      DATA receiver     TYPE REF TO lcl_eventhandler.
      CREATE OBJECT receiver.
      SET HANDLER receiver->handle_double_click FOR <fs_grid>.
    ELSEIF gv_check = 2.
      DATA event_receiver         TYPE REF TO lcl_eventhandler.
      CREATE OBJECT event_receiver.
      SET HANDLER event_receiver->handle_toolbar FOR <fs_grid>.
      SET HANDLER event_receiver->handle_user_command FOR <fs_grid>.
      SET HANDLER event_receiver->handle_data_changed FOR <fs_grid>.
      SET HANDLER event_receiver->on_hotspot_click FOR <fs_grid>.
      SET HANDLER event_receiver->handle_data_changed_finished FOR <fs_grid>.
      CALL METHOD <fs_grid>->set_toolbar_interactive.
      CALL METHOD <fs_grid>->register_edit_event
        EXPORTING
          i_event_id = <fs_grid>->mc_evt_enter.
      CALL METHOD <fs_grid>->set_ready_for_input
        EXPORTING
          i_ready_for_input = 1.
    ENDIF.
  ELSE.
    gv_grid = <fs_grid>.
    PERFORM refresh_alv USING gv_grid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM double_click  USING    p_index TYPE sy-index.

  CLEAR: gt_data_right, gs_data_right.
  READ TABLE gt_data_left INTO gs_data_left INDEX p_index.
  IF sy-subrc = 0.
    SELECT * FROM zoe_item_ekpo
      INTO CORRESPONDING FIELDS OF TABLE gt_data_right
      WHERE ebeln = gs_data_left-ebeln.
    SORT gt_data_right BY ebelp.
  ENDIF.

  gv_check = 2.
  PERFORM fill_fcat1 USING '_RIGHT'.
  PERFORM fill_layout1.
  PERFORM modify_fcat_right.
  PERFORM change_specific.
  PERFORM alv_toolbar CHANGING gt_exclude.
  PERFORM create_alv1 USING '_RIGHT'.
  CLEAR: gv_check.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM handle_toolbar USING e_object TYPE REF TO cl_alv_event_toolbar_set.

  DATA: ls_toolbar  TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 'AKTAR' TO ls_toolbar-function.
  MOVE icon_arrow_right TO ls_toolbar-icon.
  MOVE 'Girilenleri Aktar '(111) TO ls_toolbar-quickinfo.
  MOVE 'Aktar'(112) TO ls_toolbar-text.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form COLORING
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM coloring .
  LOOP AT gt_data_left INTO gs_data_left.
    IF gs_data_left-ebeln EQ '4500000005'.
      gs_data_left-color = 'C610'.
    ENDIF.
    MODIFY gt_data_left FROM  gs_data_left TRANSPORTING color.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM hotspot  USING p_row TYPE sy-index.
  READ TABLE gt_data_right INTO gs_data_right INDEX p_row.
  SET PARAMETER ID 'MAT' FIELD gs_data_right-matnr.
  CALL TRANSACTION 'MM03' WITH AUTHORITY-CHECK
  AND SKIP FIRST SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_toolbar CHANGING pt_exclude TYPE ui_functions.
  DATA ls_exclude TYPE ui_func.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row .
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row .
  APPEND ls_exclude TO pt_exclude.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_CHANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM data_change  USING p_er_data_changed
                  TYPE REF TO cl_alv_changed_data_protocol.

  DATA: lt_mod TYPE lvc_t_modi.
  DATA: ls_mod TYPE lvc_s_modi.
  DATA: ls_color LIKE zoe_color-zzcolor.
  DATA: lv_col TYPE lvc_s_col.
  DATA: lv_row TYPE lvc_s_row.

  lt_mod = p_er_data_changed->mt_mod_cells.
  READ TABLE lt_mod INDEX 1 INTO ls_mod.
  TRANSLATE ls_mod-value TO UPPER CASE.
  READ TABLE gt_data_right INDEX ls_mod-row_id INTO gs_data_right.
  SELECT SINGLE COUNT(*)
    FROM zoe_color
    INTO @DATA(lt_color)
    WHERE zzcolor = @ls_mod-value.
  IF sy-subrc <> 0.
    gs_data_right-zzcolor = ' '.
    MESSAGE TEXT-i02 TYPE 'S' DISPLAY LIKE 'E'.
  ELSE.
    gs_data_right-zzcolor = ls_mod-value.
  ENDIF.

  MODIFY gt_data_right FROM gs_data_right INDEX ls_mod-row_id.
  lv_col-fieldname = ls_mod-fieldname.
  lv_row-index = ls_mod-row_id.
  CLEAR p_er_data_changed->mt_mod_cells.
  gv_grid = <fs_grid>.
  PERFORM refresh_alv USING gv_grid.
  CALL METHOD <fs_grid>->set_current_cell_via_id
    EXPORTING
      is_column_id = lv_col
      is_row_id    = lv_row.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_changed_finished .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv USING gv_grid
                 TYPE REF TO cl_gui_alv_grid.

  CALL METHOD gv_grid->refresh_table_display.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR: gv_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_SPECIFIC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_specific .
  LOOP AT gt_data_right INTO gs_data_right.
    IF gs_data_right-matnr = 'MZ-RM-C990-09'.
      gs_cellstyles-fieldname = 'MATNR'.
      gs_cellstyles-style = cl_gui_alv_grid=>mc_style_enabled.
      INSERT gs_cellstyles INTO TABLE gs_data_right-cellstyles.
      MODIFY gt_data_right FROM gs_data_right.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_objects .
  CREATE OBJECT main_container
    EXPORTING
      container_name = 'MAIN_CONTAINER'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SPLITTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM splitter .
  CREATE OBJECT splitter
    EXPORTING
      parent  = main_container
      rows    = 1
      columns = 2.
  CALL METHOD splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = container_left.
  CALL METHOD splitter->get_container
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = container_right.
*  CALL METHOD splitter->set_width
*    EXPORTING
*      width = '1'.
  CALL METHOD splitter->set_column_sash
    EXPORTING
      id    = '1'
      type  = '1'
      value = '1'.
  CALL METHOD splitter->set_column_width
    EXPORTING
      id    = 1
      width = 45.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_FCAT_LEFT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_fcat_left .

  LOOP AT gt_fieldcat_left INTO gs_fieldcat_left.
    CASE gs_fieldcat_left-fieldname.
      WHEN 'AEDAT'.
        gs_fieldcat_left-emphasize = 'C510'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat_left FROM gs_fieldcat_left TRANSPORTING emphasize.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_FCAT_RIGHT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_fcat_right .

  LOOP AT gt_fieldcat_right INTO gs_fieldcat_right.
    CASE gs_fieldcat_right-fieldname.
      WHEN 'ZZCOLOR'.
        gs_fieldcat_right-edit = 'X'.
        gs_fieldcat_right-f4availabl = 'X'.
      WHEN 'MATNR'.
        gs_fieldcat_right-hotspot = 'X'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat_right FROM gs_fieldcat_right
    TRANSPORTING edit f4availabl hotspot.
  ENDLOOP.

ENDFORM.
