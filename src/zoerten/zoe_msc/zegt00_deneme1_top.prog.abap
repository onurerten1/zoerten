*&---------------------------------------------------------------------*
*& Include          ZEGT00_DENEME1_TOP
*&---------------------------------------------------------------------*

*data gv_int type i.
*data gv_char(10) type c.
*data gv_dec(7) type p decimals 3.  "2n-1 kuralı n=7
*data gv_date type d.
*data gv_time type t.

TABLES: mara, t001, mseg, mkpf.

TYPES: gty_char(10) TYPE c.

DATA: gv_int      TYPE i,
      gv_char(10) TYPE c,
      gv_dec(7)   TYPE p DECIMALS 3,
      gv_date     TYPE d,
      gv_time     TYPE t.


DATA: gv_int2  TYPE i,
      gv_char2 TYPE adscl,
      gv_dec2  LIKE zegt_malz01-menge,
      gv_date2 LIKE sy-datum,
      gv_time2 LIKE sy-uzeit.

*      gv_char2 TYPE adscl,
*      gv_dec2  TYPE menge_d,
*      gv_date2 LIKE mara-laeda,
*      gv_time2 LIKE sy-uzeit.   "videoda kaydedilmediği için kaybolan blok

DATA: gv_char3 TYPE gty_char.

DATA: BEGIN OF gs_mara,
        matnr LIKE mara-matnr,
        menge LIKE gv_dec2,
        meins LIKE mara-meins,
        int4  LIKE gv_int,
        text1 TYPE gty_char,
        date  TYPE datum.
*        sirket LIKE t001,
    INCLUDE STRUCTURE t001.
DATA:    END OF gs_mara.

DATA: gs_mara2 LIKE mara,
      gs_mara3 LIKE gs_mara.

DATA: gt_mara  LIKE TABLE OF gs_mara,
      gt_mara2 LIKE TABLE OF mara.


SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-h01.
PARAMETERS: "pa_matnr like mara-matnr default 'MALZEME1' OBLIGATORY,
            pa_datum LIKE sy-datum DEFAULT sy-datum.

SELECT-OPTIONS: so_matnr FOR mara-matnr,
                so_bukrs FOR t001-bukrs.

SELECTION-SCREEN END OF BLOCK blk1.


SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_chk1 AS CHECKBOX DEFAULT 'X',
  pa_chk2 AS CHECKBOX,
  pa_chk3 AS CHECKBOX.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_rb1 RADIOBUTTON GROUP rbg1 DEFAULT 'X',
  pa_rb2 RADIOBUTTON GROUP rbg1,
  pa_rb3 RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN SKIP.


PARAMETERS:
  pa_rb4 RADIOBUTTON GROUP rbg2,
  pa_rb5 RADIOBUTTON GROUP rbg2.

RANGES: ra_matnr FOR mara-matnr.


DATA: gt_data LIKE TABLE OF mara WITH HEADER LINE.


DATA: gt_mseg LIKE TABLE OF mseg WITH HEADER LINE,
      gt_mkpf LIKE TABLE OF mkpf WITH HEADER LINE.


DATA: BEGIN OF gs_data2,
        mblnr LIKE mseg-mblnr,
        mjahr LIKE mseg-mjahr,
        zeile LIKE mseg-zeile,
        bwart LIKE mseg-bwart,
        matnr LIKE mseg-matnr,
        werks LIKE mseg-werks,
        lgort LIKE mseg-lgort,
        budat LIKE mkpf-budat,
      END OF gs_data2.

DATA: gt_data2 LIKE TABLE OF gs_data2 WITH HEADER LINE.
