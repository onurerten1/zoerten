*&---------------------------------------------------------------------*
*& Include          ZOE_SEN01_REV_TOP
*&---------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: mara, mchb, t001w, t001l, zoe_sen_stokup, zoe_sen_mail_bkm.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: icon.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************
CONSTANTS: gc_icon_green    TYPE icon-id VALUE '@08@',
           gc_icon_yellow   TYPE icon-id VALUE '@09@',
           gc_icon_red      TYPE icon-id VALUE '@0A@',
           gc_line_green(4) VALUE 'C510',
           gc_line_red(4)   VALUE 'C610'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gr_alv    TYPE REF TO cl_salv_table,
      container TYPE REF TO cl_gui_custom_container.

DATA: gv_num TYPE numc2.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: BEGIN OF gs_data,
        light      LIKE icon-id,
        matnr      LIKE mchb-matnr,
        maktx      LIKE makt-maktx,
        werks      LIKE mchb-werks,
        name1      LIKE t001w-name1,
        lgort      LIKE mchb-lgort,
        charg      LIKE mchb-charg,
        clabs      LIKE mchb-clabs,
        clabs2     LIKE mchb-clabs,
        line_color TYPE lvc_t_scol,
        stok_tipi  LIKE zoe_sen_stokup-stok_tipi,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.

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
SELECT-OPTIONS: so_matnr FOR mara-matnr,
                so_werks FOR t001w-werks,
                so_charg FOR mchb-charg MODIF ID gr1,
                so_lgort FOR t001l-lgort MODIF ID gr2.
SELECTION-SCREEN END OF BLOCK blk2.

SELECTION-SCREEN BEGIN OF BLOCK blk3 WITH FRAME TITLE TEXT-003.
PARAMETERS: pa_chk1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK blk3.

************************************************************************
*RANGES                                                                *
************************************************************************
