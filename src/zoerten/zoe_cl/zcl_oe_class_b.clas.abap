class ZCL_OE_CLASS_B definition
  public
  inheriting from ZCL_OE_CLASS_A
  create public .

public section.

  data B type INT4 value 12 ##NO_TEXT.

  methods A2 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_CLASS_B IMPLEMENTATION.


  method A2.

    WRITE: 'METHOD A2'.

  endmethod.
ENDCLASS.
