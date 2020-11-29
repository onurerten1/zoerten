*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_06.
CLASS parent DEFINITION.
  PUBLIC SECTION.
    DATA: w_public(25) VALUE 'Public Data'.
    METHODS: parentm.
ENDCLASS.
CLASS child DEFINITION INHERITING FROM parent.
  PUBLIC SECTION.
    METHODS: childm.
ENDCLASS.
CLASS parent IMPLEMENTATION.
  METHOD parentm.
    WRITE: / w_public.
  ENDMETHOD.
ENDCLASS.
CLASS child IMPLEMENTATION.
  METHOD childm.
    SKIP.
    WRITE: / 'Child Class', w_public.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: parent TYPE REF TO parent,
        child  TYPE REF TO child.
  CREATE OBJECT: parent, child.
  CALL METHOD: parent->parentm,
               child->childm,
               child->parentm.
