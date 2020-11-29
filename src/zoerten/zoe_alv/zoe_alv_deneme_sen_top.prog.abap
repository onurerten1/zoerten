*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_DENEME_SEN_TOP
*&---------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: mkpf.

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
CONSTANTS: gc_top         LIKE trdir-name
           VALUE 'ZOE_ALV_DENEME_SEN_TOP',
           gc_form_etiket TYPE fpname
           VALUE 'ZOE_AF_ETIKET'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************
FIELD-SYMBOLS: <fs_tab>  TYPE STANDARD TABLE,           "Table
               <fs_str>  TYPE any,                      "Structure
               <fs_fcs>  TYPE ANY TABLE,                "Fieldcat slis
               <fs_fcl>  TYPE lvc_t_fcat,               "Fieldcat lvc
               <fs_fcls> TYPE lvc_s_fcat.               "Fieldcat str
FIELD-SYMBOLS: <fs_lay>  TYPE lvc_s_layo,               "Layout lvc
               <fs_grid> TYPE REF TO cl_gui_alv_grid,   "Grid
               <fs_cont> TYPE REF TO cl_gui_container.  "Container

************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: ok_code LIKE sy-ucomm.

*Splitter Declarations
DATA: container TYPE REF TO cl_gui_custom_container,
      splitter  TYPE REF TO cl_gui_splitter_container.

*Top ALV Declarations
DATA: container_top   TYPE REF TO cl_gui_container,
      grid_top        TYPE REF TO cl_gui_alv_grid,
      gt_fcat_top     TYPE TABLE OF slis_fieldcat_alv,
      gs_fieldcat_top TYPE lvc_s_fcat,
      gt_fieldcat_top TYPE lvc_t_fcat,
      gs_layout_top   TYPE lvc_s_layo.

*Bottom ALV Declarations
DATA: container_bottom   TYPE REF TO cl_gui_container,
      grid_bottom        TYPE REF TO cl_gui_alv_grid,
      gt_fcat_bottom     TYPE TABLE OF slis_fieldcat_alv,
      gs_fieldcat_bottom TYPE lvc_s_fcat,
      gt_fieldcat_bottom TYPE lvc_t_fcat,
      gs_layout_bottom   TYPE lvc_s_layo.

*Adobeform Data Declarations
DATA: gv_fm_name      TYPE funcname,
      gs_fp_docparams TYPE sfpdocparams,
      gs_fp_outparams TYPE sfpoutputparams.


************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
*Top ALV Structure - Table
DATA: BEGIN OF gs_top,
        mblnr LIKE mkpf-mblnr,
        mjahr LIKE mkpf-mjahr,
        blart LIKE mkpf-blart,
        ltext LIKE t003t-ltext,
        bldat LIKE mkpf-bldat,
        budat LIKE mkpf-budat,
        usnam LIKE mkpf-usnam,
        xblnr LIKE mkpf-xblnr,
      END OF gs_top,
      gt_top LIKE TABLE OF gs_top.

*Bottom ALV Structure - Table
DATA: BEGIN OF gs_bottom,
        mblnr LIKE mseg-mblnr,
        mjahr LIKE mseg-mjahr,
        zeile LIKE mseg-zeile,
        bwart LIKE mseg-bwart,
        matnr LIKE mseg-matnr,
        maktx LIKE makt-maktx,
        menge LIKE mseg-menge,
        meins LIKE mseg-meins,
        werks LIKE mseg-werks,
        name1 LIKE t001w-name1,
        lgort LIKE mseg-lgort,
        lgobe LIKE t001l-lgobe,
        charg LIKE mseg-charg,
        lifnr LIKE mseg-lifnr,
        kunnr LIKE mseg-kunnr,
      END OF gs_bottom,
      gt_bottom LIKE TABLE OF gs_bottom.

*Print Structure - Table
DATA: gs_print LIKE zoe_st_etiket,
      gt_print TYPE zoe_tt_etiket.


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: s_mblnr FOR mkpf-mblnr,
                s_mjahr FOR mkpf-mjahr.
SELECTION-SCREEN END OF BLOCK b1.

************************************************************************
*RANGES                                                                *
************************************************************************
