FUNCTION zoe_fiori_fm_ebeveyn_readlist.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_FILTER) TYPE  CHAR40 OPTIONAL
*"  TABLES
*"      ET_EBEVEYN STRUCTURE  ZOE_FIO_EBEVEYN OPTIONAL
*"----------------------------------------------------------------------
  IF ip_filter EQ space.
    ip_filter = '*'.
  ENDIF.
  REPLACE ALL OCCURRENCES OF '*' IN ip_filter WITH '%'.

  SELECT *
      FROM zoe_fio_ebeveyn
      INTO TABLE et_ebeveyn
      WHERE ad LIKE ip_filter
         OR soyad LIKE ip_filter.

  SORT et_ebeveyn ASCENDING BY id.

ENDFUNCTION.
