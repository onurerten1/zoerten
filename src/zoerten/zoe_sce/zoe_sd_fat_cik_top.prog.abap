*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FAT_CIK_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: sscrfields, vbrk, vbrp, but000, zoe_sd_mt.

************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: icon, slis.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.
TYPES : BEGIN OF ty_t_excel_sample,
          vbeln LIKE zoe_sd_mt-vbeln,
          matnr LIKE zoe_sd_mt-matnr,
          kunag LIKE zoe_sd_mt-kunag,
          fkimg LIKE zoe_sd_mt-fkimg,
          vrkme LIKE zoe_sd_mt-vrkme,
          netwr LIKE zoe_sd_mt-netwr,
          waerk LIKE zoe_sd_mt-waerk,
        END OF ty_t_excel_sample,
        ty_excel_sample TYPE ty_t_excel_sample.

DATA: gt_tab1 LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE.
TYPES: BEGIN OF gty_record,
         vbeln LIKE gt_tab1-value,
         matnr LIKE gt_tab1-value,
         kunag LIKE gt_tab1-value,
         fkimg LIKE gt_tab1-value,
         vrkme LIKE gt_tab1-value,
         netwr LIKE gt_tab1-value,
         waerk LIKE gt_tab1-value,
       END OF gty_record.
DATA: gt_record TYPE TABLE OF gty_record INITIAL SIZE 0
                                        WITH HEADER LINE,
      gs_record LIKE LINE OF gt_record,
      gv_row    TYPE i.

************************************************************************
*CONSTANTS                                                             *
************************************************************************

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gs_functxt_01 TYPE smp_dyntxt.
DATA: BEGIN OF gs_data,
        vbeln LIKE vbrk-vbeln,
        posnr LIKE vbrp-posnr,
        fkdat LIKE vbrk-fkdat,
        fkart LIKE vbrk-fkart,
        matnr LIKE vbrp-matnr,
        arktx LIKE vbrp-arktx,
        kunag LIKE vbrk-kunag,
        name  TYPE string,
        fkimg LIKE vbrp-fkimg,
        vrkme LIKE vbrp-vrkme,
        netwr LIKE vbrp-netwr,
        mwsbp LIKE vbrp-mwsbp,
        waerk LIKE vbrk-waerk,
        box,
      END OF gs_data.

DATA: gt_data LIKE TABLE OF gs_data WITH HEADER LINE.
DATA: gt_data2 LIKE TABLE OF gs_data.

DATA: gs_layout   TYPE slis_layout_alv,
      gt_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.


DATA : lt_excel_format TYPE TABLE OF ty_excel_sample WITH HEADER LINE,
       ls_excel_format TYPE ty_excel_sample.

DATA: excel    TYPE ole2_object,
      workbook TYPE ole2_object,
      sheet    TYPE ole2_object,
      cell     TYPE ole2_object,
      row      TYPE ole2_object,
      font     TYPE ole2_object,
      range    TYPE ole2_object,
      column   TYPE ole2_object.
DATA: i TYPE i.

DATA: sf_name TYPE rs38l_fnam.
DATA: cnt TYPE i.

DATA: gwa_ssfcompop TYPE ssfcompop,
      gwa_control   TYPE ssfctrlop.
DATA: gv_devtype    TYPE rspoptype.
DATA: gv_job_output TYPE ssfcrescl.
DATA: gt_lines      TYPE TABLE OF tline.
DATA: gv_size       TYPE i.






DATA:

  l_fm_name       TYPE rs38l_fnam,
  l_formname      TYPE fpname VALUE 'ZOE_SD_ADF1',
  fp_docparams    TYPE sfpdocparams,
  fp_formoutput   TYPE fpformoutput,
  fp_outputparams TYPE sfpoutputparams.
DATA:
  t_att_content_hex TYPE solix_tab.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.
PARAMETERS: pa_rb1 RADIOBUTTON GROUP rbg1 DEFAULT 'X'
                                          USER-COMMAND rbg1,
            pa_rb2 RADIOBUTTON GROUP rbg1,
            p_file TYPE rlgrap-filename MODIF ID gr1.
SELECTION-SCREEN:
BEGIN OF LINE,
  PUSHBUTTON (20) but1 USER-COMMAND cl1 MODIF ID gr1,
  END OF LINE.
SELECTION-SCREEN END OF BLOCK blk1.


SELECTION-SCREEN BEGIN OF BLOCK blk2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_copy TYPE i.
SELECTION-SCREEN END OF BLOCK blk2.

SELECTION-SCREEN FUNCTION KEY 1.



************************************************************************
*RANGES                                                                *
************************************************************************
