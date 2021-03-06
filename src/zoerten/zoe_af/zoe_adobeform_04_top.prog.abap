*&---------------------------------------------------------------------*
*& Include          ZOE_ADOBEFORM_04_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************


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
CONSTANTS: gv_form_name TYPE fpname VALUE 'ZOE_ADOBE_FORM04'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gv_fm_name         TYPE rs38l_fnam,
      gs_fp_docparams    TYPE sfpdocparams,
      gs_fp_outputparams TYPE sfpoutputparams.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk.
PARAMETERS: p_name TYPE name1,
            p_flag TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk.

************************************************************************
*RANGES                                                                *
************************************************************************
