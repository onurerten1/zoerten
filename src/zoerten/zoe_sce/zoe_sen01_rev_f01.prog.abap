*&---------------------------------------------------------------------*
*& Include          ZOE_SEN01_REV_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SCREEN_LOOP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_loop .

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        IF pa_rb2 = 'X' OR pa_rb3 = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN 'GR2'.
        IF pa_rb1 = 'X' OR pa_rb3 = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR: gt_data[].

  IF pa_rb1 = abap_true.

    gv_num = 01.

    SELECT m~matnr,
           t~maktx,
           m~werks,
           w~name1,
           m~lgort,
           m~charg,
           m~clabs,
           @gv_num AS stok_tipi
      FROM mchb AS m
      LEFT OUTER JOIN makt AS t ON m~matnr = t~matnr
      AND                          t~spras = @sy-langu
      LEFT OUTER JOIN t001w AS w ON m~werks = w~werks
      AND                           w~spras = @sy-langu
      INTO CORRESPONDING FIELDS OF TABLE @gt_data
      WHERE m~matnr IN @so_matnr
      AND   m~werks IN @so_werks
      AND   m~charg IN @so_charg.

  ELSEIF pa_rb2 = abap_true.

    gv_num = 02.

    SELECT m~matnr,
           maktx,
           m~werks,
           w~name1,
           m~lgort,
           m~labst AS clabs,
           @gv_num AS stok_tipi
        FROM mard AS m
        LEFT OUTER JOIN makt AS t ON m~matnr = t~matnr
        AND                          t~spras = @sy-langu
        LEFT OUTER JOIN t001w AS w ON m~werks = w~werks
        AND                           w~spras = @sy-langu
        INTO CORRESPONDING FIELDS OF TABLE @gt_data
        WHERE m~matnr IN @so_matnr
        AND   m~werks IN @so_werks
        AND   m~lgort IN @so_lgort.

  ELSEIF pa_rb3 = abap_true.

    gv_num = 03.

    SELECT m~matnr,
           t~maktx,
           m~werks,
           w~name1,
           SUM( m~clabs ) AS clabs,
           @gv_num AS stok_tipi
        FROM mchb AS m
        LEFT OUTER JOIN makt AS t ON m~matnr = t~matnr
        AND                          t~spras = @sy-langu
        LEFT OUTER JOIN t001w AS w ON m~werks = w~werks
        AND                           w~spras = @sy-langu
        INTO CORRESPONDING FIELDS OF TABLE @gt_data
        WHERE m~matnr IN @so_matnr
        AND   m~werks IN @so_werks
        GROUP BY m~matnr, t~maktx, m~werks, w~name1.

  ENDIF.

  PERFORM modify_table.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
FORM modify_table.

  DATA: ls_color TYPE lvc_s_scol,
        lt_color TYPE lvc_t_scol,
        lt_comp  TYPE TABLE OF rstrucinfo.

  CALL FUNCTION 'GET_COMPONENT_LIST'
    EXPORTING
      program    = sy-repid
      fieldname  = 'GS_DATA'
    TABLES
      components = lt_comp.


  SELECT z~matnr,
         z~werks,
         z~lgort,
         z~charg,
         z~clabs,
         z~mail
    FROM zoe_sen_stokup AS z
    INNER JOIN @gt_data AS g ON z~matnr = g~matnr
    AND                         z~werks = g~werks
    AND                         z~lgort = g~lgort
    AND                         z~charg = g~charg
    AND                         z~stok_tipi = @gv_num
    INTO TABLE @DATA(lt_stok).

  LOOP AT gt_data INTO gs_data.

    READ TABLE lt_stok INTO DATA(ls_stok) WITH KEY matnr = gs_data-matnr
                                                   werks = gs_data-werks
                                                   lgort = gs_data-lgort
                                                   charg = gs_data-charg.

    IF ls_stok-mail = abap_true.
      gs_data-light = gc_icon_green.
    ELSE.
      gs_data-light = gc_icon_yellow.
    ENDIF.

    gs_data-clabs2 = ls_stok-clabs.

    IF gs_data-clabs2 = gs_data-clabs.
      ls_color-color-col = 5.
      ls_color-color-int = 1.
      ls_color-color-inv = 0.
      LOOP AT lt_comp INTO DATA(ls_comp).
        ls_color-fname = ls_comp-compname.
        APPEND ls_color TO lt_color.
      ENDLOOP.
      gs_data-line_color = lt_color.
    ELSE.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      ls_color-color-inv = 0.
      LOOP AT lt_comp INTO ls_comp.
        ls_color-fname = ls_comp-compname.
        APPEND ls_color TO lt_color.
      ENDLOOP.
      gs_data-line_color = lt_color.
    ENDIF.

    MODIFY gt_data FROM gs_data.

    CLEAR: ls_stok,ls_color,lt_color.

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

  IF gt_data[] IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FUNCTIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_functions .

  DATA: lr_functions TYPE REF TO cl_salv_functions_list,
        lv_text      TYPE string,
        lv_tooltip   TYPE string.

  lr_functions = gr_alv->get_functions( ).

  IF pa_chk1 = abap_true.

    lv_text = TEXT-f01.
    lv_tooltip = TEXT-f02.
    TRY.
        lr_functions->add_function(
          EXPORTING
            name     = 'EDIT'
*      icon     =
            text     = lv_text
            tooltip  = lv_tooltip
            position = if_salv_c_function_position=>right_of_salv_functions ).
      CATCH cx_salv_existing cx_salv_wrong_call.
    ENDTRY.

    lv_text = TEXT-f03.
    lv_tooltip = TEXT-f04.
    TRY.
        lr_functions->add_function(
          EXPORTING
            name     = 'SAVE'
*      icon     =
            text     = lv_text
            tooltip  = lv_tooltip
            position = if_salv_c_function_position=>right_of_salv_functions ).
      CATCH cx_salv_existing cx_salv_wrong_call.
    ENDTRY.

  ENDIF.

  lv_text = TEXT-f05.
  lv_tooltip = TEXT-f06.
  TRY.
      lr_functions->add_function(
        EXPORTING
          name     = 'MAIL'
*      icon     =
          text     = lv_text
          tooltip  = lv_tooltip
          position = if_salv_c_function_position=>right_of_salv_functions ).
    CATCH cx_salv_existing cx_salv_wrong_call.
  ENDTRY.

  lr_functions->set_all( if_salv_c_bool_sap=>true ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_COLUMNS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_columns .

  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
        lr_column  TYPE REF TO cl_salv_column_table.

  lr_columns = gr_alv->get_columns( ).
  lr_columns->set_optimize( if_salv_c_bool_sap=>true ).
  lr_columns->set_color_column( 'LINE_COLOR' ).


  TRY.
      lr_column ?= lr_columns->get_column( 'MATNR' ).
      lr_column->set_key( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'WERKS' ).
      lr_column->set_key( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'LGORT' ).
      lr_column->set_key( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CHARG' ).
      lr_column->set_key( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CLABS' ).
      lr_column->set_short_text( 'SAP Stok' ).
      lr_column->set_medium_text( 'SAP Stok' ).
      lr_column->set_long_text( 'SAP Stok' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CLABS2' ).
      lr_column->set_short_text( 'Log Stok' ).
      lr_column->set_medium_text( 'Log Stok' ).
      lr_column->set_long_text( 'Log Stok' ).
      IF pa_chk1 = abap_false.
        lr_column->set_visible( if_salv_c_bool_sap=>false ).
      ENDIF.
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'LIGHT' ).
      lr_column->set_short_text( 'Durum' ).
      lr_column->set_medium_text( 'Durum' ).
      lr_column->set_long_text( 'Durum' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'STOK_TIPI' ).
      lr_column->set_visible( value = if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SELECTIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_selections .

  DATA: lr_selections TYPE REF TO cl_salv_selections.

  lr_selections = gr_alv->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>cell ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_display .

  DATA: lr_display_settings TYPE REF TO cl_salv_display_settings.

  lr_display_settings = gr_alv->get_display_settings( ).
  lr_display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_0100 .
  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.
  PERFORM create_alv.
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

  IF container IS NOT BOUND.

    IF cl_salv_table=>is_offline( ) EQ if_salv_c_bool_sap=>false.
      CREATE OBJECT container
        EXPORTING
          container_name = 'CONTAINER'.
    ENDIF.


    TRY.
        cl_salv_table=>factory(
        EXPORTING
          r_container = container
          container_name = 'CONTAINER'
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table = gt_data ).
      CATCH cx_salv_msg INTO DATA(lv_salv_msg).
        MESSAGE lv_salv_msg TYPE 'E'.
        LEAVE LIST-PROCESSING.
    ENDTRY.

    PERFORM set_functions.

    PERFORM set_columns.

    PERFORM set_selections.

    PERFORM set_display.

    PERFORM set_events.

    gr_alv->display( ).

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXIT_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exit_command .

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
*& Form PAI_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pai_0100 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command  USING i_ucomm TYPE salv_de_function.

  CASE i_ucomm.
    WHEN 'EDIT'.
      PERFORM edit_log_cell.
    WHEN 'SAVE'.
      PERFORM save_log_table.
    WHEN 'MAIL'.
      PERFORM send_mail.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EDIT_LOG_CELL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM edit_log_cell .

  DATA: field         TYPE sval,
        fields        TYPE TABLE OF sval,
        returncode(1),
        ls_color      TYPE lvc_s_scol,
        lt_color      TYPE lvc_t_scol,
        lt_comp       TYPE TABLE OF rstrucinfo.

  CALL FUNCTION 'GET_COMPONENT_LIST'
    EXPORTING
      program    = sy-repid
      fieldname  = 'GS_DATA'
    TABLES
      components = lt_comp.

  DATA(lr_selected) = gr_alv->get_selections( ).
  DATA(lt_rows) = lr_selected->get_selected_rows( ).

  DESCRIBE TABLE lt_rows LINES DATA(lv_rows).

  IF lv_rows = 0.

  ELSEIF lv_rows = 1.

    CLEAR: gs_data, field, fields[].

    READ TABLE lt_rows INTO DATA(ls_rows) INDEX 1.
    READ TABLE gt_data INTO gs_data INDEX ls_rows.

    field-tabname = 'ZOE_SEN_STOKUP'.
    field-fieldname = 'CLABS'.
    field-value = gs_data-clabs2.
    APPEND field TO fields.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
*       NO_VALUE_CHECK  = ' '
        popup_title     = TEXT-p01
*       START_COLUMN    = '5'
*       START_ROW       = '5'
      IMPORTING
        returncode      = returncode
      TABLES
        fields          = fields
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    IF returncode = ''.
      READ TABLE fields INTO field INDEX 1.
      IF sy-subrc = 0.
        gs_data-clabs2 = field-value.
        IF gs_data-clabs2 = gs_data-clabs.
          ls_color-color-col = 5.
          ls_color-color-int = 1.
          ls_color-color-inv = 0.
          LOOP AT lt_comp INTO DATA(ls_comp).
            ls_color-fname = ls_comp-compname.
            APPEND ls_color TO lt_color.
          ENDLOOP.
          gs_data-line_color = lt_color.
        ELSE.
          ls_color-color-col = 6.
          ls_color-color-int = 1.
          ls_color-color-inv = 0.
          LOOP AT lt_comp INTO ls_comp.
            ls_color-fname = ls_comp-compname.
            APPEND ls_color TO lt_color.
          ENDLOOP.
          gs_data-line_color = lt_color.
        ENDIF.
        MODIFY gt_data FROM gs_data INDEX ls_rows.
        gr_alv->refresh( ).
      ENDIF.
    ENDIF.


  ELSE.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_LOG_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_log_table .

  DATA: ls_log_tab LIKE zoe_sen_stokup.

  DATA(lr_selected) = gr_alv->get_selections( ).
  DATA(lt_rows) = lr_selected->get_selected_rows( ).

  DESCRIBE TABLE lt_rows LINES DATA(lv_rows).

  IF lv_rows = 0.

  ELSE.

    LOOP AT lt_rows INTO DATA(ls_rows).
      READ TABLE gt_data INTO gs_data INDEX ls_rows.
      ls_log_tab = CORRESPONDING #( gs_data MAPPING matnr = matnr
                                                    werks = werks
                                                    lgort = lgort
                                                    charg = charg
                                                    clabs = clabs2
                                                    stok_tipi = stok_tipi ).
      MODIFY zoe_sen_stokup FROM ls_log_tab.
      COMMIT WORK AND WAIT.
      CLEAR: gs_data, ls_log_tab.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_events .

  DATA: lcl_event TYPE REF TO gcl_handle_events,
        lr_events TYPE REF TO cl_salv_events_table.

  lr_events = gr_alv->get_event( ).

  CREATE OBJECT lcl_event.

  SET HANDLER lcl_event->on_user_command FOR lr_events.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_MAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM send_mail .

  DATA: ls_log_tab LIKE zoe_sen_stokup,
        lt_mailsub TYPE sodocchgi1,
        lt_mailrec TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE,
        lt_mailtxt TYPE STANDARD TABLE OF soli WITH HEADER LINE.

  SELECT DISTINCT werks
    FROM @gt_data AS g
    INTO TABLE @DATA(lt_werks).

  SELECT z~werks,
         z~email
    FROM zoe_sen_mail_bkm AS z
    INNER JOIN @gt_data AS g ON z~werks = g~werks
    INTO TABLE @DATA(lt_mail).

  IF lt_mail[] IS NOT INITIAL.

  ENDIF.

  DATA(lr_selected) = gr_alv->get_selections( ).
  DATA(lt_rows) = lr_selected->get_selected_rows( ).

  DESCRIBE TABLE lt_rows LINES DATA(lv_rows).

  IF lv_rows = 0.

  ELSE.

    LOOP AT lt_rows INTO DATA(ls_rows).
      READ TABLE gt_data INTO gs_data INDEX ls_rows.
      READ TABLE lt_mail INTO DATA(ls_mail) WITH KEY werks = gs_data-werks.
      IF sy-subrc = 0.
        SELECT SINGLE *
          FROM zoe_sen_stokup
          INTO @ls_log_tab
          WHERE stok_tipi = @gv_num
          AND   matnr     = @gs_data-matnr
          AND   werks     = @gs_data-werks
          AND   lgort     = @gs_data-lgort
          AND   charg     = @gs_data-charg.
        IF sy-subrc <> 0.

        ENDIF.


      ENDIF.


      ls_log_tab = CORRESPONDING #( gs_data MAPPING matnr = matnr
                                                    werks = werks
                                                    lgort = lgort
                                                    charg = charg
                                                    clabs = clabs2
                                                    stok_tipi = stok_tipi ).
      MODIFY zoe_sen_stokup FROM ls_log_tab.
      COMMIT WORK AND WAIT.
      CLEAR: gs_data, ls_log_tab.
    ENDLOOP.

  ENDIF.

ENDFORM.
