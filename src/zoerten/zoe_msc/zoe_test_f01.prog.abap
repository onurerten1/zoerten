*&---------------------------------------------------------------------*
*& Include          ZOE_TEST_F01
*&---------------------------------------------------------------------*


SELECT * FROM mara
  INTO TABLE @DATA(gt_data)
  UP TO 50 ROWS.

DATA ls_data LIKE LINE OF gt_data.
DATA ls_text TYPE string.

LOOP AT gt_data INTO ls_data.
  CONCATENATE 'Malzeme:' ls_data-matnr INTO ls_text SEPARATED BY space.
  WRITE:/ ls_text.
ENDLOOP.
