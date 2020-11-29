**&---------------------------------------------------------------------*
*& Include          ZSS_SD_SENARYO_OE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init .
  gwa_list-key = '1'.
  gwa_list-text = TEXT-i01.
  APPEND gwa_list TO gt_list.
  gwa_list-key = '2'.
  gwa_list-text = TEXT-i02.
  APPEND gwa_list TO gt_list.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_LIST'
      values          = gt_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

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

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        IF gwa_values-fieldvalue  = '2' OR gwa_values-fieldvalue  = space.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN 'GR2'.
        IF gwa_values-fieldvalue = '1' OR gwa_values-fieldvalue  = space.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN 'GR3'.
        IF screen-name EQ 'PA_WERKS'.
          screen-input = 0.
        ENDIF.
      WHEN 'GR4'.
        IF pa_rb1 = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  DATA: lv_werks LIKE bapimatvp-werks,
        lv_matnr TYPE matnr18,
        lv_vrkme LIKE bapiadmm-unit,
        lv_meins LIKE bapiadmm-unit,
        lv_lgort LIKE bapicm61v-lgort,
        lv_charg LIKE bapicm61v-charg,
        wmdvsx   TYPE TABLE OF bapiwmdvs,
        wmdvex   TYPE TABLE OF bapiwmdve WITH HEADER LINE.
  DATA:gs_cell TYPE lvc_s_scol.

  IF gwa_values-fieldvalue = '1'.

    gv_title = TEXT-h01.

    IF pa_rb1 = 'X'.

      SELECT vbak~vbeln vbap~posnr vbap~matnr makt~maktx vbap~lgort
             vbap~charg vbap~kwmeng vbap~vrkme
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM vbak
        INNER JOIN vbap
        ON vbap~vbeln EQ vbak~vbeln
        LEFT OUTER JOIN makt
        ON vbap~matnr EQ makt~matnr
        AND makt~spras EQ sy-langu
        WHERE vbap~vbeln IN so_vb_or
        AND vbap~erdat IN so_er_or
        AND vbap~matnr IN so_matnr
        AND vbap~werks EQ pa_werks
        AND vbap~lgort NE space
        AND vbap~kwmeng GT 0.
    ENDIF.

    IF pa_rb2 = 'X'.

      CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
        EXPORTING
          filename                = pa_file
          i_begin_col             = '1'
          i_begin_row             = '1'
          i_end_col               = '5'
          i_end_row               = '7'
        TABLES
          intern                  = gt_tab1
        EXCEPTIONS
          inconsistent_parameters = 1
          upload_ole              = 2
          OTHERS                  = 3.

      IF sy-subrc <> 0.
        MESSAGE TEXT-e01 TYPE 'E'.
      ENDIF.

      SORT gt_tab1 BY row col.
      READ TABLE gt_tab1 INDEX 1.
      gv_row = gt_tab1-row.

      LOOP AT gt_tab1.
        IF gt_tab1-row NE gv_row.
          APPEND gs_record TO gt_record.
          CLEAR gs_record.
          gv_row = gt_tab1-row.
        ENDIF.

        CASE gt_tab1-col.
          WHEN '0001'.
            gs_record-vbeln = gt_tab1-value.
          WHEN '0002'.
            gs_record-posnr = gt_tab1-value.
          WHEN '0003'.
            gs_record-matnr = gt_tab1-value.
          WHEN '0004'.
            gs_record-lgort = gt_tab1-value.
          WHEN '0005'.
            gs_record-vrkme = gt_tab1-value.
        ENDCASE.
      ENDLOOP.
      APPEND gs_record TO gt_record.

      DATA: lt_data LIKE TABLE OF gt_data WITH HEADER LINE.



      LOOP AT gt_record.

        lt_data-vbeln = gt_record-vbeln.
        lt_data-posnr = gt_record-posnr.
        lt_data-matnr = gt_record-matnr.
        lt_data-lgort = gt_record-lgort.

*        IF gt_record-vrkme = 'PC'.
*          gt_record-vrkme = 'ST'.
*        ENDIF.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input          = gt_record-vrkme
            language       = sy-langu
          IMPORTING
            output         = gt_record-vrkme
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
          MESSAGE TEXT-e04 TYPE 'E'.
        ENDIF.
        lt_data-vrkme = gt_record-vrkme.
        APPEND  lt_data.
      ENDLOOP.

      LOOP AT lt_data.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lt_data-vbeln
          IMPORTING
            output = lt_data-vbeln.
        MODIFY lt_data.
      ENDLOOP.

      IF lt_data IS NOT INITIAL.
        SELECT vbak~vbeln vbap~posnr vbap~matnr makt~maktx vbap~lgort
        vbap~charg vbap~kwmeng vbap~vrkme
            INTO CORRESPONDING FIELDS OF TABLE gt_data
            FROM vbak
            INNER JOIN vbap
            ON vbap~vbeln EQ vbak~vbeln
            LEFT OUTER JOIN makt
            ON vbap~matnr EQ makt~matnr
            AND makt~spras EQ sy-langu

            FOR ALL ENTRIES IN lt_data
            WHERE vbak~vbeln EQ lt_data-vbeln
            AND vbap~posnr EQ lt_data-posnr
            AND vbap~matnr EQ lt_data-matnr
            AND vbap~lgort EQ lt_data-lgort
            AND vbap~vrkme EQ lt_data-vrkme
            AND vbap~werks EQ pa_werks.
      ENDIF.
      LOOP AT lt_data.

        READ TABLE gt_data WITH KEY vbeln = lt_data-vbeln
                                    posnr = lt_data-posnr
                                    matnr = lt_data-matnr
                                    lgort = lt_data-lgort
                                    vrkme = lt_data-vrkme.
        IF sy-subrc <> 0.
          MOVE-CORRESPONDING lt_data TO gt_data.
          gt_data-line_color = 'C610'.
          APPEND gt_data.

*         MODIFY gt_data TRANSPORTING line_color.
        ENDIF.

      ENDLOOP.

    ENDIF.

    LOOP AT gt_data.
      lv_werks = pa_werks.
      lv_matnr = gt_data-matnr.
      lv_vrkme = gt_data-vrkme.
      lv_lgort = gt_data-lgort.
      lv_charg = gt_data-charg.

      CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
        EXPORTING
          plant    = lv_werks
          material = lv_matnr
          unit     = lv_vrkme
          stge_loc = lv_lgort
          batch    = lv_charg
        TABLES
          wmdvsx   = wmdvsx
          wmdvex   = wmdvex.

      gt_data-kwmeng2 = wmdvex-com_qty.
      IF gt_data-kwmeng GT gt_data-kwmeng2.
        gs_cell-fname = 'KWMENG'.
        gs_cell-color-col = '6'.
        gs_cell-color-int = '1'.
        gs_cell-color-inv = '0'.
        APPEND gs_cell TO gt_data-cell.
        gs_cell-fname = 'KWMENG2'.
        gs_cell-color-col = '6'.
        gs_cell-color-int = '1'.
        gs_cell-color-inv = '0'.
        APPEND gs_cell TO gt_data-cell.
        MODIFY gt_data TRANSPORTING cell.
      ENDIF.
      MODIFY gt_data TRANSPORTING kwmeng2.
      CLEAR wmdvex[].
    ENDLOOP.


  ELSEIF gwa_values-fieldvalue = '2'.

    gv_title = TEXT-h02.

    IF pa_rb1 = 'X'.

      SELECT likp~vbeln lips~posnr lips~matnr makt~maktx lips~lgort
             lips~charg lips~lfimg lips~meins
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM likp
        INNER JOIN lips
        ON lips~vbeln EQ likp~vbeln
        LEFT OUTER JOIN makt
        ON lips~matnr EQ makt~matnr
        AND makt~spras EQ sy-langu
        WHERE lips~vbeln IN so_vb_de
        AND lips~erdat IN so_er_de
        AND lips~matnr IN so_matnr
        AND lips~werks EQ pa_werks
        AND lips~lgort NE space
        AND lips~lfimg GT 0.

      LOOP AT gt_data.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = gt_data-vbeln
          IMPORTING
            output = gt_data-vbeln.
        MODIFY gt_data.
      ENDLOOP.
    ENDIF.

    IF pa_rb2 = 'X'.

      CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
        EXPORTING
          filename                = pa_file
          i_begin_col             = '1'
          i_begin_row             = '2'
          i_end_col               = '5'
          i_end_row               = '5'
        TABLES
          intern                  = gt_tab1
        EXCEPTIONS
          inconsistent_parameters = 1
          upload_ole              = 2
          OTHERS                  = 3.

      IF sy-subrc <> 0.
        MESSAGE TEXT-e01 TYPE 'E'.
      ENDIF.

      SORT gt_tab1 BY row col.
      READ TABLE gt_tab1 INDEX 1.
      gv_row2 = gt_tab1-row.

      LOOP AT gt_tab1.
        IF gt_tab1-row NE gv_row2.
          APPEND gs_record2 TO gt_record2.
          CLEAR gs_record2.
          gv_row2 = gt_tab1-row.
        ENDIF.

        CASE gt_tab1-col.
          WHEN '0001'.
            gs_record2-vbeln = gt_tab1-value.
          WHEN '0002'.
            gs_record2-posnr = gt_tab1-value.
          WHEN '0003'.
            gs_record2-matnr = gt_tab1-value.
          WHEN '0004'.
            gs_record2-lgort = gt_tab1-value.
          WHEN '0005'.
            gs_record2-meins = gt_tab1-value.
        ENDCASE.
      ENDLOOP.
      APPEND gs_record2 TO gt_record2.

      DATA: lt_data2 LIKE TABLE OF gt_data WITH HEADER LINE.


      LOOP AT gt_record2.

        lt_data2-vbeln = gt_record2-vbeln.
        lt_data2-posnr = gt_record2-posnr.
        lt_data2-matnr = gt_record2-matnr.
        lt_data2-lgort = gt_record2-lgort.

*        IF gt_record-vrkme = 'PC'.
*          gt_record-vrkme = 'ST'.
*        ENDIF.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input          = gt_record2-meins
            language       = sy-langu
          IMPORTING
            output         = gt_record2-meins
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
          MESSAGE TEXT-e04 TYPE 'E'.
        ENDIF.
        lt_data2-meins = gt_record2-meins.
        APPEND  lt_data2.
      ENDLOOP.

      LOOP AT lt_data2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lt_data2-vbeln
          IMPORTING
            output = lt_data2-vbeln.
        MODIFY lt_data2.
      ENDLOOP.

      IF lt_data2 IS NOT INITIAL.
        SELECT likp~vbeln lips~posnr lips~matnr makt~maktx lips~lgort
               lips~charg lips~lfimg lips~meins
          INTO CORRESPONDING FIELDS OF TABLE gt_data
          FROM likp
          INNER JOIN lips
          ON lips~vbeln EQ likp~vbeln
          LEFT OUTER JOIN makt
          ON lips~matnr EQ makt~matnr
          AND makt~spras EQ sy-langu

              FOR ALL ENTRIES IN lt_data2
              WHERE likp~vbeln EQ lt_data2-vbeln
              AND lips~posnr EQ lt_data2-posnr
              AND lips~matnr EQ lt_data2-matnr
              AND lips~lgort EQ lt_data2-lgort
              AND lips~vrkme EQ lt_data2-meins
              AND lips~werks EQ pa_werks.
      ENDIF.

      LOOP AT lt_data2.

        READ TABLE gt_data WITH KEY vbeln = lt_data2-vbeln
                                    posnr = lt_data2-posnr
                                    matnr = lt_data2-matnr
                                    lgort = lt_data2-lgort
                                    vrkme = lt_data2-vrkme.
        IF sy-subrc <> 0.
          MOVE-CORRESPONDING lt_data2 TO gt_data.
          gt_data-line_color = 'C610'.
          APPEND gt_data.

*         MODIFY gt_data TRANSPORTING line_color.
        ENDIF.

      ENDLOOP.

    ENDIF.

    LOOP AT gt_data.
      lv_werks = pa_werks.
      lv_matnr = gt_data-matnr.
      lv_meins = gt_data-meins.
      lv_lgort = gt_data-lgort.
      lv_charg = gt_data-charg.

      CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
        EXPORTING
          plant    = lv_werks
          material = lv_matnr
          unit     = lv_meins
          stge_loc = lv_lgort
          batch    = lv_charg
        TABLES
          wmdvsx   = wmdvsx
          wmdvex   = wmdvex.

      gt_data-lfimg2 = wmdvex-com_qty.
      IF gt_data-lfimg GT gt_data-lfimg2.
        gs_cell-fname = 'LFIMG'.
        gs_cell-color-col = '6'.
        gs_cell-color-int = '1'.
        gs_cell-color-inv = '0'.
        APPEND gs_cell TO gt_data-cell.
        gs_cell-fname = 'LFIMG2'.
        gs_cell-color-col = '6'.
        gs_cell-color-int = '1'.
        gs_cell-color-inv = '0'.
        APPEND gs_cell TO gt_data-cell.
        MODIFY gt_data TRANSPORTING cell.
      ENDIF.
      MODIFY gt_data TRANSPORTING lfimg2.
      CLEAR wmdvex[].
    ENDLOOP.

  ENDIF.






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
  gs_layout-box_fieldname = 'BOX'.
  gs_layout-info_fieldname = 'LINE_COLOR'.
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-coltab_fieldname  = 'CELL'.




  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_internal_tabname = 'GS_DATA'
      i_inclname         = 'ZOE_SD_SENARYO_TOP'
    CHANGING
      ct_fieldcat        = gt_fieldcat[].



  LOOP AT gt_fieldcat.
    CASE gt_fieldcat-fieldname.
      WHEN 'BOX'.
        gt_fieldcat-no_out = 'X'.
      WHEN 'VBELN'.
        IF gwa_values-fieldvalue = '2'.
          gt_fieldcat-seltext_s =
          gt_fieldcat-seltext_m =
          gt_fieldcat-seltext_l =
          gt_fieldcat-reptext_ddic = 'Delivery Document'.
        ENDIF.
        gt_fieldcat-hotspot = 'X'.
      WHEN 'KWMENG'.
        IF gwa_values-fieldvalue = '2'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
      WHEN 'KWMENG2'.
        IF gwa_values-fieldvalue = '2'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Available Stock'.
      WHEN 'VRKME'.
        IF gwa_values-fieldvalue = '2'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
      WHEN 'LFIMG'.
        IF gwa_values-fieldvalue = '1'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
      WHEN 'LFIMG2'.
        IF gwa_values-fieldvalue = '1'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = TEXT-f01.
      WHEN 'MEINS'.
        IF gwa_values-fieldvalue = '1'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat.
  ENDLOOP.



  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_grid_title             = gv_title
      i_callback_program       = sy-repid
      is_layout                = gs_layout
      i_save                   = 'A'
      it_fieldcat              = gt_fieldcat[]
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
    TABLES
      t_outtab                 = gt_data.


ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                   rs_selfield TYPE slis_selfield.


  CASE r_ucomm.
    WHEN '&IC1'.
      IF rs_selfield-sel_tab_field = 'GS_DATA-VBELN'.
        IF gwa_values-fieldvalue = '1'.
          SET PARAMETER ID 'AUN' FIELD rs_selfield-value.
          CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
        ELSEIF gwa_values-fieldvalue = '2'.
          SET PARAMETER ID 'VL' FIELD rs_selfield-value.
          CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
        ENDIF.
      ENDIF.
    WHEN 'SALES'.
      PERFORM sales_update.
    WHEN 'DELIV'.
      PERFORM delivery_update.
  ENDCASE.




  rs_selfield-refresh = 'X'.
  rs_selfield-col_stable = 'X'.
  rs_selfield-row_stable = 'X'.
ENDFORM.

FORM set_pf_status USING rt_exhab TYPE slis_t_extab.

  DATA: lt_ucomm LIKE TABLE OF sy-ucomm.
  DATA: ls_ucomm LIKE LINE OF lt_ucomm.

*  SET PF-STATUS 'STATUS'.

  IF p_list = '1'.
    ls_ucomm = 'DELIV'. APPEND ls_ucomm TO lt_ucomm.
    SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
  ELSEIF p_list = '2'.
    ls_ucomm = 'SALES'. APPEND ls_ucomm TO lt_ucomm.
    SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
  ELSE.
    ls_ucomm = 'DELIV'. APPEND ls_ucomm TO lt_ucomm.
    ls_ucomm = 'SALES'. APPEND ls_ucomm TO lt_ucomm.
    SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SALES_UPDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sales_update.

  DATA: BEGIN OF ls_sl,
          kunnr LIKE kna1-kunnr,
          ort01 LIKE kna1-ort01,
          stras LIKE kna1-stras,
          telf1 LIKE kna1-telf1,
          vbeln LIKE vbak-vbeln,
        END OF ls_sl.

  DATA: lt_sl LIKE TABLE OF ls_sl WITH HEADER LINE.
  DATA: lv_txt(35).

  IF gt_data IS NOT INITIAL.

    SELECT kna1~kunnr kna1~ort01 kna1~stras kna1~telf1 vbak~vbeln
     INTO TABLE lt_sl[]
    FROM kna1 INNER JOIN vbak ON kna1~kunnr = vbak~kunnr
    FOR ALL ENTRIES IN gt_data
    WHERE vbak~vbeln EQ gt_data-vbeln.

  ENDIF.



  LOOP AT gt_data WHERE box = 'X'.
    CLEAR result[].
    IF gt_data-line_color IS NOT INITIAL.
      MESSAGE TEXT-e02 TYPE 'E'.
    ELSE.
      READ TABLE lt_sl WITH KEY vbeln = gt_data-vbeln.
      CONCATENATE lt_sl-ort01 lt_sl-stras lt_sl-telf1 INTO lv_txt
                SEPARATED BY ' - '.


*      SELECT SINGLE vbak~kunnr kna1~ort01 kna1~stras kna1~telf1
*        FROM kna1 INNER JOIN vbak ON kna1~kunnr EQ vbak~kunnr
*         INTO lt_sl
*        WHERE vbak~vbeln EQ gt_data-vbeln
*        .
*    CONCATENATE lt_sl-ort01 lt_sl-stras lt_sl-telf1 INTO lt_txt
*                SEPARATED BY '-'.

      REFRESH bdcdata.



      PERFORM bdc_dynpro      USING 'SAPMV45A' '0102'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'VBAK-VBELN'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=SUCH'.
      PERFORM bdc_field       USING 'VBAK-VBELN'
                                    gt_data-vbeln.
      PERFORM bdc_dynpro      USING 'SAPMV45A' '4001'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=SICH'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'VBKD-BSTKD'.
      PERFORM bdc_field       USING 'VBKD-BSTKD'
                                    lv_txt.
*      PERFORM bdc_field       USING 'KUWEV-KUNNR'.
*                                    record-kunnr_003.
*      PERFORM bdc_field       USING 'RV45A-KETDAT'.
*                                    record-ketdat_004.
*      PERFORM bdc_field       USING 'RV45A-KPRGBZ'.
*                                    record-kprgbz_005.
*      PERFORM bdc_field       USING 'VBKD-PRSDT'.
*                                    record-prsdt_006.
*      PERFORM bdc_field       USING 'VBKD-ZTERM'.
*                                    record-zterm_007.
*      PERFORM bdc_field       USING 'VBKD-INCO1'.
*                                    record-inco1_008.
*      PERFORM bdc_field       USING 'VBKD-INCO2_L'.
*                                    record-inco2_l_009.
      PERFORM bdc_transaction USING 'VA02'.



    ENDIF.

    DATA: lv_txt2(255).

    LOOP AT result WHERE msgtyp CA 'SEAX'.
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = result-msgid
          msgnr               = result-msgnr
          msgv1               = result-msgv1
          msgv2               = result-msgv2
          msgv3               = result-msgv3
          msgv4               = result-msgv4
        IMPORTING
          message_text_output = lv_txt2.
    ENDLOOP.
    IF result-msgtyp = 'E'.
      MESSAGE lv_txt2 TYPE 'E'.
    ELSEIF result-msgtyp = 'S'.
      MESSAGE lv_txt2 TYPE 'S'.
    ENDIF.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELIVERY_UPDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delivery_update.
  DATA: ls_header_data TYPE bapiobdlvhdrchg.
  DATA: ls_header_control TYPE bapiobdlvhdrctrlchg.
  DATA: ls_likp TYPE likp.
  DATA: lt_return LIKE  TABLE OF bapiret2 WITH HEADER LINE.
  DATA: lt_item_data LIKE TABLE OF bapiobdlvitemchg WITH HEADER LINE.
  DATA: it_message  TYPE  bapirettab WITH HEADER LINE.

  LOOP AT gt_data WHERE box = 'X'.
    CLEAR lt_return[].
    IF gt_data IS NOT INITIAL.

      IF gt_data-line_color IS NOT INITIAL.
        MESSAGE TEXT-e02 TYPE 'E'.
      ELSE.
        ls_header_data-deliv_numb = gt_data-vbeln.
        ls_header_control-deliv_numb = gt_data-vbeln.
*        ls_header_data-deliv_numb = '18000005'.
*        ls_header_control-deliv_numb = '18000005'.
        ls_header_data-route = 'OE1337'.
        ls_header_control-route_flg = 'X'.

        CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
          EXPORTING
            header_data    = ls_header_data
            header_control = ls_header_control
            delivery       = gt_data-vbeln
          TABLES
            item_data      = lt_item_data
            return         = lt_return.

        LOOP AT lt_return WHERE type CA 'EAX'.
          MOVE-CORRESPONDING lt_return TO it_message.
          APPEND it_message.
        ENDLOOP.
        IF sy-subrc EQ 0.




          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


        ELSE.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
*           IMPORTING
*             RETURN        = lt_return.

          MESSAGE TEXT-e03 TYPE 'S'.

        ENDIF.


      ENDIF.
    ENDIF.
  ENDLOOP.


  IF it_message[] IS NOT INITIAL.
    CALL FUNCTION 'OXT_MESSAGE_TO_POPUP'
      EXPORTING
        it_message = it_message[]
*           IMPORTING
*       EV_CONTINUE       = ld_ev_continue
      EXCEPTIONS
        bal_error  = 1
        OTHERS     = 2.
  ENDIF.

ENDFORM.

FORM bdc_dynpro  USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    " BDC_DYNPRO

FORM bdc_field  USING fnam fval.
  IF fval <> nodata.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    " BDC_FIELD

FORM bdc_transaction  USING tcode.
  REFRESH messtab.
  CALL TRANSACTION tcode USING bdcdata
                         MODE  pa_mode
                         MESSAGES INTO messtab.
  LOOP AT messtab.
    APPEND messtab TO result .
  ENDLOOP.
  CLEAR : bdcdata   ,
          bdcdata[] .
ENDFORM.                    " BDC_TRANSACTION
