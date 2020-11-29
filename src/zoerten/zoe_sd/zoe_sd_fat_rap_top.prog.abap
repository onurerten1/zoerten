*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FAT_RAP_TOP
*&---------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: vbrk, vbrp.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************


************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: go_alv    TYPE REF TO cl_salv_table.
*      container TYPE REF TO cl_gui_custom_container.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: gs_data TYPE zoe_sd_st_fat_rap,
      gt_data LIKE TABLE OF gs_data.

************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME.

SELECT-OPTIONS: so_vkorg FOR vbrk-vkorg,
                so_vtweg FOR vbrk-vtweg,
                so_vstel FOR vbrp-vstel,
                so_fkart FOR vbrk-fkart,
                so_fkdat FOR vbrk-fkdat,
                so_vbeln FOR vbrk-vbeln,
                so_xblnr FOR vbrk-xblnr,
                so_kunrg FOR vbrk-kunrg,
                so_matnr FOR vbrp-matnr,
                so_ernam FOR vbrk-ernam,
                so_erdat FOR vbrk-erdat.



SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_chk AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(40) TEXT-001 FOR FIELD p_chk.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_sub AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(40) TEXT-002 FOR FIELD p_sub.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK blk2.

************************************************************************
*RANGES                                                                *
************************************************************************
