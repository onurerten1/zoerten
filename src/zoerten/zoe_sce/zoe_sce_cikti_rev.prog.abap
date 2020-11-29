*&---------------------------------------------------------------------*
*& Report ZOE_SCE_CIKTI_REV
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
* Description       :ZOE_SD_FAT_CIK revizyon
*----------------------------------------------------------------------*
*-*
REPORT zoe_sce_cikti_rev.
**---------------------------------------------------------------------*
INCLUDE zoe_sce_cikti_rev_top.
INCLUDE zoe_sce_cikti_rev_cls.
INCLUDE zoe_sce_cikti_rev_f01.
*  INCLUDE _pbo.
*  INCLUDE _pai.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'FC01'.
      CALL TRANSACTION 'ZOESD01' WITH AUTHORITY-CHECK.
    WHEN 'PB1'.
      PERFORM template.
    WHEN OTHERS.
  ENDCASE.

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
*PERFORM list_data.
