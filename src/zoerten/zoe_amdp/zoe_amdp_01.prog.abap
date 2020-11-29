*&---------------------------------------------------------------------*
*& Report zoe_amdp_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp_01.

PARAMETERS: p_matnr TYPE matnr.

DATA: g_amdp1 TYPE REF TO zcl_oe_amdp01,
      gt_mara TYPE TABLE OF mara.

CREATE OBJECT g_amdp1.

CALL METHOD g_amdp1->get_data
  EXPORTING
    im_matnr = p_matnr
  IMPORTING
    et_mara  = gt_mara.

BREAK-POINT.
