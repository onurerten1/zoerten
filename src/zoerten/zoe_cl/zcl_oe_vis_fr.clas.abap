class ZCL_OE_VIS_FR definition
  public
  create public .

public section.

  methods PUBLIC_FR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_VIS_FR IMPLEMENTATION.


  METHOD public_fr.
    DATA: friend TYPE REF TO zcl_oe_visibility.
    CREATE OBJECT friend.
    CALL METHOD friend->private.
  ENDMETHOD.
ENDCLASS.
