*&---------------------------------------------------------------------*
*& Include          ZOE_STEP_LOOP_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_VSTEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_vstel .

  SELECT DISTINCT COUNT(*)
    FROM tvstt
    WHERE vstel = gs_0100-vstel.

  IF sy-subrc <> 0.
    gs_0100-text02 = TEXT-e01.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_WADAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_wadat .

  IF gs_0100-wadat_ist IS INITIAL.
    gs_0100-text01 = TEXT-t01.
  ELSE.
    CALL SCREEN 0200.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA_100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_0101 .
  SELECT vstel,
         vtext
    FROM tvstt
    INTO CORRESPONDING FIELDS OF TABLE @itab[]
    WHERE spras EQ @sy-langu.
  SORT itab[] BY vstel.
  fill = lines( itab ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_0100 .

  CLEAR: itab2, itab2[].
  SELECT vbeln,
         kunag,
         kunnr,
         wadat
    FROM likp
    INTO CORRESPONDING FIELDS OF TABLE @itab2[]
    WHERE vstel = @gs_0100-vstel
    AND   wadat_ist = @gs_0100-wadat_ist
    AND   wbstk NE 'C'.
  SORT itab2[] BY vbeln.
  fill = lines( itab2 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_detail .

  CLEAR: gv_vbeln, itab3, itab3[].
  READ TABLE itab2 INTO wa2 WITH KEY chk = 'X'.
  IF sy-subrc <> 0.
*    gs_0100-text01 = TEXT-i03.
  ELSE.
    IF wa2-vbeln IS NOT INITIAL.
      SELECT posnr,
             matnr,
             arktx,
             lfimg,
             lgort
        FROM lips
        INTO TABLE @itab3[]
        WHERE vbeln = @wa2-vbeln.
      SORT itab3[] BY posnr.
      fill = lines( itab3 ).
      gv_vbeln = wa2-vbeln.
    ELSE.
*      gs_0100-text01 = TEXT-i04.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUTTON_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM button_click USING save_ok TYPE sy-ucomm.

  CASE save_ok.
    WHEN 'NEXT_PAGE'.
      line = line + lines.
      limit = fill - lines.
      IF line > limit.
        line = limit.
      ENDIF.
    WHEN 'PREV_PAGE'.
      line = line - lines.
      IF line < 0.
        line = 0.
      ENDIF.
    WHEN 'LAST_PAGE'.
      line =  fill - lines.
    WHEN 'FIRST_PAGE'.
      line = 0.
  ENDCASE.
ENDFORM.
FORM clear_steploop.

  CLEAR:  fill,
          idx,
          line,
          lines,
          limit.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_bapi .

  DATA: vbkok_wa     LIKE vbkok,
        ef_error_any TYPE xfeld,
        prot         LIKE TABLE OF prott,
        ls_mess      LIKE prott,
        lt_mess      LIKE TABLE OF prott WITH HEADER LINE,
        lv_msg(50).
  CLEAR: gv_text_0300.

  vbkok_wa-vbeln_vl = wa2-vbeln.
  vbkok_wa-wabuc = 'X'.

  CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
    EXPORTING
      vbkok_wa     = vbkok_wa
      delivery     = wa2-vbeln
    IMPORTING
      ef_error_any = ef_error_any
    TABLES
      prot         = prot.

  LOOP AT prot INTO ls_mess WHERE msgty CA 'EAX'.
    MOVE-CORRESPONDING ls_mess TO lt_mess.
    APPEND lt_mess.
  ENDLOOP.

  IF ef_error_any IS INITIAL AND lt_mess IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.

  MESSAGE ID lt_mess-msgid TYPE lt_mess-msgty NUMBER lt_mess-msgno
  WITH lt_mess-msgv1 lt_mess-msgv2 lt_mess-msgv3 lt_mess-msgv4
  INTO lv_msg.

  gv_text_0300 = lv_msg.

ENDFORM.
