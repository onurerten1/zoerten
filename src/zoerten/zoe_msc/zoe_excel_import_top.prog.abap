*&---------------------------------------------------------------------*
*& Include          ZOE_EXCEL_IMPORT_TOP
*&---------------------------------------------------------------------*
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


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gv_rc          TYPE i,
      gt_file        TYPE filetable,
      gv_user_action TYPE i.

DATA: BEGIN OF gs_sheet,
        a TYPE string,
        b TYPE string,
        c TYPE string,
        d TYPE string,
        e TYPE string,
        f TYPE string,
        g TYPE string,
        h TYPE string,
        i TYPE string,
        j TYPE string,
        k TYPE string,
        l TYPE string,
        m TYPE string,
        n TYPE string,
        o TYPE string,
        p TYPE string,
        q TYPE string,
        r TYPE string,
        s TYPE string,
        t TYPE string,
        u TYPE string,
        v TYPE string,
        w TYPE string,
        x TYPE string,
        y TYPE string,
        z TYPE string,
      END OF gs_sheet,
      gt_sheet LIKE TABLE OF gs_sheet.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
PARAMETERS:p_file TYPE string.

************************************************************************
*RANGES                                                                *
************************************************************************
