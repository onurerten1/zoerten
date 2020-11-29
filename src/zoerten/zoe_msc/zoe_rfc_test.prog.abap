*&---------------------------------------------------------------------*
*& Report ZOE_RFC_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_rfc_test.

DATA: gt_mara TYPE TABLE OF mara.


CALL FUNCTION 'ZMT_RFC_EXAMPLE' DESTINATION 'MB8'
  IMPORTING
    et_mara = gt_mara.
BREAK-POINT.
