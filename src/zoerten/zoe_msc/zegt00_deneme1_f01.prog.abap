*&---------------------------------------------------------------------*
*& Include          ZEGT00_DENEME1_F01
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
  DATA: ls_mara LIKE gs_mara.


  gv_int = 13.
  gv_char = '12414.50'.
  gv_dec = 1000 / gv_int + gv_char.



  gs_mara-menge = gv_dec MOD 5.

  ADD 1000 TO gv_dec.
  SUBTRACT 1000 FROM gv_dec.
  DIVIDE gv_dec BY 1000.
  MULTIPLY gv_dec BY 1000.

  gv_date = '20190804'.
  gv_time = '111112'.

  gv_date = sy-datum + 15.
  gv_time = sy-uzeit + 10.

  CONCATENATE gv_char gv_date INTO gv_char
                            SEPARATED BY space.

  CONDENSE gv_char NO-GAPS.

  CLEAR: ls_mara.
  CLEAR: gt_mara[].
  REFRESH gt_mara.
  FREE: gt_mara.

BREAK-POINT.
*  DO 10 TIMES.
  DO .
*    IF ( gv_date EQ sy-datum ) .
    ls_mara-matnr = 'MALZEME1'.
    ls_mara-menge = 4000 / 3.
    ls_mara-meins = 'KG'.
    ls_mara-date = sy-datum.
    ls_mara-int4 = sy-index.
    APPEND ls_mara TO gt_mara.
*    ELSEIF gv_date LT sy-datum.
*    ELSE.
*    ENDIF.

    IF sy-index GE 10.
      EXIT.
    ENDIF.

  ENDDO.

  CASE sy-datum+4(2).
    WHEN '01' OR '03' OR '05'.
    WHEN '02'.
    WHEN OTHERS.
  ENDCASE.


  CASE 'X'.                                                      "radio button da kullanılacak blok
    WHEN gv_char.
    WHEN gv_char2.
    WHEN OTHERS.
  ENDCASE.


  LOOP AT gt_mara INTO ls_mara.
    ls_mara-text1 = sy-uname.
    MODIFY gt_mara FROM ls_mara.
  ENDLOOP.


  LOOP AT gt_mara INTO ls_mara WHERE int4 EQ 4.
    DELETE gt_mara.
  ENDLOOP.

  DELETE gt_mara WHERE int4 EQ 4.



  SELECT matnr meins FROM mara
                     INTO CORRESPONDING FIELDS OF gt_data
                     WHERE matnr IN so_matnr
                     AND mtart EQ 'FERT'.
    APPEND gt_data.
  ENDSELECT.

  SELECT SINGLE * FROM mara INTO CORRESPONDING FIELDS OF gt_data
                  WHERE matnr IN so_matnr
                  AND mtart EQ 'FERT'.

  SELECT matnr meins FROM mara
                     INTO CORRESPONDING FIELDS OF TABLE gt_data
                     WHERE matnr IN so_matnr
                     AND mtart EQ 'FERT'.



  IF sy-subrc IS INITIAL .

  ENDIF.

  SELECT * FROM mseg INTO TABLE gt_mseg
           UP TO 100 ROWS.



  IF sy-subrc IS INITIAL.
*   if gt_mseg[] is not initial.
    SELECT * FROM mkpf INTO TABLE gt_mkpf
             FOR ALL ENTRIES IN gt_mseg
             WHERE mblnr EQ gt_mseg-mblnr
             AND mjahr EQ gt_mseg-mjahr
             AND budat LT sy-datum.
  ENDIF.


  SELECT p~mblnr p~mjahr p~zeile p~bwart
         p~matnr p~werks p~lgort k~budat
         INTO CORRESPONDING FIELDS OF TABLE gt_data2
         FROM mseg AS p INNER JOIN mkpf AS k
         ON p~mblnr EQ k~mblnr
         AND p~mjahr EQ k~mjahr
         WHERE p~matnr IN so_matnr.



  DATA: lv_matnr LIKE mara-matnr,
        ls_t001l LIKE t001l,
        ls_mard  LIKE mard.

  lv_matnr = '22'.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input        = lv_matnr
    IMPORTING
      output       = lv_matnr
    EXCEPTIONS
      length_error = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



  ls_t001l-werks = '9000'.
  ls_t001l-lgort = '171A'.




  CALL FUNCTION 'Z_ET00_ORNEK1_FM1'
    EXPORTING
      iv_matnr       = lv_matnr
      is_t001l       = ls_t001l
    IMPORTING
      es_mard        = ls_mard
*  TABLES
*     et_return      =
    EXCEPTIONS
      data_not_found = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.






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
  DATA: ls_mara LIKE gs_mara.
  DATA: lv_str1(20) TYPE c.

  SORT gt_mara BY matnr DESCENDING date ASCENDING.

  CLEAR ls_mara.
  READ TABLE gt_mara INTO ls_mara WITH KEY matnr = 'MALZEME1'
                                            date = sy-datum
                                      BINARY SEARCH.

  FREE: ra_matnr.

  CLEAR: ra_matnr.
  ra_matnr-sign = 'I'. "E
  ra_matnr-option = 'GT'. " GE LE EQ NE BT CP LT
  ra_matnr-low = 'MALZEME'.
  APPEND ra_matnr.

  CLEAR: ra_matnr.
  ra_matnr-sign = 'I'.
  ra_matnr-option = 'NE'.
  ra_matnr-low = space.
  APPEND ra_matnr.

  CLEAR: ra_matnr.
  ra_matnr-sign = 'E'.
  ra_matnr-option = 'EQ'.
  ra_matnr-low = 'ODUN'.
  APPEND ra_matnr.

  CLEAR: ra_matnr.

  FREE: ra_matnr.



  LOOP AT gt_mara INTO ls_mara WHERE matnr IN ra_matnr.


    "  AND date eq sy-datum.

*  exit.
*  sy-tabix.



*  if sy-tabix ne 1.
*
*
*
*   endif.
*
*
*
*   check sy-tabix ne 1.
*
*
*
*
*   if sy-tabix eq 1.
*     continue.
*     endif.

    WRITE: / ls_mara-int4, ls_mara-matnr, ls_mara-date,
        ls_mara-menge UNIT ls_mara-meins,
        ls_mara-meins.

    CLEAR: lv_str1.
    WRITE: ls_mara-menge TO lv_str1 UNIT ls_mara-meins.
    CONDENSE lv_str1.
    CONCATENATE lv_str1 ls_mara-meins INTO lv_str1 SEPARATED BY space.


  ENDLOOP.

  IF sy-subrc IS INITIAL.

    MESSAGE i899(s1) WITH lv_str1.
*  if sy-subrc eq 0.
*  if sy-subrc = 0.
  ENDIF.


  CASE 'X'.
    WHEN pa_rb1.
    WHEN pa_rb2.
    WHEN pa_rb3.
  ENDCASE.


  WRITE: / sy-uline.


  LOOP AT gt_data2.
    WRITE: / gt_data2-mblnr,
             gt_data2-mjahr,
             gt_data2-zeile,
             gt_data2-bwart,
             gt_data2-matnr,
             gt_data2-werks,
             gt_data2-lgort,
             gt_data2-budat.
  ENDLOOP.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init .

  FREE: so_matnr.

  CLEAR: so_matnr.
  so_matnr-sign = 'I'.
  so_matnr-option = 'GT'.
  so_matnr-low = 'MALZEME'.
  APPEND so_matnr.

  CLEAR: so_matnr.
  so_matnr-sign = 'I'.
  so_matnr-option = 'NE'.
  so_matnr-low = space.
  APPEND so_matnr.

  CLEAR: so_matnr.
  so_matnr-sign = 'E'.
  so_matnr-option = 'EQ'.
  so_matnr-low = 'ODUN'.
  APPEND so_matnr.


ENDFORM.
