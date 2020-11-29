*&---------------------------------------------------------------------*
*& Report zoe_local_classes
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_local_classes.

INITIALIZATION.
CLASS class_a DEFINITION.
  PUBLIC SECTION.
    DATA a TYPE int4 VALUE 40.
    METHODS a1  IMPORTING: num1 TYPE int4
                           num2 TYPE int4.
ENDCLASS.

CLASS class_b DEFINITION INHERITING FROM class_a.
  PUBLIC SECTION.
    DATA b TYPE int4 VALUE 12.
    METHODS a2.
ENDCLASS.


CLASS class_a IMPLEMENTATION.

  METHOD a1.

    a = num1 + num2.
    WRITE a.
  ENDMETHOD.

ENDCLASS.
CLASS class_b IMPLEMENTATION.
  METHOD a2.
    WRITE: 'METHOD A2'.
  ENDMETHOD.
ENDCLASS.
DATA :obj  TYPE REF TO class_a,
      obj2 TYPE REF TO class_b,
      num1 TYPE int4 VALUE 100,
      num2 TYPE int4 VALUE 133.

START-OF-SELECTION.
  CREATE OBJECT obj.
  CALL METHOD obj->a1(
      num1 = num1
      num2 = num2 ).
  CREATE OBJECT obj2.
  CALL METHOD obj2->a2.
  CALL METHOD obj2->a1(
      num1 = num1
      num2 = num2 ).
