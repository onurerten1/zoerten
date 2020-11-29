*&---------------------------------------------------------------------*
*& Include          SAPMZOE_SD_BP_UPD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form NEW_ENTRY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM new_entry .

  CLEAR gs_ucomm.
  CLEAR gt_ucomm.

  CLEAR: gs_cust_land1,
         gs_cust_regio,
         gs_vendor_land1,
         gs_vendor_regio.

  gs_ucomm = 'NEWEN'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'CHNG'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'DISP'. APPEND gs_ucomm TO gt_ucomm.

  IF p_customer = 'X'.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZOERANGE'
      IMPORTING
        number                  = gs_cust-kunnr
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSEIF p_vendor = 'X'.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '02'
        object                  = 'ZOERANGE'
      IMPORTING
        number                  = gs_vendor-lifnr
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CLEAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear.

  CLEAR gs_ucomm.
  CLEAR gt_ucomm.
  CLEAR gs_cust.
  CLEAR gs_vendor.
  CLEAR: gs_cust_land1,
       gs_cust_regio,
       gs_vendor_land1,
       gs_vendor_regio.
  gv_int = 0.
  LEAVE TO SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change.

  CLEAR gs_ucomm.
  CLEAR gt_ucomm.
  CLEAR: gs_cust_land1,
       gs_cust_regio,
       gs_vendor_land1,
       gs_vendor_regio.

  gs_ucomm = 'NEWEN'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'CHNG'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'DISP'. APPEND gs_ucomm TO gt_ucomm.

  CALL SCREEN '0110' STARTING AT 20 10
                   ENDING AT 60 20.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display.

  CLEAR gs_ucomm.
  CLEAR gt_ucomm.
  CLEAR: gs_cust_land1,
       gs_cust_regio,
       gs_vendor_land1,
       gs_vendor_regio.

  gs_ucomm = 'NEWEN'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'CHNG'. APPEND gs_ucomm TO gt_ucomm.
  gs_ucomm = 'DISP'. APPEND gs_ucomm TO gt_ucomm.

  CALL SCREEN '0110' STARTING AT 20 10
                     ENDING AT 60 20.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  CUST_LAND1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE cust_land1 INPUT.

  SELECT DISTINCT t005s~land1 t005t~landx FROM t005s
    INNER JOIN t005t ON t005s~land1 EQ t005t~land1
    INTO TABLE it_land1
    WHERE spras EQ sy-langu.

  SORT it_land1.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_CUST-LAND1'
      value_org       = 'S'
    TABLES
      value_tab       = it_land1
      return_tab      = it_return1
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_land1 WITH KEY landx = it_return1-fieldval.
  gs_cust-land1 = it_land1-land1.

  gs_cust_land1 = it_return1-fieldval.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CUST_REGIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE cust_regio INPUT.

  SELECT DISTINCT t005u~bland, t005u~bezei
    FROM t005u
      INTO TABLE @it_bland
      WHERE t005u~land1 EQ @gs_cust-land1
      AND spras EQ @sy-langu.

  SORT it_bland BY  bland bezei.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_CUST-REGIO'
      value_org       = 'S'
    TABLES
      value_tab       = it_bland
      return_tab      = it_return2
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_bland WITH KEY bezei = it_return2-fieldval.
  gs_cust-regio = it_bland-bland.

  gs_cust_regio = it_return2-fieldval.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VENDOR_LAND1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE vendor_land1 INPUT.

  SELECT DISTINCT t005s~land1 t005t~landx FROM t005s
    INNER JOIN t005t ON t005s~land1 EQ t005t~land1
    INTO TABLE it_land1
    WHERE spras EQ sy-langu.

  SORT it_land1.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_VENDOR-LAND1'
      value_org       = 'S'
    TABLES
      value_tab       = it_land1
      return_tab      = it_return1
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_land1 WITH KEY landx = it_return1-fieldval.
  gs_vendor-land1 = it_land1-land1.

  gs_vendor_land1 = it_return1-fieldval.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VENDOR_REGIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE vendor_regio INPUT.

  SELECT DISTINCT t005u~bland, t005u~bezei
    FROM t005u
      INTO TABLE @it_bland
      WHERE t005u~land1 EQ @gs_vendor-land1
      AND spras EQ @sy-langu.

  SORT it_bland BY  bland bezei.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_VENDOR-REGIO'
      value_org       = 'S'
    TABLES
      value_tab       = it_bland
      return_tab      = it_return2
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_bland WITH KEY bezei = it_return2-fieldval.
  gs_vendor-regio = it_bland-bland.

  gs_vendor_regio = it_return2-fieldval.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save.

  DATA: ls_save LIKE zoe_sd_bp_upd.

  IF p_customer = 'X'.
    ls_save-cust_vend_no = gs_cust-kunnr.
*    ls_save-name1 = gs_cust-name1.
*    ls_save-name2 = gs_cust-name2.
*    ls_save-land1 = gs_cust-land1.
*    ls_save-regio = gs_cust-regio.
*    ls_save-telf1 = gs_cust-telf1.
*    ls_save-adrnr = gs_cust-adrnr.
    ls_save-zztype = 'C'.
    MOVE-CORRESPONDING gs_cust TO ls_save.
    MODIFY zoe_sd_bp_upd FROM ls_save.
  ELSEIF p_vendor = 'X'.
    ls_save-cust_vend_no = gs_vendor-lifnr.
    MOVE-CORRESPONDING gs_vendor TO ls_save.
*    ls_save-name1 = gs_vendor-name1.
*    ls_save-name2 = gs_vendor-name2.
*    ls_save-land1 = gs_vendor-land1.
*    ls_save-regio = gs_vendor-regio.
*    ls_save-telf1 = gs_vendor-telf1.
*    ls_save-adrnr = gs_vendor-adrnr.
    ls_save-zztype = 'V'.

    MODIFY zoe_sd_bp_upd FROM ls_save.
  ENDIF.

  IF sy-subrc = 0.
    MESSAGE TEXT-s01 TYPE 'S'.
  ELSE.
    MESSAGE TEXT-e01 TYPE 'E'.
  ENDIF.

  CLEAR: gs_cust, gs_vendor.
  PERFORM new_entry.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  KUNNR_SH  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE kunnr_sh INPUT.

  SELECT  name1, name2, cust_vend_no FROM zoe_sd_bp_upd
    INTO TABLE @DATA(it_kunnr)
    WHERE zztype = 'C'.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_CUST-KUNNR'
      value_org       = 'S'
    TABLES
      value_tab       = it_kunnr
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  gs_cust-kunnr = it_return-fieldval.
  CLEAR it_return[].

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  LIFNR_SH  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE lifnr_sh INPUT.

  SELECT name1, name2, cust_vend_no FROM zoe_sd_bp_upd
    INTO TABLE @DATA(it_lifnr)
    WHERE zztype = 'V'.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GS_VENDOR-LIFNR'
      value_org       = 'S'
    TABLES
      value_tab       = it_lifnr
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  gs_vendor-lifnr = it_return-fieldval.
  CLEAR it_return[].

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form REPORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM report.

  IF p_customer = 'X'.

    gv_cv = TEXT-c01.
    gv_names = TEXT-c02.

    SELECT cust_vend_no AS number,
           ( name1 && ' ' && name2 ) AS names,
           telf1,
           adrnr
      FROM zoe_sd_bp_upd
      INTO CORRESPONDING FIELDS OF TABLE @gt_tabc
      WHERE zztype = 'C'.

    SELECT cust_vend_no AS number,
           ( name1 && ' ' && name2 ) AS names,
           telf1,
           adrnr
      FROM zoe_sd_bp_upd
      INTO CORRESPONDING FIELDS OF TABLE @itab[]
      WHERE zztype = 'C'.

  ELSEIF p_vendor = 'X'.

    gv_cv = TEXT-v01.
    gv_names = TEXT-v02.

    SELECT cust_vend_no AS number,
            ( name1 && ' ' && name2 ) AS names,
            telf1,
            adrnr
        FROM zoe_sd_bp_upd
        INTO CORRESPONDING FIELDS OF TABLE @gt_tabc
        WHERE zztype = 'V'.

    SELECT cust_vend_no AS number,
          ( name1 && ' ' && name2 ) AS names,
            telf1,
            adrnr
         FROM zoe_sd_bp_upd
         INTO CORRESPONDING FIELDS OF TABLE @itab[]
         WHERE zztype = 'V'.

  ENDIF.

  SORT gt_tabc[].
  SORT itab[].

  fill = lines( itab ).

  CALL SCREEN '0200'.
ENDFORM.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
FORM user_ok_tc USING    p_tc_name TYPE dynfnam
                         p_table_name
                         p_mark_name
                CHANGING p_ok      LIKE sy-ucomm.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA: l_ok     TYPE sy-ucomm,
        l_offset TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
  SEARCH p_ok FOR p_tc_name.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  l_offset = strlen( p_tc_name ) + 1.
  l_ok = p_ok+l_offset.
*&SPWIZARD: execute general and TC specific operations                 *
  CASE l_ok.
    WHEN 'INSR'.                      "insert row
      PERFORM fcode_insert_row USING    p_tc_name
                                        p_table_name.
      CLEAR p_ok.

    WHEN 'DELE'.                      "delete row
      PERFORM fcode_delete_row USING    p_tc_name
                                        p_table_name
                                        p_mark_name.
      CLEAR p_ok.

    WHEN 'P--' OR                     "top of list
         'P-'  OR                     "previous page
         'P+'  OR                     "next page
         'P++'.                       "bottom of list
      PERFORM compute_scrolling_in_tc USING p_tc_name
                                            l_ok.
      CLEAR p_ok.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
    WHEN 'MARK'.                      "mark all filled lines
      PERFORM fcode_tc_mark_lines USING p_tc_name
                                        p_table_name
                                        p_mark_name   .
      CLEAR p_ok.

    WHEN 'DMRK'.                      "demark all filled lines
      PERFORM fcode_tc_demark_lines USING p_tc_name
                                          p_table_name
                                          p_mark_name .
      CLEAR p_ok.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

  ENDCASE.

ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_insert_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_lines_name       LIKE feld-name.
  DATA l_selline          LIKE sy-stepl.
  DATA l_lastline         TYPE i.
  DATA l_line             TYPE i.
  DATA l_table_name       LIKE feld-name.
  FIELD-SYMBOLS <tc>                 TYPE cxtab_control.
  FIELD-SYMBOLS <table>              TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lines>              TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_lines_name.
  ASSIGN (l_lines_name) TO <lines>.

*&SPWIZARD: get current line                                           *
  GET CURSOR LINE l_selline.
  IF sy-subrc <> 0.                   " append line to table
    l_selline = <tc>-lines + 1.
*&SPWIZARD: set top line                                               *
    IF l_selline > <lines>.
      <tc>-top_line = l_selline - <lines> + 1 .
    ELSE.
      <tc>-top_line = 1.
    ENDIF.
  ELSE.                               " insert line into table
    l_selline = <tc>-top_line + l_selline - 1.
    l_lastline = <tc>-top_line + <lines> - 1.
  ENDIF.
*&SPWIZARD: set new cursor line                                        *
  l_line = l_selline - <tc>-top_line + 1.

*&SPWIZARD: insert initial line                                        *
  INSERT INITIAL LINE INTO <table> INDEX l_selline.
  <tc>-lines = <tc>-lines + 1.
*&SPWIZARD: set cursor                                                 *
  SET CURSOR LINE l_line.

ENDFORM.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_delete_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name
                       p_mark_name   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
  DESCRIBE TABLE <table> LINES <tc>-lines.

  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    IF <mark_field> = 'X'.
      DELETE <table> INDEX syst-tabix.
      IF sy-subrc = 0.
        <tc>-lines = <tc>-lines - 1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
FORM compute_scrolling_in_tc USING    p_tc_name
                                      p_ok.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_tc_new_top_line     TYPE i.
  DATA l_tc_name             LIKE feld-name.
  DATA l_tc_lines_name       LIKE feld-name.
  DATA l_tc_field_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <lines>      TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.
*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_tc_lines_name.
  ASSIGN (l_tc_lines_name) TO <lines>.


*&SPWIZARD: is no line filled?                                         *
  IF <tc>-lines = 0.
*&SPWIZARD: yes, ...                                                   *
    l_tc_new_top_line = 1.
  ELSE.
*&SPWIZARD: no, ...                                                    *
    CALL FUNCTION 'SCROLLING_IN_TABLE'
      EXPORTING
        entry_act      = <tc>-top_line
        entry_from     = 1
        entry_to       = <tc>-lines
        last_page_full = 'X'
        loops          = <lines>
        ok_code        = p_ok
        overlapping    = 'X'
      IMPORTING
        entry_new      = l_tc_new_top_line
      EXCEPTIONS
*       NO_ENTRY_OR_PAGE_ACT  = 01
*       NO_ENTRY_TO    = 02
*       NO_OK_CODE_OR_PAGE_GO = 03
        OTHERS         = 0.
  ENDIF.

*&SPWIZARD: get actual tc and column                                   *
  GET CURSOR FIELD l_tc_field_name
             AREA  l_tc_name.

  IF syst-subrc = 0.
    IF l_tc_name = p_tc_name.
*&SPWIZARD: et actual column                                           *
      SET CURSOR FIELD l_tc_field_name LINE 1.
    ENDIF.
  ENDIF.

*&SPWIZARD: set the new top line                                       *
  <tc>-top_line = l_tc_new_top_line.


ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_mark_lines USING p_tc_name
                               p_table_name
                               p_mark_name.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = 'X'.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_demark_lines USING p_tc_name
                                 p_table_name
                                 p_mark_name .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = space.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines
*&---------------------------------------------------------------------*
*& Form SAVE_200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_200.

  DATA: ls_save_tab LIKE zoe_sd_bp_upd.

  LOOP AT gt_tabc WHERE flg = 'X'.

    SELECT SINGLE name1 name2 land1 regio zztype
      FROM zoe_sd_bp_upd
      INTO CORRESPONDING FIELDS OF ls_save_tab
      WHERE cust_vend_no = gt_tabc-number.

    ls_save_tab-cust_vend_no = gt_tabc-number.
    ls_save_tab-telf1 = gt_tabc-telf1.
    ls_save_tab-adrnr = gt_tabc-adrnr.

    MOVE-CORRESPONDING ls_save_tab TO zoe_sd_bp_upd.
    MODIFY zoe_sd_bp_upd.
    COMMIT WORK AND WAIT.

    IF sy-subrc = 0.
      MESSAGE TEXT-s03 TYPE 'S'.
    ELSE.
      MESSAGE TEXT-e03 TYPE 'E'.
    ENDIF.

  ENDLOOP.

  PERFORM report.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM deletion .

  DATA: ls_del LIKE zoe_sd_bp_upd.

  LOOP AT gt_tabc WHERE flg = 'X'.

    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_del
      FROM zoe_sd_bp_upd
      WHERE cust_vend_no = gt_tabc-number.

    DELETE zoe_sd_bp_upd FROM ls_del.
    DELETE gt_tabc.

    IF sy-subrc = 0.
      MESSAGE TEXT-s04 TYPE 'S'.
    ELSE.
      MESSAGE TEXT-e04 TYPE 'E'.
    ENDIF.

  ENDLOOP.

  PERFORM report.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module TRANSP_ITAB_OUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE transp_itab_out OUTPUT.
  idx = sy-stepl + line.

  IF idx GT fill.
  ELSE.
*    READ TABLE itab INTO wa INDEX idx.
    wa = itab[ idx ].
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANSP_ITAB_IN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE transp_itab_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY itab FROM wa INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form NEXT_SL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM next_sl .
  line = line + lines.
  limit = fill - lines.
  IF line > limit.
    line = limit.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREV_SL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prev_sl .
  line = line - lines.
  IF line < 0.
    line = 0.
  ENDIF.
ENDFORM.
