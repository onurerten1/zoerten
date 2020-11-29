*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_01.

DATA: zoe TYPE REF TO zcl_oe_class01.
DATA: text TYPE char10.
DATA: mod_r TYPE i.
PARAMETERS: p_mod TYPE i.

CREATE OBJECT zoe.


ASSIGN zoe->text1 TO FIELD-SYMBOL(<fs1>).
ASSIGN zoe->text2 TO FIELD-SYMBOL(<fs2>).
CALL METHOD zoe->get_text
  EXPORTING
    mod        = p_mod
  IMPORTING
    text3      = text
    mod_result = mod_r
  EXCEPTIONS
    zero_enter = 1.


WRITE:/ <fs1>,
      / <fs2>,
      / text,
      / mod_r.
