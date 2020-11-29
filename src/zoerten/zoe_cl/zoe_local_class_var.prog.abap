*&---------------------------------------------------------------------*
*& Report ZOE_LOCAL_CLASS_VAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_local_class_var.

DATA: v_imp TYPE i,
      v_cha TYPE i VALUE 100.

CLASS cl_lc DEFINITION.
  PUBLIC SECTION.
    METHODS: display IMPORTING a TYPE i
                     EXPORTING b TYPE i
                     CHANGING  c TYPE i.
ENDCLASS.

CLASS cl_lc IMPLEMENTATION.
  METHOD display.
    b = a + 20.
    c = a + 30.
  ENDMETHOD.
ENDCLASS.

DATA: obj TYPE REF TO cl_lc.

START-OF-SELECTION.
  CREATE OBJECT obj.
  CALL METHOD obj->display
    EXPORTING
      a = 10
    IMPORTING
      b = v_imp
    CHANGING
      c = v_cha.

  WRITE: / 'output', v_imp,
        /
           'changing', v_cha.
