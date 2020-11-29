class ZCL_OE_VENDOR_ADD_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_VENDOR_ADD_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_VENDOR_ADD_DATA IMPLEMENTATION.


  METHOD if_ex_vendor_add_data~check_add_on_active.

    IF i_screen_group = 'Z1'.
      e_add_on_active = 'X'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
