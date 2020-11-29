class ZCL_OE_VENDOR_ADD_DATA_CS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_VENDOR_ADD_DATA_CS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_VENDOR_ADD_DATA_CS IMPLEMENTATION.


  METHOD if_ex_vendor_add_data_cs~get_taxi_screen.

    BREAK oerten.
    IF flt_val = 'Z1'.
      CASE i_taxi_fcode.
        WHEN 'ZTAB'.
          e_program = 'SAPLFMFG_VENDOR_MASTER_EXT'.
          e_screen = '0116'.
          e_headerscreen_layout = ' '.
*      	WHEN .
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  method IF_EX_VENDOR_ADD_DATA_CS~SET_FCODE.
  endmethod.
ENDCLASS.
