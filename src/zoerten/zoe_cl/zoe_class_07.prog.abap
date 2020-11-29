*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_07.
CLASS super_class DEFINITION.
  PUBLIC SECTION.
    METHODS: addition1 IMPORTING g_a TYPE i
                                 g_b TYPE i
                       EXPORTING g_c TYPE i.
ENDCLASS.
CLASS super_class IMPLEMENTATION.
  METHOD addition1.
    g_c = g_a + g_b.
  ENDMETHOD.
ENDCLASS.
CLASS sub_class DEFINITION INHERITING FROM super_class.
  PUBLIC SECTION.
    METHODS: addition1 REDEFINITION.
ENDCLASS.
CLASS sub_class IMPLEMENTATION.
  METHOD addition1.
    g_c = g_a + g_b + 10.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  PARAMETERS: p_a TYPE i,
              p_b TYPE i.
  DATA: h_addition1 TYPE i.
  DATA: h_sub TYPE i.
  DATA: ref1 TYPE REF TO sub_class.
  CREATE OBJECT ref1.
  CALL METHOD ref1->addition1
    EXPORTING
      g_a = p_a
      g_b = p_b
    IMPORTING
      g_c = h_sub.
  WRITE:/ h_sub.
  DATA: ref2 TYPE REF TO super_class.
  CREATE OBJECT ref2.
  CALL METHOD ref2->addition1
    EXPORTING
      g_a = p_a
      g_b = p_b
    IMPORTING
      g_c = h_addition1.
  WRITE:/ h_addition1.
