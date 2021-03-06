*&---------------------------------------------------------------------*
*& Report ZOE_SEN01_REV
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
  REPORT zoe_sen01_rev.
*----------------------------------------------------------------------*
  INCLUDE zoe_sen01_rev_top.
  INCLUDE zoe_sen01_rev_cls.
  INCLUDE zoe_sen01_rev_f01.
  INCLUDE zoe_sen01_rev_pbo.
  INCLUDE zoe_sen01_rev_pai.

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
    PERFORM screen_loop.
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
