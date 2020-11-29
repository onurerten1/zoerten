*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_09.
DATA: object TYPE REF TO zcl_oe_class02.

CREATE OBJECT object.

CALL METHOD object->get_name.
CALL METHOD object->get_date.
CALL METHOD object->zoe_interface~message.

WRITE: / object->text1,
       / object->text2.
