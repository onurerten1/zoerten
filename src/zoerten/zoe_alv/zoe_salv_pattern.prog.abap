*&---------------------------------------------------------------------*
*& Report ZOE_SALV_PATTERN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :
* Date              :
*-----------------------------------------------------------------------
*-*
REPORT zoe_salv_pattern.
*----------------------------------------------------------------------*
INCLUDE zoe_salv_pattern_top.
INCLUDE zoe_salv_pattern_cls.
INCLUDE zoe_salv_pattern_f01.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
* PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

*----------------------------------------------------------------------*
*  START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data.

*----------------------------------------------------------------------*
*  END-OF-SELECTION.
*----------------------------------------------------------------------*
END-OF-SELECTION.
  PERFORM list_data.
