*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_02.

CLASS class1 DEFINITION.

  PUBLIC SECTION.
    DATA: text1 TYPE char25 VALUE 'Public Data'.
    METHODS: meth1.

  PROTECTED SECTION.
    DATA: text2 TYPE char25 VALUE 'Protected Data'.

  PRIVATE SECTION.
    DATA: text3 TYPE char25 VALUE 'Private Data'.

ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD: meth1.
    WRITE:  / 'Public Method',
            / text1,
            / text2,
            / text3.
    SKIP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: objectx TYPE REF TO class1.
  CREATE OBJECT objectx.
  CALL METHOD objectx->meth1.
  WRITE:/ objectx->text1.
