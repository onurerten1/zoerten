class ZCL_OE_BADI_MAT_GET definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZOE_IF_BADI_MAT_DET .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_BADI_MAT_GET IMPLEMENTATION.


  METHOD zoe_if_badi_mat_det~get_materials.

    IF matnr IS NOT INITIAL.
      SELECT SINGLE *
        FROM mara
        INTO @mara
        WHERE matnr = @matnr.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
