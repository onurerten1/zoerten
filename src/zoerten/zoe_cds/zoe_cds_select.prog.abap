*&---------------------------------------------------------------------*
*& Report zoe_cds_select
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_select.

TABLES: mara.

SELECT-OPTIONS: so_matnr FOR mara-matnr.

SELECT *
  FROM zoe_cds_string
  INTO TABLE @DATA(lt_cds)
  WHERE mat_num IN @so_matnr.
