*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_05.
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    DATA: text1 TYPE char25 VALUE 'CLASS Attribute'.
    METHODS: method1.
ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD method1.
    DATA: text1 TYPE char25 VALUE 'METHOD Attribute'.
    WRITE: / me->text1,
           / text1.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA objectx TYPE REF TO class1.
  CREATE OBJECT objectx.
  CALL METHOD objectx->method1.
