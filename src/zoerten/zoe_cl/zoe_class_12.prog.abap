*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_12.
INTERFACE inter_1.
  DATA text1 TYPE char35.
  METHODS method1.
ENDINTERFACE.
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES inter_1.
ENDCLASS.
CLASS class2 DEFINITION.
  PUBLIC SECTION.
    INTERFACES inter_1.
ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD inter_1~method1.
    inter_1~text1 = 'Class 1 Interface Method'.
    WRITE / inter_1~text1.
  ENDMETHOD.
ENDCLASS.
CLASS class2 IMPLEMENTATION.
  METHOD inter_1~method1.
    inter_1~text1 = 'Class 2 Interface Method'.
    WRITE / inter_1~text1.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: object1 TYPE REF TO class1,
        object2 TYPE REF TO class2.
  CREATE OBJECT: object1, object2.
  CALL METHOD: object1->inter_1~method1,
               object2->inter_1~method1.
