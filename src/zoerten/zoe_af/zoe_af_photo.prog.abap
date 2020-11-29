*&---------------------------------------------------------------------*
*& Report ZOE_AF_PHOTO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_af_photo.

DATA : it_photo TYPE   zoe_af_photo_tt,
       wa_photo TYPE   zoe_af_photo_s.

DATA   : wa_ztest_photo TYPE zoe_af_photo,
         it_ztest_photo TYPE TABLE OF zoe_af_photo.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_pernr FOR wa_ztest_photo-pernr NO INTERVALS .
PARAMETERS     : p_print  TYPE char1 RADIOBUTTON GROUP rda1 DEFAULT 'X' USER-COMMAND com,
                 p_upload TYPE char1 RADIOBUTTON GROUP rda1.
SELECTION-SCREEN END OF BLOCK b1.

IF p_print IS NOT INITIAL.

* selecting the data from the table..
  SELECT pernr photo FROM  zoe_af_photo INTO CORRESPONDING FIELDS OF TABLE it_ztest_photo
                         WHERE pernr IN  s_pernr .
  LOOP AT it_ztest_photo INTO wa_ztest_photo.
    wa_photo-pernr = wa_ztest_photo-pernr.
    wa_photo-photo = wa_ztest_photo-photo.
    APPEND wa_photo TO it_photo.
  ENDLOOP.

  DATA :fp_outputparams   TYPE sfpoutputparams.

  fp_outputparams-nodialog = 'X'. "'X'.
  fp_outputparams-preview  = 'X'. "'X'.
*  fp_docparams-FILLABLE    = 'N'.
*fp_outputparams-DEVICE   = 'ZLOCA'.

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
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA: e_funcname TYPE funcname.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZOE_AF_PHOTO'
    IMPORTING
      e_funcname = e_funcname.
  IF sy-subrc <> 0.
*  <error handling>
  ENDIF.

  CALL FUNCTION e_funcname
    EXPORTING
*     /1BCDWB/DOCPARAMS        =
      it_photo = it_photo
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*     USAGE_ERROR              = 1
*     SYSTEM_ERROR             = 2
*     INTERNAL_ERROR           = 3
*     OTHERS   = 4
    .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.

  ENDIF.
ELSE.
  DATA: lr_mime_rep TYPE REF TO if_mr_api.

  DATA: lv_filename TYPE string.
  DATA: lv_path     TYPE string.
  DATA: lv_fullpath TYPE string.
  DATA: lv_content  TYPE xstring.
  DATA: lv_length   TYPE  i.
  DATA: lv_rc TYPE sy-subrc.

  DATA: lt_file TYPE filetable.
  DATA: ls_file LIKE LINE OF lt_file.


  DATA: lt_data TYPE STANDARD TABLE OF x255.


  cl_gui_frontend_services=>file_open_dialog(
    CHANGING
      file_table              =  lt_file  " Table Holding Selected Files
      rc                      =  lv_rc  ). " Return Code, Number of Files or -1 If Error Occurred
  READ TABLE lt_file INTO ls_file INDEX 1.
  IF sy-subrc = 0.
    lv_filename = ls_file-filename.
  ENDIF.

  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = lv_filename    " Name of file
      filetype                = 'BIN'
    IMPORTING
      filelength              =  lv_length   " File length
    CHANGING
      data_tab                = lt_data    " Transfer table for file contents
    EXCEPTIONS
      OTHERS                  = 19 ).


  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_length
*     first_line   = 0
*     last_line    = 0
    IMPORTING
      buffer       = lv_content
    TABLES
      binary_tab   = lt_data
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.

  wa_ztest_photo-pernr = s_pernr-low.
  wa_ztest_photo-photo =  lv_content.

  MODIFY zoe_af_photo FROM wa_ztest_photo .
  COMMIT WORK AND WAIT.

  IF sy-subrc = 0.
    MESSAGE 'Successfully Uploaded' TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.
ENDIF.
