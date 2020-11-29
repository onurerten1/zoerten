class ZLE_SHP_TAB_CUST_OVER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_TAB_CUST_OVER .
protected section.
private section.
ENDCLASS.



CLASS ZLE_SHP_TAB_CUST_OVER IMPLEMENTATION.


  METHOD if_ex_le_shp_tab_cust_over~activate_tab_page.

    ef_caption = 'ATB'.
    ef_position = 7.
    ef_program = 'SAPMZOE_ATB_EKALAN'.
    ef_dynpro = '0100'.

    cs_v50agl_cust = 'X'.


  ENDMETHOD.
ENDCLASS.
