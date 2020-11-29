*&---------------------------------------------------------------------*
*& Report zoe_class_redef
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_redef.

CLASS cl_super DEFINITION.
  PUBLIC SECTION.
    METHODS: add IMPORTING f_a TYPE i
                           f_b TYPE i
                 EXPORTING f_c TYPE i.
ENDCLASS.

CLASS cl_super IMPLEMENTATION.
  METHOD add.
    f_c = f_a + f_b.
  ENDMETHOD.
ENDCLASS.

CLASS cl_sub DEFINITION INHERITING FROM cl_super.
  PUBLIC SECTION.
    METHODS add REDEFINITION.
ENDCLASS.

CLASS cl_sub IMPLEMENTATION.
  METHOD add.
    DATA: gv_var1 TYPE i,
          gv_var2 TYPE i,
          gv_var3 TYPE i.
    gv_var1 = 10.
    gv_var2 = 20.

    CALL METHOD super->add
      EXPORTING
        f_a = gv_var1
        f_b = gv_var2
      IMPORTING
        f_c = gv_var3.
    f_c = f_a + f_b + gv_var3.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  PARAMETERS: p_a TYPE i,
              p_b TYPE i.

  DATA: gv_add TYPE i,
        gv_sub TYPE i,
        ref1   TYPE REF TO cl_sub.

  CREATE OBJECT ref1.

  CALL METHOD ref1->add
    EXPORTING
      f_a = p_a
      f_b = p_b
    IMPORTING
      f_c = gv_add.

  WRITE : / gv_add.
