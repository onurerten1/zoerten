*&---------------------------------------------------------------------*
*& Report ZOE_AF_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_af_mail_attachment.

DATA: l_fm_name       TYPE rs38l_fnam,
      l_formname      TYPE fpname VALUE 'ZOE_AF_MAIL_ATTCH',
      fp_docparams    TYPE sfpdocparams,
      fp_formoutput   TYPE fpformoutput,
      fp_outputparams TYPE sfpoutputparams.
DATA: t_att_content_hex TYPE solix_tab.

START-OF-SELECTION.
  PERFORM get_function_module.
  PERFORM convert_pdf_binary.
  PERFORM mail_attachment.
*&---------------------------------------------------------------------*
*&      Form  GET_FUNCTION_MODULE
*&---------------------------------------------------------------------
FORM get_function_module .

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = l_formname
    IMPORTING
      e_funcname = l_fm_name.
*   E_INTERFACE_TYPE           =
  fp_outputparams-nodialog = 'X'.
  fp_outputparams-getpdf   = 'X'.

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

*  fp_docparams-langu = 'X'.
*  fp_docparams-country = 'US'.
*  fp_docparams-fillable = 'X'.

  CALL FUNCTION l_fm_name
    EXPORTING
      /1bcdwb/docparams  = fp_docparams
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
*   IMPORTING
*     E_RESULT             = result
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN OTHERS.
    ENDCASE.                           " CASE sy-subrc
  ENDIF.                               " IF sy-subrc <> 0.

ENDFORM.                    " GET_FUNCTION_MODULE
*&---------------------------------------------------------------------*
*&      Form  CONVERT_PDF_BINARY
*&---------------------------------------------------------------------
FORM convert_pdf_binary .
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = fp_formoutput-pdf
*     APPEND_TO_TABLE       = ' '
* IMPORTING
*     OUTPUT_LENGTH         =
    TABLES
      binary_tab = t_att_content_hex.
ENDFORM.                    " CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*&      Form  MAIL_ATTACHMENT
*&---------------------------------------------------------------------
FORM mail_attachment .
  CLASS cl_bcs DEFINITION LOAD.

  DATA: lo_send_request TYPE REF TO cl_bcs VALUE IS INITIAL.
  lo_send_request = cl_bcs=>create_persistent( ).

* Message body and subject
  DATA: lt_message_body TYPE bcsy_text VALUE IS INITIAL,
        lo_document     TYPE REF TO cl_document_bcs VALUE IS INITIAL.
  APPEND 'Deneme Mail' TO lt_message_body.
  lo_document = cl_document_bcs=>create_document(
  i_type = 'RAW'
  i_text = lt_message_body
  i_subject = 'Mail Deneme' ).

  DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL.

  TRY.
      lo_document->add_attachment(
      EXPORTING
      i_attachment_type = 'PDF'
      i_attachment_subject = 'DENEME FORM'
* I_ATTACHMENT_SIZE =
* I_ATTACHMENT_LANGUAGE = SPACE
* I_ATT_CONTENT_TEXT =
* I_ATTACHMENT_HEADER =
      i_att_content_hex = t_att_content_hex ).
    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

* Create sender
  DATA: lo_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL,
        l_send    TYPE adr6-smtp_addr VALUE 'onur.erten@mbis.com.tr'.
*  lo_sender = cl_cam_address_bcs=>create_internet_address( l_send ).
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
  lo_send_request->set_sender(
  EXPORTING
  i_sender = lo_sender ).

* Create recipient
  DATA: lo_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL.
*  lo_recipient = cl_sapuser_bcs=>create( sy-uname ).
  lo_recipient = cl_cam_address_bcs=>create_internet_address( l_send ).

** Set recipient
  lo_send_request->add_recipient(
  EXPORTING
  i_recipient = lo_recipient
  i_express = 'X' ).
*  lo_send_request->add_recipient(
*  EXPORTING
*  i_recipient = lo_recipient
*  i_express = 'X' ).

* Send email
  DATA: lv_sent_to_all(1) TYPE c VALUE IS INITIAL.
  lo_send_request->send(
  EXPORTING
  i_with_error_screen = 'X'
  RECEIVING
  result = lv_sent_to_all ).
  COMMIT WORK.
  MESSAGE 'Mailed' TYPE 'I'.


ENDFORM.                    " MAIL_ATTACHMENT
