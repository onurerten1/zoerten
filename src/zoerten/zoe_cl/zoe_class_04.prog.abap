*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_04.
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS: method1, constructor.
ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD: method1.
    WRITE:/ 'Method1'.
  ENDMETHOD.
  METHOD: constructor.
    WRITE:/'Construcutor Triggerd'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: object1 TYPE REF TO class1.
  CREATE OBJECT object1.
