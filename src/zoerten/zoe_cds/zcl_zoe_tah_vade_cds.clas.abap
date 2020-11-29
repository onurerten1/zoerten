class ZCL_ZOE_TAH_VADE_CDS definition
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



CLASS ZCL_ZOE_TAH_VADE_CDS IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZOE_TAH_VADE_CDS| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20200616061442.
  endmethod.
ENDCLASS.
