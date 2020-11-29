*&---------------------------------------------------------------------*
*& Include          ZOE_TREE_ALV_TOP
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
DATA: alv_tree        TYPE REF TO cl_gui_alv_tree,
      grid            TYPE REF TO cl_gui_custom_alv_grid,
      container       TYPE REF TO cl_gui_custom_container,
      tree_container  TYPE REF TO cl_gui_container,
      alv_container   TYPE REF TO cl_gui_container,
      gt_fieldcatalog TYPE lvc_t_fcat,
      gs_layout       TYPE lvc_s_layo,
      gt_fieldcat     TYPE lvc_t_fcat,
      gv_toolbar      TYPE REF TO cl_gui_toolbar,
      splitter        TYPE REF TO cl_gui_splitter_container.
DATA: gt_output TYPE zoe_t_tree_alv OCCURS 0,
      gs_output TYPE zoe_t_tree_alv,
      ok_code   LIKE sy-ucomm,
      save_ok   LIKE sy-ucomm.
DATA: BEGIN OF gs_vbap,
        vbeln  LIKE vbap-vbeln,
        posnr  LIKE vbap-posnr,
        matnr  LIKE vbap-matnr,
        arktx  LIKE vbap-arktx,
        kwmeng LIKE vbap-kwmeng,
        meins  LIKE vbap-meins,
      END OF gs_vbap.
DATA: gt_vbap LIKE TABLE OF gs_vbap.
DATA: gt_fcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.


************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************


************************************************************************
*RANGES                                                                *
************************************************************************
