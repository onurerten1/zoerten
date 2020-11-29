*&---------------------------------------------------------------------*
*& Report ZOE_TEST_TTTEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_test_tttest.

INCLUDE zoe_test_tttest_top.
INCLUDE zoe_test_tttest_cls.

START-OF-SELECTION.

  BREAK-POINT.
  DATA(lo_class) = NEW class1( ).
  lo_class->get_data( ).
