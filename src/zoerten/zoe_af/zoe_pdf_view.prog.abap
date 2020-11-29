*&---------------------------------------------------------------------*
*& Modulpool ZOE_PDF_VIEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM zoe_pdf_view.

DATA: lt_pdf     TYPE TABLE OF tline,
      ls_pdf     LIKE LINE OF lt_pdf,
      lv_url     TYPE char255,
      pdf_fsize  TYPE  i,
      lv_content TYPE xstring,
      lt_data    TYPE STANDARD TABLE OF x255.

DATA : l_job_output_info TYPE ssfcrescl.
DATA : ls_control_param  TYPE ssfctrlop.

DATA : g_html_container TYPE REF TO cl_gui_custom_container,
       g_html_control   TYPE REF TO cl_gui_html_viewer.

DATA : p_vbeln TYPE  vbeln_vl.

FIELD-SYMBOLS <fs_x> TYPE x.

INITIALIZATION.
  ls_control_param-getotf = 'X'.
  ls_control_param-no_dialog = 'X'.

START-OF-SELECTION.

  CALL FUNCTION '/1BCDWB/SF00000034'
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = ls_control_param
      p_vbeln            = p_vbeln
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
*     OUTPUT_OPTIONS     =
*     USER_SETTINGS      = 'X'
    IMPORTING
*     DOCUMENT_OUTPUT_INFO  = L_DOCUMENT_OUTPUT_INFO
      job_output_info    = l_job_output_info
*     JOB_OUTPUT_OPTIONS = L_JOB_ OUTPUT_OPTIONS
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc  <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
    IMPORTING
      bin_filesize          = pdf_fsize
    TABLES
      otf                   = l_job_output_info-otfdata
      lines                 = lt_pdf
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.

* convert pdf to xstring string
  LOOP AT lt_pdf INTO ls_pdf.
    ASSIGN ls_pdf TO <fs_x> CASTING.
    CONCATENATE lv_content <fs_x> INTO lv_content IN BYTE MODE.
  ENDLOOP.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

  CREATE OBJECT g_html_container
    EXPORTING
      container_name = 'PDF'.

  CREATE OBJECT g_html_control
    EXPORTING
      parent = g_html_container.

* Convert xstring to binary table to pass to the LOAD_DATA method
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = lv_content
    TABLES
      binary_tab = lt_data.

* Load the HTML
  CALL METHOD g_html_control->load_data(
    EXPORTING
      type                 = 'application'
      subtype              = 'pdf'
    IMPORTING
      assigned_url         = lv_url
    CHANGING
      data_table           = lt_data
    EXCEPTIONS
      dp_invalid_parameter = 1
      dp_error_general     = 2
      cntl_error           = 3
      OTHERS               = 4 ).

* Show it
  CALL METHOD g_html_control->show_url(
      url      = lv_url
      in_place = 'X' ).

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
