*&---------------------------------------------------------------------*
*& Report ZOE_ALV_DENEME_SEN
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
  REPORT zoe_alv_deneme_sen.
*----------------------------------------------------------------------*
  INCLUDE zoe_alv_deneme_sen_top.
  INCLUDE zoe_alv_deneme_sen_cls.
  INCLUDE zoe_alv_deneme_sen_f01.
  INCLUDE zoe_alv_deneme_sen_pbo.
  INCLUDE zoe_alv_deneme_sen_pai.

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