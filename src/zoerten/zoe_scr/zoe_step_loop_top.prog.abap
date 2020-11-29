*&---------------------------------------------------------------------*
*& Include          ZOE_STEP_LOOP_TOP
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
DATA: ok_code   LIKE sy-ucomm.
DATA: save_ok   TYPE sy-ucomm.
DATA: gv_status LIKE sy-dynnr.

DATA: fill  TYPE i,
      idx   TYPE i,
      line  TYPE i,
      lines TYPE i,
      limit TYPE i.

"data for screen 0100
DATA: BEGIN OF gs_0100,
        vstel      LIKE likp-vstel,
        wadat_ist  LIKE likp-wadat_ist,
        text01(40),
        text02(40),
      END OF gs_0100.

"data for screen 0101
DATA: BEGIN OF gs_0101,
        p_chk(1),
        vstel    LIKE tvstt-vstel,
        vtext    LIKE tvstt-vtext,
      END OF gs_0101.
DATA: itab LIKE TABLE OF gs_0101 WITH HEADER LINE.
DATA: wa LIKE LINE OF itab.

"data for screen 0200
DATA: BEGIN OF gs_0200,
        chk(1),
        vbeln  LIKE likp-vbeln,
        kunag  LIKE likp-kunag,
        kunnr  LIKE likp-kunnr,
        wadat  LIKE likp-wadat,
      END OF gs_0200.
DATA: itab2 LIKE TABLE OF gs_0200 WITH HEADER LINE.
DATA: wa2 LIKE LINE OF itab2.

"data for screen 0300
DATA: BEGIN OF gs_0300,
        posnr  LIKE lips-posnr,
        matnr  LIKE lips-matnr,
        artktx LIKE lips-arktx,
        lfimg  LIKE lips-lfimg,
        lgort  LIKE lips-lgort,
      END OF gs_0300.
DATA: itab3 LIKE TABLE OF gs_0300 WITH HEADER LINE.
DATA: wa3 LIKE LINE OF itab3.
DATA: gv_vbeln LIKE lips-vbeln.
DATA: gv_text_0300(120).



************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************


************************************************************************
*RANGES                                                                *
************************************************************************
