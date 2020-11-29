*&---------------------------------------------------------------------*
*& Report ZOE_DUMMY_METHOD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_dummy_method.

CLASS cl_dummy DEFINITION.
  PUBLIC SECTION.
    METHODS: dummy.
ENDCLASS.
CLASS cl_dummy IMPLEMENTATION.
  METHOD dummy.

  ENDMETHOD.
ENDCLASS.
