*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************
TABLES: zoe_head_ekko, zoe_item_ekpo.

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
CONSTANTS: gc_data(30) VALUE 'GS_DATA'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************
FIELD-SYMBOLS: <fs1> TYPE STANDARD TABLE,
               <fs2> TYPE any,
               <fs3> TYPE ANY TABLE,
               <fs4> TYPE ANY TABLE.
FIELD-SYMBOLS: <fs_lay>  TYPE lvc_s_layo,
               <fs_grid> TYPE REF TO cl_gui_alv_grid,
               <fs_cont> TYPE REF TO cl_gui_container.
************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: BEGIN OF gs_data_left,
        ebeln    LIKE zoe_head_ekko-ebeln,
        bukrs    LIKE zoe_head_ekko-bukrs,
        bstyp    LIKE zoe_head_ekko-bstyp,
        aedat    LIKE zoe_head_ekko-aedat,
        ernam    LIKE zoe_head_ekko-ernam,
        lifnr    LIKE zoe_head_ekko-lifnr,
        waers    LIKE zoe_head_ekko-waers,
        kunnr    LIKE zoe_head_ekko-kunnr,
        color(4),
      END OF gs_data_left.

DATA: BEGIN OF gs_data_right,
        ebeln      LIKE zoe_item_ekpo-ebeln,
        ebelp      LIKE zoe_item_ekpo-ebelp,
        aedat      LIKE zoe_item_ekpo-aedat,
        matnr      LIKE zoe_item_ekpo-matnr,
        bukrs      LIKE zoe_item_ekpo-bukrs,
        zzcolor    LIKE zoe_item_ekpo-zzcolor,
        cellstyles TYPE lvc_t_styl,
      END OF gs_data_right.

DATA: gt_data_left  LIKE TABLE OF gs_data_left,
      gt_data_right LIKE TABLE OF gs_data_right.

DATA: ok_code LIKE sy-ucomm.

DATA: gt_fcat_left     TYPE TABLE OF slis_fieldcat_alv,
      gt_fieldcat_left TYPE lvc_t_fcat,
      gs_fieldcat_left TYPE lvc_s_fcat,
      gs_layout_left   TYPE lvc_s_layo,
      grid_left        TYPE REF TO cl_gui_alv_grid,
      container_right  TYPE REF TO cl_gui_container.

DATA: gt_fcat_right     TYPE TABLE OF slis_fieldcat_alv,
      gt_fieldcat_right TYPE lvc_t_fcat,
      gs_fieldcat_right TYPE lvc_s_fcat,
      gs_layout_right   TYPE lvc_s_layo,
      gs_cellstyles     TYPE lvc_s_styl,
      grid_right        TYPE REF TO cl_gui_alv_grid,
      container_left    TYPE REF TO cl_gui_container.

DATA: splitter  TYPE REF TO cl_gui_splitter_container.
DATA: gt_exclude TYPE ui_functions.
DATA: main_container TYPE REF TO cl_gui_custom_container.
DATA: gv_check TYPE i.
DATA: gv_grid TYPE REF TO cl_gui_alv_grid.



************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1.
SELECT-OPTIONS: so_ebeln FOR zoe_head_ekko-ebeln,
                so_kunnr FOR zoe_head_ekko-kunnr,
                so_bukrs FOR zoe_head_ekko-bukrs.
SELECTION-SCREEN END OF BLOCK blk1.

************************************************************************
*RANGES                                                                *
************************************************************************
