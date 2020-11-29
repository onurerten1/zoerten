*&---------------------------------------------------------------------*
*& Include          ZEGT00_DENEME2_TOP
*&---------------------------------------------------------------------*




*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: t001, bsid, mara.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: slis.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************
CONSTANTS: gc_bukrs LIKE t001-bukrs VALUE '1000'.

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************
FIELD-SYMBOLS: <fs1> TYPE t001,
               <fs2> TYPE any,
               <fs3> TYPE any.

************************************************************************
*DATA DECLARATION                                                      *
************************************************************************


************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: gt_bsid LIKE TABLE OF bsid WITH HEADER LINE.

DATA: BEGIN OF gs_data,
        bukrs LIKE bsid-bukrs,
        belnr LIKE bsid-belnr,
        gjahr LIKE bsid-gjahr,
        buzei LIKE bsid-buzei,
        wrbtr LIKE bsid-wrbtr,
        waers LIKE bsid-waers,
      END OF gs_data.

DATA: BEGIN OF gt_data OCCURS 0.
    INCLUDE STRUCTURE gs_data.
DATA:box,
     END OF gt_data.

DATA: gs_layout   TYPE slis_layout_alv,
      gs_variant  LIKE disvariant,
      gt_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.



************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECT-OPTIONS: so_matnr FOR mara-matnr.
PARAMETERS: pa_bukrs LIKE t001-bukrs DEFAULT '1000',
            pa_rb1   RADIOBUTTON GROUP rbg1 DEFAULT 'X'
                                            USER-COMMAND rbg1,
            pa_rb2   RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN SKIP.
PARAMETERS: pa_varia LIKE disvariant-variant MEMORY ID var.





************************************************************************
*RANGES                                                                *
************************************************************************
