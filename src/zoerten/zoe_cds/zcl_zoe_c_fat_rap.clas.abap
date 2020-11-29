class ZCL_ZOE_C_FAT_RAP definition
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



CLASS ZCL_ZOE_C_FAT_RAP IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZOE_C_FAT_RAP| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20200617102551.
  endmethod.
ENDCLASS.
