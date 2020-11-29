FUNCTION zoe_wf_sales_org.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(OBJTYPE) TYPE  SWO_OBJTYP
*"     REFERENCE(OBJKEY) TYPE  SWO_TYPEID
*"     REFERENCE(EVENT) TYPE  SWO_EVENT
*"     REFERENCE(RECTYPE) TYPE  SWE_RECTYP
*"  EXPORTING
*"     REFERENCE(RESULT) TYPE  C
*"  TABLES
*"      EVENT_CONTAINER STRUCTURE  SWCONT
*"  EXCEPTIONS
*"      NOT_TRIGGERED
*"----------------------------------------------------------------------
  TABLES: vbak.
  DATA vkorg LIKE vbak-vkorg.
  SELECT SINGLE vkorg INTO vkorg
     FROM vbak WHERE vbeln = objkey.
  IF vkorg = '1710'.
    RAISE not_triggered.
  ENDIF.
ENDFUNCTION.
