class ZCL_IM_OE_BOM_UPDATE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BOM_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_OE_BOM_UPDATE IMPLEMENTATION.


  METHOD if_ex_bom_update~change_at_save.
*    BREAK oerten.
*    IF i_stlal > 1.
*      MESSAGE 'BOM cannot be created' TYPE 'W'.
*    ENDIF.

  ENDMETHOD.


  method IF_EX_BOM_UPDATE~CHANGE_BEFORE_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CHANGE_IN_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CREATE_TREX_CPOINTER.



  endmethod.
ENDCLASS.
