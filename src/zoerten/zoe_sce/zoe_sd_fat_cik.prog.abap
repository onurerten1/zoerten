*&---------------------------------------------------------------------*
*& Report ZOE_SD_FAT_CIK
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
REPORT zoe_sd_fat_cik.
*----------------------------------------------------------------------*
INCLUDE zoe_sd_fat_cik_top.
INCLUDE zoe_sd_fat_cik_f01.
INCLUDE ole2incl.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

  IF sy-ucomm = 'FC01'.
    CALL TRANSACTION 'ZOESD01' WITH AUTHORITY-CHECK.
  ENDIF.

  IF sy-ucomm = 'CL1'.
    PERFORM template.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM file_upload.



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
