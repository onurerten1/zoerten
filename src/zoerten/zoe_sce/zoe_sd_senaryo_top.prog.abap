*&---------------------------------------------------------------------*
*& Include          ZSS_SD_SENARYO_OE_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: vbak, likp, mara, t001w, vbap, makt, lips, kna1.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: vrm, slis.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.
DATA: gt_tab1 LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE.
TYPES: BEGIN OF gty_record,
         vbeln LIKE gt_tab1-value,
         posnr LIKE gt_tab1-value,
         matnr LIKE gt_tab1-value,
         lgort LIKE gt_tab1-value,
         vrkme LIKE gt_tab1-value,
       END OF gty_record.

TYPES: BEGIN OF gty_record2,
         vbeln LIKE gt_tab1-value,
         posnr LIKE gt_tab1-value,
         matnr LIKE gt_tab1-value,
         lgort LIKE gt_tab1-value,
         meins LIKE gt_tab1-value,
       END OF gty_record2.

************************************************************************
*CONSTANTS                                                             *
************************************************************************

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gt_list  TYPE vrm_values,
      gwa_list TYPE vrm_value.
DATA: gt_values  LIKE TABLE OF dynpread,
      gwa_values LIKE dynpread.
*DATA: gv_selected_value(10) TYPE c.

DATA: BEGIN OF gs_data,
        vbeln         LIKE vbak-vbeln,
*        vbeln_d LIKE likp-vbeln,
        posnr         LIKE vbap-posnr,
*        posnr_d LIKE lips-posnr,
        matnr         LIKE vbap-matnr,
        maktx         LIKE makt-maktx,
        lgort         LIKE vbap-lgort,
        charg         LIKE vbap-charg,
        kwmeng        LIKE vbap-kwmeng,
        kwmeng2       LIKE vbap-kwmeng,
        vrkme         LIKE vbap-vrkme,
        lfimg         LIKE lips-lfimg,
        lfimg2        LIKE lips-lfimg,
        meins         LIKE lips-meins,
        cell          TYPE lvc_t_scol,
        line_color(4) TYPE c,
        box,
      END OF gs_data.

DATA: gt_data LIKE TABLE OF gs_data WITH HEADER LINE.

DATA: gs_layout   TYPE slis_layout_alv,
      gt_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.

DATA: gt_record TYPE TABLE OF gty_record INITIAL SIZE 0
                                        WITH HEADER LINE,
      gs_record LIKE LINE OF gt_record,
      gv_row    TYPE i.

DATA: gt_record2 TYPE TABLE OF gty_record2 INITIAL SIZE 0
                                        WITH HEADER LINE,
      gs_record2 LIKE LINE OF gt_record2,
      gv_row2    TYPE i.

DATA: gv_title TYPE lvc_title.

DATA:   bdcdata LIKE bdcdata OCCURS 0 WITH HEADER LINE.

DATA:   messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
DATA:   result  LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.

DATA:   nodata TYPE c.
DATA:   pa_mode LIKE ctu_params-dismode VALUE 'N'.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_list TYPE c AS LISTBOX VISIBLE LENGTH 20
                                      USER-COMMAND p_list.

SELECT-OPTIONS: so_vb_or FOR vbak-vbeln MODIF ID gr1,
                so_er_or FOR vbak-erdat MODIF ID gr1,
                so_vb_de FOR likp-vbeln MODIF ID gr2,
                so_er_de FOR likp-erdat MODIF ID gr2.
SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: so_matnr FOR mara-matnr.
PARAMETERS: pa_werks TYPE t001w-werks DEFAULT 1710 MODIF ID gr3.
SELECTION-SCREEN END OF BLOCK blk2.

SELECTION-SCREEN BEGIN OF BLOCK blk3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: pa_rb1  RADIOBUTTON GROUP rbg1 DEFAULT 'X'
                                      USER-COMMAND rbg1.
SELECTION-SCREEN COMMENT 3(20) TEXT-004 FOR FIELD pa_rb1.
PARAMETERS: pa_rb2  RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN COMMENT 40(20) TEXT-005 FOR FIELD pa_rb2.
SELECTION-SCREEN END OF LINE.
PARAMETERS: pa_file TYPE rlgrap-filename MODIF ID gr4 OBLIGATORY.
*PARAMETERS: pa_file TYPE ibipparms-path MODIF ID gr4 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blk3.


************************************************************************
*RANGES                                                                *
************************************************************************
