*----------------------------------------------------------------------*
***INCLUDE LZEGT00_ORNEK1F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IV_MATNR
*&      --> IS_T001L
*&      --> LV_SUBRC
*&---------------------------------------------------------------------*
FORM get_data  USING    p_matnr
                        p_t001l TYPE t001l
                        p_mard TYPE mard
                        p_subrc.

  SELECT SINGLE * FROM mard INTO p_mard
                  WHERE matnr EQ p_matnr
                  AND werks EQ p_t001l-werks
                  AND lgort EQ p_t001l-lgort.
  p_subrc = sy-subrc.


ENDFORM.
