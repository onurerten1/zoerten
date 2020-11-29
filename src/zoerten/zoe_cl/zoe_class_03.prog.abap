*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_03.
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: name1 TYPE char45.
*                data1 TYPE i.
    METHODS: meth1.
ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD meth1.
    DATA: data1 TYPE i.
    DO 4 TIMES.
      data1 = 1 + data1.
      WRITE: / data1, name1.
    ENDDO.
    SKIP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  class1=>name1 = 'ABAP Object Oriented Programming'.
*  class1=>data1 = 0.

  DATA: object1 TYPE REF TO class1,
        object2 TYPE REF TO class1.

  CREATE OBJECT: object1, object2.
  CALL METHOD: object1->meth1,
               object2->meth1.
