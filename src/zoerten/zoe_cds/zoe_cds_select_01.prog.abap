*&---------------------------------------------------------------------*
*& Report ZOE_CDS_SELECT_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_select_01.

DATA: ls_cds26 LIKE zoe_cds_26,
      lt_cds26 LIKE TABLE OF ls_cds26.

SELECT *
  FROM zoe_cds_26
  INTO TABLE @lt_cds26.

DATA: gs_layout   TYPE slis_layout_alv,
      gt_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE.

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name     = sy-repid
    i_internal_tabname = 'LS_CDS26'
    i_inclname         = sy-repid
  CHANGING
    ct_fieldcat        = gt_fieldcat[].

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_grid_title             = sy-title
    i_callback_program       = sy-repid
    is_layout                = gs_layout
    i_save                   = 'A'
    it_fieldcat              = gt_fieldcat[]
    i_callback_pf_status_set = 'SET_PF_STATUS'
    i_callback_user_command  = 'USER_COMMAND'
  TABLES
    t_outtab                 = lt_cds26.

BREAK-POINT.
