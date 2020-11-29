FUNCTION zoe_fm_sf_pdf_wd.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(BIN_FILE) TYPE  XSTRING
*"----------------------------------------------------------------------
  DATA: lv_fnam            TYPE rs38l_fnam,
        gs_control         TYPE ssfctrlop,
        gs_output_options  TYPE ssfcompop,
        gs_otfdata         TYPE itcoo,
        gs_job_output_info TYPE ssfcrescl,
        gt_otfdata         TYPE STANDARD TABLE  OF itcoo  INITIAL SIZE 0.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZOE_SF_PDF_WD'
    IMPORTING
      fm_name            = lv_fnam
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR gs_job_output_info.
  CLEAR gs_job_output_info-otfdata.

  MOVE: 'X' TO gs_control-no_dialog,
        'X' TO gs_control-getotf,
        'LOCL'(047) TO gs_output_options-tddest.

  CALL FUNCTION lv_fnam
    EXPORTING
      control_parameters = gs_control
      output_options     = gs_output_options
      user_settings      = space
    IMPORTING
      job_output_info    = gs_job_output_info
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

*Populate OTF data table

  LOOP AT gs_job_output_info-otfdata INTO gs_otfdata.
    APPEND gs_otfdata TO gt_otfdata.
    CLEAR gs_otfdata.
  ENDLOOP.                           " LOOP AT t_outtab-otfdata

  DATA: lv_bytes    TYPE p,
        lv_bin_file TYPE xstring,
        gt_pdfdata  TYPE STANDARD TABLE OF tline INITIAL SIZE 0.

*   Convert OTF into PDF

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 255
    IMPORTING
      bin_filesize          = lv_bytes
      bin_file              = bin_file
    TABLES
      otf                   = gt_otfdata
      lines                 = gt_pdfdata
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.




ENDFUNCTION.
