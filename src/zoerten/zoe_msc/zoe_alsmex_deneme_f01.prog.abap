*&---------------------------------------------------------------------*
*& Include          ZOE_ALSMEX_DENEME_F01
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

  CALL FUNCTION 'ZOE_ALSM_EXT'
    EXPORTING
      filename                = p_file
      i_begin_col             = '1'
      i_begin_row             = '2'
      i_end_col               = '21'
      i_end_row               = '99999'
    TABLES
      intern                  = gt_itab
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  SORT gt_itab BY row col.



ENDFORM.
