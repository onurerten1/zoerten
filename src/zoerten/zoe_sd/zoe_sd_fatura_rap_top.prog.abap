*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FATURA_RAP_TOP
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
DATA: go_alv TYPE REF TO cl_salv_gui_table_ida.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME.
SELECT-OPTIONS: s_vkorg FOR vbrk-vkorg,
                s_vtweg FOR vbrk-vtweg,
                s_vstel FOR vbrp-vstel,
                s_fkart FOR vbrk-fkart,
                s_fkdat FOR vbrk-fkdat,
                s_vbeln FOR vbrk-vbeln,
                s_xblnr FOR vbrk-xblnr,
                s_kunrg FOR vbrk-kunrg,
                s_matnr FOR vbrp-matnr,
                s_ernam FOR vbrk-ernam,
                s_erdat FOR vbrk-erdat.
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
