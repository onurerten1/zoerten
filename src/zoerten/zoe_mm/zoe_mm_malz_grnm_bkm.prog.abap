*&---------------------------------------------------------------------*
*& Report ZOE_MM_MALZ_GRNM_BKM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :OERTEN
* Date              :13.04.2020 13:08:11
*-----------------------------------------------------------------------
*-*
  REPORT zoe_mm_malz_grnm_bkm.
*----------------------------------------------------------------------*
  INCLUDE zoe_mm_malz_grnm_bkm_top.
  INCLUDE zoe_mm_malz_grnm_bkm_cls.
  INCLUDE zoe_mm_malz_grnm_bkm_f01.
  INCLUDE zoe_mm_malz_grnm_bkm_pbo.
  INCLUDE zoe_mm_malz_grnm_bkm_pai.

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