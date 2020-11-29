*&---------------------------------------------------------------------*
*& Report zoe_amdp04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp04.

TABLES: mara.

"PARAMETERS p_matnr type matnr.
SELECT-OPTIONS p_matnr FOR mara-matnr.

DATA: gc_amdp TYPE REF TO zoe_amdp04.

CREATE OBJECT gc_amdp.

DATA(gv_matnr) = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name = 'MATNR' dref  = REF #( p_matnr[] ) ) ) iv_client_field = 'MANDT' ).

CALL METHOD gc_amdp->get_material_info
  EXPORTING
    iv_client = sy-mandt
    iv_matnr  = gv_matnr
  IMPORTING
    et_info   = DATA(lt_mara)
    ev_lang   = DATA(lv_lang).

DELETE ADJACENT DUPLICATES FROM lt_mara.

BREAK-POINT.
