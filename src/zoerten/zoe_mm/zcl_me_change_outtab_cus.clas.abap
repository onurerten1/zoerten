class ZCL_ME_CHANGE_OUTTAB_CUS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_CHANGE_OUTTAB_CUS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ME_CHANGE_OUTTAB_CUS IMPLEMENTATION.


  METHOD if_ex_me_change_outtab_cus~fill_outtab.
BREAK OERTEN.
    IF im_struct_name = 'MEREP_OUTTAB_PURCHDOC'.
      FIELD-SYMBOLS: <fs_tab> TYPE merep_outtab_purchdoc.

      LOOP AT ch_outtab ASSIGNING <fs_tab>.
        <fs_tab>-zztext = 'Test OE'.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
