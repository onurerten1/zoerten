*&---------------------------------------------------------------------*
*& Report zoe_cds_knt_report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_knt_report.

TABLES: zmbis_knt_t015,
        likp,
        mara,
        mkpf,
        vbak,
        ekko,
        vbkd,
        lfa1.

DATA: ls_layout   TYPE slis_layout_alv,
      lt_events   TYPE slis_t_event,
      gt_fieldcat TYPE slis_fieldcat_alv OCCURS 1 WITH HEADER LINE,
      ls_header   TYPE slis_t_listheader WITH HEADER LINE,
      alv_list    TYPE slis_t_listheader.
DATA: g_repid   LIKE sy-repid.
DATA: g_repidin LIKE sy-repid.
DATA: g_tabname(30).

DATA: BEGIN OF it_000 OCCURS 0.
        INCLUDE STRUCTURE zmbis_knt_t015 .
        DATA: selkz TYPE char01.
DATA: lv_sayi TYPE i.
DATA: wadat_ist LIKE likp-wadat_ist,
      lfimg     LIKE lips-lfimg,
      tolerans  LIKE lips-lfimg,
*      kunrg     LIKE zcm_knt01,
      vrkme     LIKE lips-vrkme,
      auart     LIKE vbak-auart,
      name1     LIKE kna1-name1,
      name2     LIKE lfa1-name1,
*      name3     LIKE kna1-name1,
      maktx     LIKE makt-maktx,
      netagr    LIKE zmbis_knt_t015-zztartim1,
      bzirk     LIKE vbkd-bzirk.
DATA: END OF it_000.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME.
SELECT-OPTIONS: s_fisno FOR zmbis_knt_t015-zzkntfis ,
                s_zgckf FOR zmbis_knt_t015-zzgckfis,
                s_durum FOR zmbis_knt_t015-zzdurum.
SELECTION-SCREEN SKIP.
SELECT-OPTIONS: s_bukrs    FOR zmbis_knt_t015-bukrs,
                s_werks    FOR zmbis_knt_t015-werks,
                ssurecno   FOR zmbis_knt_t015-zzsurecno ,
                s_istip    FOR zmbis_knt_t015-zzislemtip,
                s_plaka    FOR zmbis_knt_t015-zzplaka.
SELECTION-SCREEN SKIP.
SELECT-OPTIONS: s_girdat   FOR zmbis_knt_t015-zzgtarih,
                s_gsaat    FOR zmbis_knt_t015-zzgsaat ,
                s_cikdat   FOR zmbis_knt_t015-zzctarih,
                s_csaat    FOR zmbis_knt_t015-zzcsaat ,
                s_wadat    FOR likp-wadat_ist,
                s_kant1    FOR zmbis_knt_t015-zzkntno  ,
                s_kant2    FOR zmbis_knt_t015-zzkntno2 ,
                s_sipno    FOR vbak-vbeln ,
                s_ebeln    FOR ekko-ebeln ,
                s_tesno    FOR likp-vbeln,
                s_mblnr    FOR mkpf-mblnr,
                s_matnr    FOR mara-matnr ,
                s_lifnr    FOR lfa1-lifnr,
                s_kunnr    FOR vbak-kunnr,
                s_bzirk    FOR vbkd-bzirk.
SELECTION-SCREEN END OF BLOCK bl1.

START-OF-SELECTION.

  g_repid = sy-repid.
  g_repidin = g_repid.

  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE @it_000
  FROM zoe_cds_knt
  WHERE zzdurum    IN @s_durum
  AND   zzkntfis   IN @s_fisno
  AND   bukrs      IN @s_bukrs
  AND   werks      IN @s_werks
  AND   zzsurecno  IN @ssurecno
  AND   zzislemtip IN @s_istip
  AND   zzgtarih   IN @s_girdat
  AND   zzcsaat    IN @s_csaat
  AND   zzgsaat    IN @s_gsaat
  AND   zzctarih   IN @s_cikdat
  AND   zzkntno    IN @s_kant1
  AND   zzkntno2   IN @s_kant2
  AND   zzplaka    IN @s_plaka
  AND   zzsatisno  IN @s_sipno
  AND   zzsasno    IN @s_ebeln
  AND   zztesno    IN @s_tesno
  AND   mblnr      IN @s_mblnr
  AND   matnr      IN @s_matnr
  AND   lifnr      IN @s_lifnr
  AND   kunnr      IN @s_kunnr
  AND   zzgckfis   IN @s_zgckf .

  g_tabname = 'IT_000'.

  DATA: pfieldname LIKE gt_fieldcat-fieldname.
BREAK-POINT.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = g_repid
      i_internal_tabname = g_tabname
      i_inclname         = g_repidin
    CHANGING
      ct_fieldcat        = gt_fieldcat[].

  LOOP AT gt_fieldcat .
    CASE gt_fieldcat-fieldname .
      WHEN 'NETWR' OR 'WAERK' .
        DELETE gt_fieldcat INDEX sy-tabix .
        CONTINUE  .
*      WHEN 'MMETIN' .
*        gt_fieldcat-seltext_s =
*        gt_fieldcat-seltext_l =
*        gt_fieldcat-seltext_m = TEXT-f01.
*        gt_fieldcat-ddictxt = 'L'.
*      WHEN 'SIPMIKTAR'.
*        gt_fieldcat-seltext_s =
*        gt_fieldcat-seltext_l =
*        gt_fieldcat-seltext_m = TEXT-f02.
*        gt_fieldcat-ddictxt = 'L'.
      WHEN 'LV_SAYI' .
        gt_fieldcat-seltext_s = TEXT-f03.
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f04.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'TOLERANS' .
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f05.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'NAME2' .
        gt_fieldcat-seltext_s = TEXT-f06.
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f07.
        gt_fieldcat-ddictxt = 'L'.
*      WHEN 'NAME3' .
*        gt_fieldcat-seltext_s = TEXT-f08.
*        gt_fieldcat-seltext_l =
*        gt_fieldcat-seltext_m = TEXT-f09.
*        gt_fieldcat-ddictxt = 'L'.
      WHEN 'NETAGR' .
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f10.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'ZZMALZEME'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f11.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'ZZSATICI'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f12.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'MBLNR_FARK'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f13.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'MJAHR_FARK'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f14.
        gt_fieldcat-ddictxt = 'L'.
* -- > ADDED BY DTAS & Mercan Öztürk 24.11.2016 16:38:54
      WHEN 'ZZIRSMIK'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f15.
        gt_fieldcat-ddictxt = 'L'.
      WHEN 'ZZIRSMIKKLM'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f16.
        gt_fieldcat-ddictxt   = 'L'.
        gt_fieldcat-reptext_ddic = gt_fieldcat-seltext_l.
      WHEN 'ZZTARTIM1'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_l =
        gt_fieldcat-seltext_m = TEXT-f17.
        gt_fieldcat-ddictxt = 'L'.
* -- < ADDED BY DTAS & Mercan Öztürk 24.11.2016 16:38:54
    ENDCASE .
    MODIFY gt_fieldcat INDEX sy-tabix.
  ENDLOOP .

  DATA: g_status TYPE slis_formname.

  g_status = 'MY_STATUS'(001).
  ls_layout-box_fieldname = 'SELKZ'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = g_repid
      i_callback_pf_status_set = g_status
      i_callback_user_command  = 'USER_COMMAND'
      i_callback_top_of_page   = 'TOP_OF_PAGE'
      i_save                   = 'A'
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat[]
    TABLES
      t_outtab                 = it_000.

*&---------------------------------------------------------------------*
*&      Form  top_page
*&---------------------------------------------------------------------*
FORM top_of_page .

  DATA : char(40) ,char2(10) ,char3(10),char4(40),text(60) ,line TYPE i.
  CLEAR : ls_header , ls_header[], alv_list , alv_list[].

*- Başlık ...
  ls_header-typ = 'H'                    .
  text = TEXT-c01.
  ls_header-info = text                  .
  APPEND ls_header TO alv_list           .
  CLEAR ls_header                        .

*- Rapor Tarihi ...
  WRITE sy-datum  TO char  .
  ls_header-typ  = 'S'               .
  ls_header-key  = TEXT-c02 .
  ls_header-info = char              .
  APPEND ls_header TO alv_list       .
  CLEAR ls_header                    .

*- Raporu Tarihi...
  READ TABLE s_girdat INDEX 1.
  IF sy-subrc EQ 0 .
    WRITE :s_girdat-low TO char2 ,
           s_girdat-high TO char3.
    CONCATENATE char2 char3 INTO char4 SEPARATED BY '-' .
  ELSE.
    READ TABLE s_cikdat INDEX 1.
    IF sy-subrc EQ 0 .
      WRITE :s_cikdat-low  TO   char2 ,
             s_cikdat-high TO   char3 .

      CONCATENATE char2 char3 INTO char4 SEPARATED BY '-' .
    ENDIF.
  ENDIF .

  ls_header-typ  = 'S'              .
  ls_header-key  = TEXT-c03.
  ls_header-info = char4        .
  APPEND ls_header TO alv_list      .
  CLEAR ls_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = alv_list.

ENDFORM.                    " top_of_page
