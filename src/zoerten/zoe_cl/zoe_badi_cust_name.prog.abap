*&---------------------------------------------------------------------*
*& Report ZOE_BADI_CUST_NAME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_badi_cust_name.

DATA: gb_cust TYPE REF TO zoe_badi_cust_name,
      ls_kna1 TYPE kna1.

PARAMETERS: p_kunnr LIKE kna1-kunnr.

BREAK oerten.

GET BADI gb_cust.

CALL BADI gb_cust->get_cust_name
  EXPORTING
    i_kunnr = p_kunnr
  CHANGING
    c_kna1  = ls_kna1.
