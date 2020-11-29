*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FAT_CIK_F01
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
  gs_functxt_01-icon_id   = icon_configuration.
  gs_functxt_01-quickinfo = TEXT-100.
  gs_functxt_01-icon_text = TEXT-100.
  sscrfields-functxt_01 = gs_functxt_01.

  but1 = TEXT-b01.

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
*  SELECT z~vbeln,
*         p~posnr,
*         k~fkdat,
*         k~fkart,
*         z~matnr,
*         p~arktx,
*         z~kunag,
*         ( b~name_grp1 && ' ' && b~name_grp2 ) AS name,
*         z~fkimg,
*         z~vrkme,
*         z~netwr,
*         p~mwsbp,
*         z~waerk
*    from ZOE_SD_MT as z INNER JOIN vbrk as k
*    on z~vbeln eq k~vbeln
*    INNER JOIN vbrp as p
*    on z~matnr eq p~matnr
*    LEFT OUTER JOIN but000 AS b
*    ON k~kunag EQ b~partner
*    INTO CORRESPONDING FIELDS OF TABLE @gt_data.


  IF pa_rb1 = 'X'.
    SELECT  z~vbeln,
            p~posnr,
            k~fkdat,
            k~fkart,
            z~matnr,
            p~arktx,
            z~kunag,
            ( b~name_org1 && ' ' && b~name_org2 ) AS name,
            z~fkimg,
            z~vrkme,
            z~netwr,
            p~mwsbp,
            z~waerk
      FROM zoe_sd_mt AS z LEFT OUTER JOIN vbrk AS k
      ON z~vbeln EQ k~vbeln
      LEFT OUTER JOIN vbrp AS p
      ON z~vbeln EQ p~vbeln
      LEFT OUTER JOIN but000 AS b
      ON z~kunag EQ b~partner
      INTO CORRESPONDING FIELDS OF TABLE @gt_data.

    LOOP AT gt_data.
      SELECT SINGLE COUNT(*) FROM vbrp
                    WHERE vbeln = gt_data-vbeln
                    AND matnr = gt_data-matnr.
      IF sy-subrc IS NOT INITIAL.
        DELETE gt_data WHERE vbeln = gt_data-vbeln
                       AND matnr = gt_data-matnr.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF pa_rb2 = 'X'.

    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = '1'
        i_begin_row             = '2'
        i_end_col               = '7'
        i_end_row               = '9'
      TABLES
        intern                  = gt_tab1
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc <> 0.
      MESSAGE TEXT-e02 TYPE 'E'.
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
          gs_record-matnr = gt_tab1-value.
        WHEN '0003'.
          gs_record-kunag = gt_tab1-value.
        WHEN '0004'.
          gs_record-fkimg = gt_tab1-value.
        WHEN '0005'.
          gs_record-vrkme = gt_tab1-value.
        WHEN '0006'.
          gs_record-netwr = gt_tab1-value.
        WHEN '0007'.
          gs_record-waerk = gt_tab1-value.
      ENDCASE.
    ENDLOOP.
    APPEND gs_record TO gt_record.

    DATA: ls_data LIKE LINE OF gt_data2.

    LOOP AT gt_record.

      ls_data-matnr = gt_record-matnr.
      ls_data-kunag = gt_record-kunag.
      ls_data-fkimg = gt_record-fkimg.

      ls_data-waerk = gt_record-waerk.

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
        MESSAGE TEXT-e03 TYPE 'E'.
      ENDIF.
      ls_data-vrkme = gt_record-vrkme.


*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = gt_record-vbeln
*        IMPORTING
*          output = gt_record-vbeln.
      ls_data-vbeln = gt_record-vbeln.


      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gt_record-kunag
        IMPORTING
          output = gt_record-kunag.
      ls_data-kunag = gt_record-kunag.


      CALL FUNCTION 'HRCM_STRING_TO_AMOUNT_CONVERT'
        EXPORTING
          string              = gt_record-netwr
          decimal_separator   = ','
          thousands_separator = '.'
*         WAERS               = ' '
        IMPORTING
          betrg               = gt_record-netwr
        EXCEPTIONS
          convert_error       = 1
          OTHERS              = 2.
      IF sy-subrc <> 0.
      ENDIF.

      ls_data-netwr = gt_record-netwr.
      APPEND ls_data TO gt_data2.

    ENDLOOP.

    LOOP AT gt_data2 INTO ls_data.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_data-vbeln
        IMPORTING
          output = ls_data-vbeln.
      MODIFY gt_data2 FROM ls_data TRANSPORTING vbeln.
    ENDLOOP.
    IF ls_data IS NOT INITIAL.
      SELECT  k~vbeln,
              p~posnr,
              k~fkdat,
              k~fkart,
              p~matnr,
              p~arktx,
              k~kunag,
              concat_with_space( b~name_org1, b~name_org2, 1 ) AS name,
              p~fkimg,
              p~vrkme,
              p~netwr,
              p~mwsbp,
              k~waerk
              FROM vbrk AS k
              INNER JOIN vbrp AS p
              ON k~vbeln EQ p~vbeln
              LEFT OUTER JOIN but000 AS b
              ON k~kunag EQ b~partner
              INNER JOIN @gt_data2 AS n ON p~vbeln EQ n~vbeln
                                         AND p~matnr EQ n~matnr
              INTO CORRESPONDING FIELDS OF TABLE @gt_data.

      LOOP AT gt_data.
        SELECT SINGLE COUNT( * ) FROM vbrp
                      WHERE vbeln = gt_data-vbeln
                      AND matnr = gt_data-matnr.
        IF sy-subrc IS NOT INITIAL.
          DELETE gt_data WHERE vbeln = gt_data-vbeln
                         AND matnr = gt_data-matnr.
        ENDIF.
      ENDLOOP.
    ENDIF.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILE_UPLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM file_upload .
  DATA : w_filename TYPE filetable,
         w_area     TYPE file_table,
         w_rc       TYPE i,
         w_ret      TYPE i.
  DATA: r_filename LIKE LINE OF w_filename.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Select file'
      default_extension       = '*.xls'
      default_filename        = '*.xls'
      file_filter             = '*.*'
    CHANGING
      file_table              = w_filename
      rc                      = w_rc
      user_action             = w_ret
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  READ TABLE w_filename INTO r_filename INDEX 1.

  IF sy-subrc = 0.
    p_file = r_filename.
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
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-box_fieldname = 'BOX'.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_internal_tabname = 'GS_DATA'
      i_inclname         = 'ZOE_SD_FAT_CIK_TOP'
    CHANGING
      ct_fieldcat        = gt_fieldcat[].

  LOOP AT gt_fieldcat.
    CASE gt_fieldcat-fieldname.
      WHEN 'BOX'.
        gt_fieldcat-no_out = 'X'.
      WHEN 'VBELN'.
        gt_fieldcat-hotspot = 'X'.
      WHEN 'NAME'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Name'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat.
  ENDLOOP.

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
      t_outtab                 = gt_data.

ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                   rs_selfield TYPE slis_selfield.

  CASE r_ucomm.
    WHEN '&IC1'.
      IF rs_selfield-sel_tab_field = 'GS_DATA-VBELN'.
        READ TABLE gt_data INDEX rs_selfield-tabindex.
        SET PARAMETER ID 'MAT' FIELD gt_data-matnr.
        CALL TRANSACTION 'MM03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
      ENDIF.
    WHEN 'PRINT'.
      PERFORM print.
    WHEN 'SMRFM'.
      PERFORM smartform.
    WHEN 'ADBFM'.
      PERFORM adobeform.
    WHEN 'SMRDL'.
      PERFORM smart_download.
    WHEN 'ADMAT'.
      PERFORM mailadobe.
    WHEN 'SAVE'.
      PERFORM save_mt.
    WHEN OTHERS.
  ENDCASE.



  rs_selfield-refresh = 'X'.
  rs_selfield-col_stable = 'X'.
  rs_selfield-row_stable = 'X'.
ENDFORM.

FORM set_pf_status USING rt_exhab TYPE slis_t_extab.

  DATA: lt_ucomm LIKE TABLE OF sy-ucomm.
  DATA: ls_ucomm LIKE LINE OF lt_ucomm.

  IF pa_rb1 = 'X'.
    ls_ucomm = 'SAVE'.  APPEND ls_ucomm TO lt_ucomm.
    SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
  ELSE.
    SET PF-STATUS 'STATUS'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TEMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM template.

  SELECT  vbeln,
          matnr,
          kunag,
          fkimg,
          vrkme,
          netwr,
          waerk
    INTO CORRESPONDING FIELDS OF TABLE @lt_excel_format
    FROM zoe_sd_mt
    UP TO 1 ROWS.


  CREATE OBJECT excel 'EXCEL.APPLICATION'.
  CALL METHOD OF excel 'WORKBOOKS' = workbook .
  SET PROPERTY OF excel 'VISIBLE' = 0 .
  CALL METHOD OF workbook 'add'.
  CALL METHOD OF excel 'Worksheets' = sheet EXPORTING #1 = 1.
  CALL METHOD OF sheet 'Activate'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'A1'.
  SET PROPERTY OF cell 'VALUE' = 'Billing Document'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'B1'.
  SET PROPERTY OF cell 'VALUE' = 'Material'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'C1'.
  SET PROPERTY OF cell 'VALUE' = 'Sold-To-Party'..
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'D1'.
  SET PROPERTY OF cell 'VALUE' = 'Billed Quantity'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'E1'.
  SET PROPERTY OF cell 'VALUE' = 'SU'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'F1'.
  SET PROPERTY OF cell 'VALUE' = 'Net Value'.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'G1'.
  SET PROPERTY OF cell 'VALUE' = 'Currency'.


  READ TABLE lt_excel_format.
  CALL METHOD OF excel 'ROWS' = row EXPORTING #1 = '2'.
  CALL METHOD OF row 'INSERT' NO FLUSH.

  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'A2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-vbeln NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'B2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-matnr NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'C2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-kunag NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'D2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-fkimg NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'E2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-vrkme NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'F2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-netwr NO FLUSH.
  CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = 'G2'.
  SET PROPERTY OF cell 'VALUE' = lt_excel_format-waerk NO FLUSH.

  CLEAR i.
  DO 7 TIMES.
    i = i + 1.
    CALL METHOD OF excel 'CELLS' = cell  NO FLUSH
       EXPORTING #1 = 1
                 #2 = i.

    GET PROPERTY OF cell 'FONT' = font NO FLUSH.
    SET PROPERTY OF font 'BOLD' = 1 NO FLUSH.
    SET PROPERTY OF font 'SIZE' = 12.
    CALL METHOD OF cell 'INTERIOR' = range.
    SET PROPERTY OF range 'ColorIndex' = 6.
    SET PROPERTY OF range 'Pattern' = 1.
  ENDDO.

  CALL METHOD OF excel 'Columns' = column.
  CALL METHOD OF column 'Autofit'.


  CALL METHOD OF sheet 'SAVEAS'
    EXPORTING
      #1 = 'C:\Users\OERTEN\Desktop\temp.xls'
      #2 = 1.
  CALL METHOD OF excel 'QUIT'.

  FREE OBJECT cell.
  FREE OBJECT workbook.
  FREE OBJECT excel.
  excel-handle = -1.
  FREE OBJECT row.
  FREE OBJECT column.

  IF sy-subrc = 0.
    MESSAGE TEXT-s01 TYPE 'S'.
  ELSE.
    MESSAGE TEXT-e01 TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_MT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_mt .
  DATA: lt_ztab LIKE TABLE OF zoe_sd_mt WITH HEADER LINE.
  LOOP AT gt_data WHERE box = 'X'.
    lt_ztab-vbeln = gt_data-vbeln.
    lt_ztab-matnr = gt_data-matnr.
    lt_ztab-kunag = gt_data-kunag.
    lt_ztab-fkimg = gt_data-fkimg.
    lt_ztab-vrkme = gt_data-vrkme.
    lt_ztab-netwr = gt_data-netwr.
    lt_ztab-waerk = gt_data-waerk.
    APPEND lt_ztab.
  ENDLOOP.
  MODIFY zoe_sd_mt FROM lt_ztab.
  CLEAR: lt_ztab,
         lt_ztab[].
  IF sy-subrc <> 0.
    MESSAGE TEXT-e04 TYPE 'E'.
  ELSE.
    MESSAGE TEXT-s02 TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SMARTFORM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM smartform .

  CLEAR cnt.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZOE_SD_FAT_SF1'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = sf_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



  LOOP AT gt_data WHERE box = 'X'.
    cnt = cnt + 1.
  ENDLOOP.

  IF cnt EQ 0.
    MESSAGE TEXT-i01 TYPE 'I'.
  ELSEIF cnt GT 1.
    MESSAGE TEXT-e05 TYPE 'E'.
  ELSE.
    CALL FUNCTION sf_name
      EXPORTING
        i_vbeln          = gt_data-vbeln
        output_options   = gwa_ssfcompop
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SMART_DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM smart_download.
  CLEAR cnt.

  LOOP AT gt_data WHERE box = 'X'.
    cnt = cnt + 1.
  ENDLOOP.

  IF cnt EQ 0.
    MESSAGE TEXT-i01 TYPE 'I'.
  ELSEIF cnt GT 1.
    MESSAGE TEXT-e05 TYPE 'E'.
  ELSE.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZOE_SD_FAT_SF1'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = sf_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'SSF_GET_DEVICE_TYPE'
      EXPORTING
        i_language             = sy-langu
      IMPORTING
        e_devtype              = gv_devtype
      EXCEPTIONS
        no_language            = 1
        language_not_installed = 2
        no_devtype_found       = 3
        system_error           = 4
        OTHERS                 = 5.
    IF sy-subrc <> 0.
    ENDIF.

    gwa_ssfcompop-tdprinter = gv_devtype.

    gwa_control-no_dialog = 'X'.
    gwa_control-getotf = 'X'.

    CALL FUNCTION sf_name
      EXPORTING
        i_vbeln            = gt_data-vbeln
        control_parameters = gwa_control
        output_options     = gwa_ssfcompop
      IMPORTING
        job_output_info    = gv_job_output
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_filesize          = gv_size
      TABLES
        otf                   = gv_job_output-otfdata
        lines                 = gt_lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        bin_filesize            = gv_size
        filename                = 'C:\Users\OERTEN\Desktop\demo.pdf'
        filetype                = 'BIN'
      TABLES
        data_tab                = gt_lines
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form PRINT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print .
  DATA: lv_result TYPE i.
  CALL FUNCTION 'K_KKB_POPUP_RADIO2'
    EXPORTING
      i_title   = 'Print Option'
      i_text1   = 'Print Smartform'
      i_text2   = 'Print Adobeform'
      i_default = 1
    IMPORTING
      i_result  = lv_result
    EXCEPTIONS
      cancel    = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF lv_result = 1.
    gwa_ssfcompop-tdcopies = p_copy.
    PERFORM smartform.
  ELSEIF lv_result = 2.
    fp_outputparams-copies = p_copy.
    PERFORM adobeform.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADOBEFORM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM adobeform .



  CLEAR cnt.

  LOOP AT gt_data WHERE box = 'X'.
    cnt = cnt + 1.
  ENDLOOP.

  IF cnt EQ 0.
    MESSAGE TEXT-i01 TYPE 'I'.
  ELSEIF cnt GT 1.
    MESSAGE TEXT-e05 TYPE 'E'.
  ELSE.
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
*            <error handling>
    ENDIF.

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = 'ZOE_SD_ADF1'
          IMPORTING
            e_funcname = l_fm_name.
      CATCH cx_fp_api_internal.
      CATCH cx_fp_api_repository.
      CATCH cx_fp_api_usage.
    ENDTRY.

    CALL FUNCTION l_fm_name
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        i_vbeln           = gt_data-vbeln
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3.
    IF sy-subrc <> 0.
*  <error handling>
    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
*            <error handling>
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAILADOBE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM mailadobe .

  TRY.
      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = l_formname
        IMPORTING
          e_funcname = l_fm_name.
    CATCH cx_fp_api_repository.
    CATCH cx_fp_api_internal.
    CATCH cx_fp_api_usage.
  ENDTRY.

*  fp_outputparams-nodialog = 'X'.
*  fp_outputparams-getpdf   = 'X'.
  fp_outputparams = VALUE #( nodialog = 'X'
                             getpdf = 'X' ).

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = fp_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN OTHERS.
    ENDCASE.                           " CASE sy-subrc
  ENDIF.

  CALL FUNCTION l_fm_name
    EXPORTING
      /1bcdwb/docparams  = fp_docparams
      i_vbeln            = gt_data-vbeln
    IMPORTING
      /1bcdwb/formoutput = fp_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN OTHERS.
    ENDCASE.                           " CASE sy-subrc
  ENDIF.                               " IF sy-subrc <> 0
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN OTHERS.
    ENDCASE.                           " CASE sy-subrc
  ENDIF.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = fp_formoutput-pdf
    TABLES
      binary_tab = t_att_content_hex.

  CLASS cl_bcs DEFINITION LOAD.

  DATA:
  lo_send_request TYPE REF TO cl_bcs VALUE IS INITIAL.

  TRY.
      lo_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Message body and subject
  DATA:
    lt_message_body TYPE bcsy_text VALUE IS INITIAL,
    lo_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL.

  APPEND 'Dear,' TO lt_message_body.
  APPEND ' ' TO lt_message_body.
  APPEND 'The selected billing document is in the attachment.'
  TO lt_message_body.
  APPEND ' ' TO lt_message_body.
  APPEND 'Thank You,' TO lt_message_body.

  TRY.
      lo_document = cl_document_bcs=>create_document(
                                              i_type = 'RAW'
                                              i_text = lt_message_body
                                              i_subject = 'Billing Document' ).
    CATCH cx_document_bcs.
  ENDTRY.

  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL.

  TRY.
      lo_document->add_attachment(
      EXPORTING
      i_attachment_type = 'BIN'
      i_attachment_subject = 'ADOBEFORM.PDF'
      i_att_content_hex = t_att_content_hex ).
    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

* Add attachment
* Pass the document to send request
  TRY.
      lo_send_request->set_document( lo_document ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Create sender
  DATA:
    lo_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL,
    l_send    TYPE adr6-smtp_addr VALUE 'onur.erten@mbis.com.tr'.

  TRY.
      lo_sender = cl_sapuser_bcs=>create( sy-uname ).
    CATCH cx_address_bcs.
  ENDTRY.

* Set sender
  TRY.
      lo_send_request->set_sender( i_sender = lo_sender ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Create recipient
  DATA:
  lo_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL.

  TRY.
      lo_recipient = cl_cam_address_bcs=>create_internet_address( l_send ).
    CATCH cx_address_bcs.
  ENDTRY.

** Set recipient
  TRY.
      lo_send_request->add_recipient( i_recipient = lo_recipient
                                      i_express = 'X' ).
    CATCH cx_send_req_bcs.
  ENDTRY.

* Send email
  DATA: lv_sent_to_all(1) TYPE c VALUE IS INITIAL.

  TRY.
      lo_send_request->send(
      EXPORTING
      i_with_error_screen = 'X'
      RECEIVING
      result = lv_sent_to_all ).
    CATCH cx_send_req_bcs.
  ENDTRY.

  COMMIT WORK AND WAIT.

ENDFORM.
