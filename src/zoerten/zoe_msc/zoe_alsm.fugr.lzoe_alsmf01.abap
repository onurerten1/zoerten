*&---------------------------------------------------------------------*
*& Include          LZOE_ALSMF01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SEPARATED_TO_INTERN_CONVERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM separated_to_intern_convert TABLES i_tab       TYPE ty_t_sender
                                        i_intern    TYPE ty_t_itab
                                 USING  i_separator TYPE c.
  DATA: l_sic_tabix LIKE sy-tabix,
        l_sic_col   TYPE kcd_ex_col.
  DATA: l_fdpos     LIKE sy-fdpos.

  REFRESH i_intern.

  LOOP AT i_tab.
    l_sic_tabix = sy-tabix.
    l_sic_col = 0.
    WHILE i_tab CA i_separator.
      l_fdpos = sy-fdpos.
      l_sic_col = l_sic_col + 1.
      PERFORM line_to_cell_separat TABLES i_intern
                                   USING  i_tab l_sic_tabix l_sic_col
                                          i_separator l_fdpos.
    ENDWHILE.
    IF i_tab <> space.
      CLEAR i_intern.
      i_intern-row = l_sic_tabix.
      i_intern-col = l_sic_col + 1.
      i_intern-value = i_tab.
      APPEND i_intern.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SEPARATED_TO_INTERN_CONVERT
*---------------------------------------------------------------------*
FORM line_to_cell_separat TABLES i_intern    TYPE ty_t_itab
                          USING  i_line
                                 i_row       LIKE sy-tabix
                                 ch_cell_col TYPE kcd_ex_col
                                 i_separator TYPE c
                                 i_fdpos     LIKE sy-fdpos.
  DATA: l_string   TYPE ty_s_senderline.
  DATA  l_sic_int  TYPE i.

  CLEAR i_intern.
  l_sic_int = i_fdpos.
  i_intern-row = i_row.
  l_string = i_line.
  i_intern-col = ch_cell_col.
* csv Dateien mit separator in Zelle: --> ;"abc;cd";
  IF ( i_separator = ';' OR  i_separator = ',' ) AND
       l_string(1) = gc_esc.
    PERFORM line_to_cell_esc_sep USING l_string
                                       l_sic_int
                                       i_separator
                                       i_intern-value.
  ELSE.
    IF l_sic_int > 0.
      i_intern-value = i_line(l_sic_int).
    ENDIF.
  ENDIF.
  IF l_sic_int > 0.
    APPEND i_intern.
  ENDIF.
  l_sic_int = l_sic_int + 1.
  i_line = i_line+l_sic_int.
ENDFORM.

*---------------------------------------------------------------------*
FORM line_to_cell_esc_sep USING i_string
                                i_sic_int      TYPE i
                                i_separator    TYPE c
                                i_intern_value TYPE ty_d_itabvalue.
  DATA: l_int         TYPE i,
        l_cell_end(2).
  FIELD-SYMBOLS: <l_cell>.
  l_cell_end = gc_esc.
  l_cell_end+1 = i_separator .

  IF i_string CS gc_esc.
    i_string = i_string+1.
    IF i_string CS l_cell_end.
      l_int = sy-fdpos.
      ASSIGN i_string(l_int) TO <l_cell>.
      i_intern_value = <l_cell>.
      l_int = l_int + 2.
      i_sic_int = l_int.
      i_string = i_string+l_int.
    ELSEIF i_string CS gc_esc.
*     letzte Celle
      l_int = sy-fdpos.
      ASSIGN i_string(l_int) TO <l_cell>.
      i_intern_value = <l_cell>.
      l_int = l_int + 1.
      i_sic_int = l_int.
      i_string = i_string+l_int.
      l_int = strlen( i_string ).
      IF l_int > 0 . MESSAGE x001(kx) . ENDIF.
    ELSE.
      MESSAGE x001(kx) . "was ist mit csv-Format
    ENDIF.
  ENDIF.

ENDFORM.
