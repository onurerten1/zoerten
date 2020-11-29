*&---------------------------------------------------------------------*
*& Report ZOE_EXCEL_IMPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :
* Date              :
* Title             :
* Description       :
*----------------------------------------------------------------------*
*-*
  REPORT zoe_excel_import.
**---------------------------------------------------------------------*
  INCLUDE zoe_excel_import_top.
*  INCLUDE _cls.
  INCLUDE zoe_excel_import_f01.
*  INCLUDE _pbo.
*  INCLUDE _pai.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
  INITIALIZATION.
* PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
  AT SELECTION-SCREEN.

  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
    PERFORM get_excel.

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
*PERFORM list_data.