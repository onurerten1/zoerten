*&---------------------------------------------------------------------*
*& Include          ZOE_OBJECT_ALV01_TOP
*&---------------------------------------------------------------------*
TABLES: mard.
DATA: BEGIN OF gs_0100,
        matnr LIKE mard-matnr,
        werks LIKE mard-werks,
        lgort LIKE mard-lgort,
        labst LIKE mard-labst,
        meins LIKE mara-meins,
      END OF gs_0100,
      gt_0100 LIKE TABLE OF gs_0100.

DATA: container   TYPE REF TO cl_gui_custom_container,
      grid        TYPE REF TO cl_gui_alv_grid,
      gt_fcat     TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo.


SELECT-OPTIONS:so_matnr FOR mard-matnr.
