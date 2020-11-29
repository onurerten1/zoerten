class ZCL_OE_CLASS_A definition
  public
  create public .

public section.

  data A type INT4 value 40 ##NO_TEXT.

  methods A1
    importing
      !NUM1 type INT4
      !NUM2 type INT4 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_CLASS_A IMPLEMENTATION.


  method A1.


    a = num1 + num2.
    WRITE a.

  endmethod.
ENDCLASS.
