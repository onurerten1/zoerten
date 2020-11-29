FUNCTION Z_ET00_ORNEK1_FM1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) LIKE  MARA-MATNR
*"     REFERENCE(IS_T001L) LIKE  T001L STRUCTURE  T001L
*"  EXPORTING
*"     REFERENCE(ES_MARD) LIKE  MARD STRUCTURE  MARD
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      DATA_NOT_FOUND
*"----------------------------------------------------------------------

  DATA: lv_subrc LIKE sy-subrc.

  PERFORM get_data USING iv_matnr is_t001l es_mard lv_subrc.
  IF lv_subrc IS NOT INITIAL.
    RAISE data_not_found.
  ENDIF.



ENDFUNCTION.
