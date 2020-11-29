*&---------------------------------------------------------------------*
*& Include          ZEGT00_OE_SENARYO1_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: mchb, mard, makt, t001w, zmb_mm_stokup_oe, zoe_bt1.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: slis, icon.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************
CONSTANTS: gc_green  TYPE icon-id VALUE '@08@',
           gc_yellow TYPE icon-id VALUE '@09@',
           gc_red    TYPE icon-id VALUE '@0A@'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gv_num TYPE numc2.
DATA: gv_num2 TYPE numc2.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: BEGIN OF gs_data,
        matnr         LIKE mchb-matnr,
        maktx         LIKE makt-maktx,
        werks         LIKE mchb-werks,
        name1         LIKE t001w-name1,
        lgort         LIKE mchb-lgort,
        charg         LIKE mchb-charg,
        clabs         LIKE mchb-clabs,
        clabs2        LIKE mchb-clabs,
        light         LIKE icon-id,
        line_color(4) TYPE c,
        box,

      END OF gs_data.

DATA: BEGIN OF gs_werks,
        werks LIKE mchb-werks,
      END OF gs_werks.

DATA: gt_werks LIKE TABLE OF gs_werks WITH HEADER LINE.



DATA: gt_data LIKE TABLE OF gs_data WITH HEADER LINE.


DATA: gs_layout   TYPE slis_layout_alv,
      gt_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.

DATA: gt_mail LIKE TABLE OF zoe_bt1 WITH HEADER LINE ##NEEDED.





DATA: gt_mailsub TYPE sodocchgi1.
DATA: gt_mailrec TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE.
DATA: gt_mailtxt TYPE STANDARD TABLE OF soli WITH HEADER LINE.
************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.
PARAMETERS: pa_rb1 RADIOBUTTON GROUP rbg1 DEFAULT 'X'
                                          USER-COMMAND rbg1,
            pa_rb2 RADIOBUTTON GROUP rbg1,
            pa_rb3 RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: so_matnr FOR mchb-matnr,
                so_werks FOR mchb-werks,
                so_charg FOR mchb-charg MODIF ID gr1,
                so_lgort FOR mard-lgort MODIF ID gr2.
SELECTION-SCREEN END OF BLOCK blk2.

SELECTION-SCREEN BEGIN OF BLOCK blk3 WITH FRAME TITLE TEXT-003.
PARAMETERS: pa_chk1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk3.



************************************************************************
*RANGES                                                                *
************************************************************************
