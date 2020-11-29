*&---------------------------------------------------------------------*
*& Include          ZOE_TREE_ALV_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_TREE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_tree .

  CREATE OBJECT alv_tree
    EXPORTING
      parent                      = tree_container
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = ' '
      no_html_header              = 'X'
*     no_toolbar                  = ' '.
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  DATA: ls_hierarchy_header TYPE treev_hhdr.
  PERFORM build_hierarchy_header CHANGING ls_hierarchy_header.

  PERFORM build_fieldcatalog.

  CALL METHOD alv_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = ls_hierarchy_header
    CHANGING
      it_fieldcatalog     = gt_fieldcatalog
      it_outtab           = gt_output[].

  PERFORM create_hierarchy.

  PERFORM change_toolbar.

  PERFORM register_events.

  CALL METHOD alv_tree->update_calculations.

  CALL METHOD alv_tree->frontend_update.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_HIERARCHY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_HIERARCHY_HEADER
*&---------------------------------------------------------------------*
FORM build_hierarchy_header CHANGING
                      p_ls_hierarchy_header TYPE treev_hhdr.

  p_ls_hierarchy_header-heading = 'Order Types'(300).
  p_ls_hierarchy_header-tooltip = 'Z Order Types in the System'(400).
  p_ls_hierarchy_header-width = 45.
  p_ls_hierarchy_header-width_pix = ''.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcatalog .

*  DATA: ls_fieldcatalog TYPE lvc_s_fcat.
  DATA: lt_output TYPE zoe_t_tree_alv OCCURS 0.
  DATA: lt_fcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_internal_tabname = 'GT_OUTPUT'
      i_inclname         = 'ZOE_TREE_ALV_TOP'
    CHANGING
      ct_fieldcat        = lt_fcat[].

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = lt_fcat[]
*     IT_SORT_ALV     =
*     IT_FILTER_ALV   =
*     IS_LAYOUT_ALV   =
    IMPORTING
      et_fieldcat_lvc = gt_fieldcatalog
*     ET_SORT_LVC     =
*     ET_FILTER_LVC   =
*     ES_LAYOUT_LVC   =
    TABLES
      it_data         = gt_output
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fieldcatalog INTO DATA(ls_fieldcatalog).
    CASE ls_fieldcatalog-fieldname.
      WHEN 'AUART' OR 'VBELN' OR 'WAERK'.
        ls_fieldcatalog-no_out = 'X'.
      WHEN 'UNPR' OR  'NETWR' OR 'KWMENG'.
        ls_fieldcatalog-do_sum = 'X'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcatalog FROM ls_fieldcatalog.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_HIERARCHY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_hierarchy .

  DATA: ls_top_key    TYPE lvc_nkey,
        ls_last_key   TYPE lvc_nkey,
        ls_auart_key  TYPE lvc_nkey,
        ls_waerk_key  TYPE lvc_nkey,
        lt_tree       TYPE zoe_t_tree_alv OCCURS 0 WITH HEADER LINE,
        ls_tree       TYPE zoe_t_tree_alv,
        lv_node_text  TYPE lvc_value,
        lv_waerk      LIKE zoe_t_tree_alv-waerk,
        lv_waerk_last LIKE zoe_t_tree_alv-waerk,
        lv_auart      LIKE zoe_t_tree_alv-auart,
        lv_auart_last LIKE zoe_t_tree_alv-auart.


  SELECT  k~vbeln,
          k~waerk,
          k~auart,
          k~netwr,
*          kwmeng
          SUM( p~kwmeng ) AS kwmeng
    FROM vbak AS k
    INNER JOIN vbap AS p
    ON k~vbeln EQ p~vbeln
    INTO CORRESPONDING FIELDS OF TABLE @lt_tree
    WHERE k~auart LIKE 'Z%'
    GROUP BY k~vbeln, k~waerk, k~auart, k~netwr.
  SORT lt_tree BY auart waerk vbeln.

  LOOP AT lt_tree.
    IF lt_tree-kwmeng = 0.
      DELETE lt_tree.
    ELSE.
      lt_tree-unpr = lt_tree-netwr / lt_tree-kwmeng.
    ENDIF.
    MODIFY lt_tree.
  ENDLOOP.


  CALL METHOD alv_tree->add_node
    EXPORTING
      i_relat_node_key = ''
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'Order Types'
    IMPORTING
      e_new_node_key   = ls_top_key.

  LOOP AT lt_tree.
    lv_auart = lt_tree-auart.
    lv_waerk = lt_tree-waerk.

    IF lv_auart <> lv_auart_last.

      lv_auart_last = lv_auart.

      lv_node_text = lv_auart.

      CALL METHOD alv_tree->add_node
        EXPORTING
          i_relat_node_key = ls_top_key
          i_relationship   = cl_gui_column_tree=>relat_last_child
          i_node_text      = lv_node_text
          is_outtab_line   = lt_tree
        IMPORTING
          e_new_node_key   = ls_auart_key.

      CLEAR: lv_waerk_last.
    ENDIF.

    IF lv_waerk <> lv_waerk_last.
      lv_waerk_last = lv_waerk.

      lv_node_text = lt_tree-waerk.

      CALL METHOD alv_tree->add_node
        EXPORTING
          i_relat_node_key = ls_auart_key
          i_relationship   = cl_gui_column_tree=>relat_last_child
          i_node_text      = lv_node_text
          is_outtab_line   = lt_tree
        IMPORTING
          e_new_node_key   = ls_waerk_key.

    ENDIF.

    lv_node_text = lt_tree-vbeln.

    CALL METHOD alv_tree->add_node
      EXPORTING
        i_relat_node_key = ls_waerk_key
        i_relationship   = cl_gui_column_tree=>relat_last_child
        is_outtab_line   = lt_tree
        i_node_text      = lv_node_text
      IMPORTING
        e_new_node_key   = ls_last_key.

  ENDLOOP.

  CALL METHOD alv_tree->expand_node
    EXPORTING
      i_node_key = ls_top_key.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_toolbar .

  CALL METHOD alv_tree->get_toolbar_object
    IMPORTING
      er_toolbar = gv_toolbar.

  CHECK NOT gv_toolbar IS INITIAL.

  CALL METHOD gv_toolbar->add_button
    EXPORTING
      fcode     = ''
      icon      = ''
      butn_type = cntb_btype_sep.

  CALL METHOD gv_toolbar->add_button
    EXPORTING
      fcode     = 'DETAIL'
      icon      = icon_select_detail
      butn_type = cntb_btype_button
      text      = 'Details'
      quickinfo = 'Details of the sale'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REGISTER_EVENTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events .

  DATA: lt_events         TYPE cntl_simple_events,
        lv_event          TYPE cntl_simple_event,
        ls_event_receiver TYPE REF TO lcl_toolbar_event_receiver.

  CALL METHOD alv_tree->get_registered_events
    IMPORTING
      events = lt_events.

  CALL METHOD alv_tree->set_registered_events
    EXPORTING
      events = lt_events.

  CREATE OBJECT ls_event_receiver.
  SET HANDLER ls_event_receiver->on_function_selected FOR gv_toolbar.
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

  CREATE OBJECT container
    EXPORTING
      container_name = 'CONTAINER'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SPLITTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_splitter .

  CREATE OBJECT splitter
    EXPORTING
      parent  = container
      rows    = 1
      columns = 2.
  CALL METHOD splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = tree_container.

  CALL METHOD splitter->set_column_sash
    EXPORTING
      id    = '1'
      type  = '1'
      value = '1'.
  CALL METHOD splitter->set_column_width
    EXPORTING
      id    = 1
      width = 40.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv .

*

  CALL METHOD grid->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_vbap
      it_fieldcatalog = gt_fieldcat.
*  ELSE.
*    PERFORM refresh_alv.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_layout .
  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_fcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'GS_VBAP'
*     I_STRUCTURE_NAME       =
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_inclname             = 'ZOE_TREE_ALV_TOP'
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = gt_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = gt_fcat[]
*     IT_SORT_ALV     =
*     IT_FILTER_ALV   =
*     IS_LAYOUT_ALV   =
    IMPORTING
      et_fieldcat_lvc = gt_fieldcat
*     ET_SORT_LVC     =
*     ET_FILTER_LVC   =
*     ES_LAYOUT_LVC   =
    TABLES
      it_data         = gt_vbap
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv .
  CALL METHOD grid->refresh_table_display
    EXCEPTIONS
      finished = 1
      OTHERS   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
