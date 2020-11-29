class ZCL_ZOE_CDS08 definition
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



CLASS ZCL_ZOE_CDS08 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZOE_CDS08| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20200309110044.
  endmethod.
ENDCLASS.
