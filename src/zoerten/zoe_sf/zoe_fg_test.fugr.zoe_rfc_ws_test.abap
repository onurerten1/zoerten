FUNCTION zoe_rfc_ws_test.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(ET_MARA) TYPE  MARA
*"----------------------------------------------------------------------

  SELECT SINGLE *
    FROM mara
    INTO CORRESPONDING FIELDS OF @et_mara.

ENDFUNCTION.
