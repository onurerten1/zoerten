FUNCTION zoe_fiori_fm_ebeveyn_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_EBEVEYN) TYPE  ZOE_FIO_EBEVEYN OPTIONAL
*"  EXPORTING
*"     VALUE(ES_EBEVEYN) TYPE  ZOE_FIO_EBEVEYN
*"----------------------------------------------------------------------

  MODIFY zoe_fio_ebeveyn FROM is_ebeveyn.

ENDFUNCTION.
