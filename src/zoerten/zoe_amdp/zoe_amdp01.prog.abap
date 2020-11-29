*&---------------------------------------------------------------------*
*& Report ZOE_AMDP01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp01.

PARAMETERS: p_matnr TYPE matnr.

DATA: r_amdp  TYPE REF TO zoe_amdp01,
      et_mara TYPE TABLE OF mara,
      r_salv  TYPE REF TO cl_salv_table.

CREATE OBJECT r_amdp.

r_amdp->my_method(
  EXPORTING
    im_matnr = p_matnr
  IMPORTING
    et_mara  = et_mara
).

TRY .
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = r_salv
      CHANGING
        t_table      = et_mara.
  CATCH cx_salv_msg.
ENDTRY.

r_salv->display( ).
