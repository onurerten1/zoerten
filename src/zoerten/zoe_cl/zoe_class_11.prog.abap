*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_11.
CLASS employee DEFINITION.
  PUBLIC SECTION.
    METHODS: set_name IMPORTING iv_name TYPE string.
ENDCLASS.
CLASS department DEFINITION FRIENDS employee.
  PRIVATE SECTION.
    DATA: name TYPE string.
ENDCLASS.
CLASS employee IMPLEMENTATION.
  METHOD: set_name.
    DATA: lo_department TYPE REF TO department.
    CREATE OBJECT lo_department.
    lo_department->name = iv_name.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_employee TYPE REF TO employee.
  CREATE OBJECT lo_employee.
  lo_employee->set_name( 'Onur' ).
