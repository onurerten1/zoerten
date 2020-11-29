*&---------------------------------------------------------------------*
*& Report ZOE_OBJECT_ALV01
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
  REPORT zoe_object_alv01.
*----------------------------------------------------------------------*
  INCLUDE zoe_object_alv01_top.
  INCLUDE zoe_object_alv01_cls.
  INCLUDE zoe_object_alv01_f01.
  INCLUDE zoe_object_alv01_status_pbo.
  INCLUDE zoe_object_alv01_pai.
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