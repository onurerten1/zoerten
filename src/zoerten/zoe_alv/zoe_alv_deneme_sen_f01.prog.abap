*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_DENEME_SEN_F01
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

  SELECT  m~mblnr,
          m~mjahr,
          m~blart,
          t~ltext,
          m~bldat,
          m~budat,
          m~usnam,
          m~xblnr
    FROM mkpf AS m
    INNER JOIN mseg AS s ON
    m~mblnr = s~mblnr AND
    m~mjahr = s~mjahr
    LEFT OUTER JOIN t003t AS t ON
    m~blart = t~blart AND
    t~spras = @sy-langu
    INTO CORRESPONDING FIELDS OF TABLE @gt_top
    WHERE m~mblnr IN @s_mblnr AND
          m~mjahr IN @s_mjahr
    ORDER BY m~mjahr DESCENDING.

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

  IF gt_top[] IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_container .

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
      rows    = 2
      columns = 1.

  CALL METHOD splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = container_top.

  CALL METHOD splitter->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = container_bottom.

  CALL METHOD splitter->set_row_height
    EXPORTING
      id     = 1
      height = 50.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM fill_fieldcat USING lv_char.

  DATA: lv_text(30).

  lv_text = |GT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_tab>.

  lv_text = |GT_FCAT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_fcs>.

  lv_text = |GT_FIELDCAT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_fcl>.

  lv_text = |GS{ lv_char }|.
  ASSIGN lv_text TO <fs_str>.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = <fs_str>
*     i_structure_name       = <fs_str>
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_inclname             = gc_top
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = <fs_fcs>
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = <fs_fcs>
*     IT_SORT_ALV     =
*     IT_FILTER_ALV   =
*     IS_LAYOUT_ALV   =
    IMPORTING
      et_fieldcat_lvc = <fs_fcl>
*     ET_SORT_LVC     =
*     ET_FILTER_LVC   =
*     ES_LAYOUT_LVC   =
    TABLES
      it_data         = <fs_tab>
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_fieldcat USING lv_char.

  DATA: lv_text(30).

  lv_text = |GT_FIELDCAT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_fcl>.

  lv_text = |GS_FIELDCAT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_fcls>.

  LOOP AT <fs_fcl> INTO <fs_fcls>.
    CASE <fs_fcls>-fieldname.
      WHEN 'MBLNR'.
        IF lv_text CS '_BOTTOM'.
          <fs_fcls>-hotspot = 'X'.
        ENDIF.
      WHEN 'MATNR'.
        IF lv_text CS '_BOTTOM'.
          <fs_fcls>-hotspot = 'X'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY <fs_fcl> FROM <fs_fcls>.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM fill_layout USING lv_char.

  DATA: lv_text(30).

  lv_text = |GS_LAYOUT{ lv_char }|.
  ASSIGN (lv_text) TO <fs_lay>.

  IF lv_text CS '_TOP'.
    <fs_lay>-cwidth_opt = 'X'.
    <fs_lay>-zebra = 'X'.
  ELSEIF lv_text CS '_BOTTOM'.
    <fs_lay>-cwidth_opt = 'X'.
    <fs_lay>-zebra = 'X'.
    <fs_lay>-sel_mode = 'A'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM create_alv USING lv_char.

  DATA: lv_grid(30),
        lv_cont(30).

  DATA: handler TYPE REF TO lcl_eventhandler.

  lv_grid = |GRID{ lv_char }|.
  lv_cont = |CONTAINER{ lv_char }|.

  ASSIGN (lv_grid) TO <fs_grid>.
  ASSIGN (lv_cont) TO <fs_cont>.

  IF <fs_grid> IS INITIAL.

    CREATE OBJECT <fs_grid>
      EXPORTING
        i_parent = <fs_cont>.

    CALL METHOD <fs_grid>->set_table_for_first_display
      EXPORTING
        is_layout       = <fs_lay>
*       it_toolbar_excluding = gt_exclude
      CHANGING
        it_outtab       = <fs_tab>
        it_fieldcatalog = <fs_fcl>.

    CREATE OBJECT handler.

    IF lv_grid CS '_TOP'.
      SET HANDLER handler->double_click FOR <fs_grid>.
    ELSEIF lv_grid CS '_BOTTOM'.
      SET HANDLER handler->hotspot FOR <fs_grid>.
      SET HANDLER handler->handle_toolbar FOR <fs_grid>.
      SET HANDLER handler->handle_user_command FOR <fs_grid>.
      CALL METHOD <fs_grid>->set_toolbar_interactive.
    ENDIF.

  ELSE.

    PERFORM refresh_alv USING <fs_grid> <fs_lay>.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <FS_GRID>
*&---------------------------------------------------------------------*
FORM refresh_alv USING lv_grid TYPE REF TO cl_gui_alv_grid
                       lv_layo TYPE lvc_s_layo.

  CALL METHOD lv_grid->set_frontend_layout
    EXPORTING
      is_layout = lv_layo.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD lv_grid->refresh_table_display
    EXPORTING
      i_soft_refresh = 'X'.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM double_click USING lv_row TYPE sy-index.

*  READ TABLE gt_top INTO gs_top INDEX lv_row.
  gs_top = gt_top[ lv_row ].

  SELECT DISTINCT  mseg~mblnr,
                   mseg~mjahr,
                   mseg~zeile,
                   mseg~bwart,
                   mseg~matnr,
                   makt~maktx,
                   mseg~menge,
                   mseg~meins,
                   mseg~werks,
                   t001w~name1,
                   mseg~lgort,
                   t001l~lgobe,
                   mseg~charg,
                   mseg~lifnr,
                   mseg~kunnr
              FROM mseg
              LEFT OUTER JOIN makt
              ON mseg~matnr = makt~matnr
              AND makt~spras = @sy-langu
              LEFT OUTER JOIN t001w
              ON mseg~werks = t001w~werks
              AND t001w~spras = @sy-langu
              LEFT OUTER JOIN t001l
              ON mseg~lgort = t001l~lgort
              AND mseg~werks = t001l~werks
              INTO CORRESPONDING FIELDS OF TABLE @gt_bottom
              WHERE mseg~mblnr = @gs_top-mblnr AND
                    mseg~mjahr = @gs_top-mjahr
              ORDER BY zeile.

  IF gt_bottom IS NOT INITIAL.
    PERFORM get_bottom_alv.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_BOTTOM_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_bottom_alv .

  IF gt_fieldcat_bottom[] IS INITIAL.
    PERFORM fill_fieldcat USING '_BOTTOM'.
    PERFORM modify_fieldcat USING '_BOTTOM'.
  ENDIF.

  PERFORM fill_layout USING '_BOTTOM'.
  PERFORM create_alv USING '_BOTTOM'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN_ID
*&      --> E_ROW_ID
*&---------------------------------------------------------------------*
FORM hotspot USING lv_column TYPE lvc_s_col
                   lv_row    TYPE lvc_s_row.

*  READ TABLE gt_bottom INTO gs_bottom INDEX lv_row-index.
  gs_bottom = gt_bottom[ lv_row-index ].

  IF lv_column = 'MATNR'.

    SET PARAMETER ID 'MAT' FIELD gs_bottom-matnr.
    CALL TRANSACTION 'MM03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.

  ELSEIF lv_column = 'MBLNR'.

    CALL FUNCTION 'MIGO_DIALOG'
      EXPORTING
*       I_ACTION            = 'A04'
*       I_REFDOC            = 'R02'
*       I_NOTREE            = 'X'
*       I_NO_AUTH_CHECK     =
*       I_SKIP_FIRST_SCREEN = 'X'
*       I_DEADEND           = 'X'
*       I_OKCODE            = 'OK_GO'
*       I_LEAVE_AFTER_POST  =
*       I_NEW_ROLLAREA      = 'X'
*       I_SYTCODE           =
*       I_EBELN             =
*       I_EBELP             =
        i_mblnr             = gs_bottom-mblnr
        i_mjahr             = gs_bottom-mjahr
        i_zeile             = gs_bottom-zeile
*       I_TRANSPORT         =
*       I_ORDER_NUMBER      =
*       I_ORDER_ITEM        =
*       I_TRANSPORT_MEANS   =
*       I_TRANSPORTIDENT    =
*       I_INBOUND_DELIV     =
*       I_OUTBOUND_DELIV    =
*       I_RESERVATION_NUMB  =
*       I_RESERVATION_ITEM  =
*       EXT                 =
*       I_MOVE_TYPE         =
*       I_SPEC_STOCK        =
*       I_PSTNG_DATE        =
*       I_DOC_DATE          =
*       I_REF_DOC_NO        =
*       I_HEADER_TXT        =
      EXCEPTIONS
        illegal_combination = 1
        OTHERS              = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PRINT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print_items .

  DATA: ls_rows TYPE lvc_s_row,
        lt_rows TYPE lvc_t_row.

  IF grid_bottom IS INITIAL.

    MESSAGE 'Alt ALV''yi çağırın' TYPE 'E'.

  ENDIF.

  CALL METHOD grid_bottom->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  IF lt_rows IS INITIAL.

    MESSAGE 'Satır seçiniz' TYPE 'E'.

  ELSE.

    LOOP AT lt_rows INTO ls_rows.
      READ TABLE gt_bottom INTO gs_bottom INDEX ls_rows-index.
      gs_bottom = gt_bottom[ ls_rows-index ].
      gs_print = CORRESPONDING #( gs_bottom ).
      APPEND gs_print TO gt_print.
      CLEAR: ls_rows,
             gs_bottom,
             gs_print.
    ENDLOOP.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = gs_fp_outparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = gc_form_etiket
          IMPORTING
            e_funcname = gv_fm_name.
      CATCH        cx_fp_api_repository.
      CATCH        cx_fp_api_usage.
      CATCH        cx_fp_api_internal.
    ENDTRY.

    CALL FUNCTION gv_fm_name
      EXPORTING
        /1bcdwb/docparams = gs_fp_docparams
        it_etiket         = gt_print
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3
        OTHERS            = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM handle_toolbar  USING p_object TYPE REF TO cl_alv_event_toolbar_set.

  DATA: alv_toolbar TYPE stb_button.

  PERFORM add_function USING p_object alv_toolbar:
  "FUNCTION ICON QUICKINFO BUTN_TYPE DISABLED TEXT CHECKED
  'PRINT' '@0X@' 'Seçilenleri Yazdır' '' '' 'Yazdır' ''.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FUNCTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ALV_TOOLBAR
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM add_function  USING p_object TYPE REF TO cl_alv_event_toolbar_set
                         p_alv_toolbar  TYPE stb_button
                         p_function     TYPE ui_func
                         p_icon         TYPE iconname
                         p_quickinfo    TYPE iconquick
                         p_buttype      TYPE tb_btype
                         p_disabled     TYPE c
                         p_text         TYPE text40
                         p_checked      TYPE c.

  CLEAR: p_alv_toolbar.

*  p_alv_toolbar-function = p_function.
*  p_alv_toolbar-icon = p_icon.
*  p_alv_toolbar-quickinfo = p_quickinfo.
*  p_alv_toolbar-butn_type = p_buttype.
*  p_alv_toolbar-disabled = p_disabled.
*  p_alv_toolbar-text = p_text.
*  p_alv_toolbar-checked = p_checked.

  p_alv_toolbar = VALUE #( function   = p_function
                           icon       = p_icon
                           quickinfo  = p_quickinfo
                           butn_type  = p_buttype
                           disabled   = p_disabled
                           text       = p_text
                           checked    = p_checked ).

  APPEND p_alv_toolbar TO p_object->mt_toolbar.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM handle_user_command  USING p_ucomm TYPE sy-ucomm.

  CASE p_ucomm.
    WHEN 'PRINT'.
      PERFORM print_items.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
