*&---------------------------------------------------------------------*
*& Include          ZEGT00_DENEME2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: lt_t001      LIKE TABLE OF t001 WITH HEADER LINE,
        lv_field(30).

  DATA: lt_bsid LIKE TABLE OF bsid WITH HEADER LINE.
  DATA: lv_numc(2) TYPE n.

  DATA: BEGIN OF ls_data01,
          bukrs LIKE t001-bukrs,
          mnt01 LIKE bsid-dmbtr,
          mnt02 LIKE bsid-dmbtr,
          mnt03 LIKE bsid-dmbtr,
          mnt04 LIKE bsid-dmbtr,
          mnt05 LIKE bsid-dmbtr,
          mnt06 LIKE bsid-dmbtr,
          mnt07 LIKE bsid-dmbtr,
          mnt08 LIKE bsid-dmbtr,
          mnt09 LIKE bsid-dmbtr,
          mnt10 LIKE bsid-dmbtr,
          mnt11 LIKE bsid-dmbtr,
          mnt12 LIKE bsid-dmbtr,
        END OF ls_data01.
  DATA: lv_total LIKE bsid-dmbtr.


  SELECT * FROM t001 INTO TABLE lt_t001.

  SELECT * FROM bsid INTO TABLE lt_bsid
    UP TO 100 ROWS.

  gt_bsid[] = lt_bsid[].

  LOOP AT lt_bsid.
    CLEAR: gt_data.
    MOVE-CORRESPONDING lt_bsid TO gt_data.
    APPEND gt_data.

    CLEAR: lv_field.
    CONCATENATE 'LS_DATA01-MNT' lt_bsid-budat+4(2) INTO lv_field.
    ASSIGN (lv_field) TO <fs2>.
    ADD lt_bsid-dmbtr TO <fs2>.
  ENDLOOP.

  DO 12 TIMES.
    CLEAR: lv_numc.
    lv_numc = sy-index.
    CONCATENATE 'MNT' lv_numc INTO lv_field.
    ASSIGN COMPONENT lv_field OF STRUCTURE ls_data01 TO <fs3>.
    ADD <fs3> TO lv_total.
  ENDDO.


  LOOP AT lt_t001.
    lv_field = 'LT_T001-BUKRS'.
    ASSIGN (lv_field) TO <fs2>.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SCREEN_LOOP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_loop .






ENDFORM.





*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data .

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-box_fieldname = 'BOX'. "satır seçimi

  gs_variant-report = sy-repid.
  gs_variant-variant = pa_varia.


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_internal_tabname = 'GS_DATA'
      i_inclname         = 'ZEGT00_DENEME2_TOP'
    CHANGING
      ct_fieldcat        = gt_fieldcat[].


  LOOP AT gt_fieldcat.
    CASE gt_fieldcat-fieldname.
      WHEN 'WRBTR'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Gelsin Paralar'.
      WHEN 'WAERS'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat.
  ENDLOOP.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_grid_title             = sy-title
      i_save                   = 'A'
      i_callback_program       = sy-repid
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat[]
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      is_variant               = gs_variant
    TABLES
      t_outtab                 = gt_data.


ENDFORM.


FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'. "double click
      IF rs_selfield-fieldname EQ 'BELNR'.
        CLEAR: gt_data.
        READ TABLE gt_data INDEX rs_selfield-tabindex.
        SET PARAMETER ID 'BLN' FIELD gt_data-belnr.
        SET PARAMETER ID 'BUK' FIELD gt_data-bukrs.
        SET PARAMETER ID 'GJR' FIELD gt_data-gjahr.
        CALL TRANSACTION 'FB03'.  "AND SKIP FIRST SCREEN.
      ENDIF.
    WHEN 'UCOMM1'.
      PERFORM ucomm1.
  ENDCASE.
  rs_selfield-refresh = 'X'.
  rs_selfield-col_stable = 'X'.
  rs_selfield-row_stable = 'X'.
ENDFORM.

FORM set_pf_status USING rt_extab TYPE slis_t_extab.
  DATA: lt_ucomm LIKE TABLE OF sy-ucomm.


  SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form UCOMM1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ucomm1 .

ENDFORM.
