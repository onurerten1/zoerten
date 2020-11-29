*&---------------------------------------------------------------------*
*& Report ZOE_SCRIPT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_script_test.

DATA: gt_sflight TYPE STANDARD TABLE OF sflight.

INCLUDE zoe_script_test_f01.

START-OF-SELECTION.

  CLEAR: gt_sflight.

  PERFORM select1.

  PERFORM select2.

  PERFORM select3.

  WRITE 'Program Complete'.
