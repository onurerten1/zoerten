class ZOE_BADI_FALLBACK definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZOE_IF_BADI_FALLBACK .
protected section.
private section.
ENDCLASS.



CLASS ZOE_BADI_FALLBACK IMPLEMENTATION.


  METHOD zoe_if_badi_fallback~add.

    BREAK-POINT.
    result = value1 + value2.

  ENDMETHOD.
ENDCLASS.
