*&---------------------------------------------------------------------*
*& Report ZOE_BADI_FALLBACK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_badi_fallback.

PARAMETERS: p_value1 TYPE i,
            p_value2 TYPE i.

DATA: handle TYPE REF TO zoe_badi_fallback_def,
      result TYPE i.

BREAK-POINT.
GET BADI handle.

CALL BADI handle->add
  EXPORTING
    value1 = p_value1
    value2 = p_value2
  CHANGING
    result = result.

WRITE: / 'Result : ' , result.
