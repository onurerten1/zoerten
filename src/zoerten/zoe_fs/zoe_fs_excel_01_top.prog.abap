*&---------------------------------------------------------------------*
*& Include          ZOE_FS_EXCEL_01_TOP
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

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************
FIELD-SYMBOLS: <gs_line>,
               <gs_line1>,
               <gs_table> TYPE STANDARD TABLE,
               <gs_extab> TYPE STANDARD TABLE,
               <fs>,
               <fs1>.
************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gt_table    TYPE REF TO data,
      gw_line     TYPE REF TO data,
      gw_line1    TYPE REF TO data,
      gt_fieldcat TYPE lvc_t_fcat,
      gw_fieldcat TYPE lvc_s_fcat.

DATA: gt_excel LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE.
DATA: gs_excel LIKE LINE OF gt_excel.

DATA: gt_res LIKE TABLE OF dfies WITH HEADER LINE.

DATA: gv_count LIKE sy-index.
DATA: ok_code LIKE sy-ucomm.

DATA: grid      TYPE REF TO cl_gui_alv_grid,
      container TYPE REF TO cl_gui_custom_container,
      gw_layout TYPE lvc_s_layo.



************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk.
PARAMETERS: p_table TYPE tabname16,
            p_file  TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK blk.
************************************************************************
*RANGES                                                                *
************************************************************************