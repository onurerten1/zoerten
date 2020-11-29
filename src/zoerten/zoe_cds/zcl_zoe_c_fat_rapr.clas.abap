class ZCL_ZOE_C_FAT_RAPR definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZOE_C_FAT_RAPR IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZOE_C_FAT_RAPR| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20200619110117.
  endmethod.
ENDCLASS.
