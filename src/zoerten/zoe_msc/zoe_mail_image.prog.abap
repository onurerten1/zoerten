*&---------------------------------------------------------------------*
*& Report ZOE_MAIL_IMAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_mail_image.


*--------------------------------------------------------------------*
*Selection Screen
*--------------------------------------------------------------------*
PARAMETERS : p_mail TYPE adr6-smtp_addr.

*--------------------------------------------------------------------*
*Mailing Related Data Decleration
*--------------------------------------------------------------------*
DATA : ls_type     TYPE sood-objtp,

       lt_obj_head TYPE TABLE OF solisti1,
       ls_obj_head TYPE solisti1,

       lt_obj_cont TYPE TABLE OF solisti1,
       ls_obj_cont TYPE solisti1,

       lt_recever  TYPE TABLE OF somlreci1,
       ls_recever  TYPE somlreci1,

       lv_date     TYPE char10,
       lv_str      TYPE string.

*Refresh Tables
REFRESH : lt_obj_head,  lt_obj_cont, lt_recever. "lt_member.

* Type
MOVE 'HTML' TO ls_type.

DEFINE add_html.
  ls_obj_cont-line = &1.
  APPEND ls_obj_cont TO lt_obj_cont.
END-OF-DEFINITION.

*--------------------------------------------------------------------*
* Heading and Style Patterns
*--------------------------------------------------------------------*
add_html:
'<!DOCTYPE html>',
'<html>',
'<head>',
'</head>',
'<body topmargin=0 leftmargin=0>',
'<p class="blacktext"><b>',
'Self Learn SAP',
'</b></p>',
'SAP Technical',
'<img src="cid:img1.jpg">',
'SAP Functional',
'<img src="cid:img2.jpg">',
'</body>',
'</html>'.
*--------------------------------------------------------------------*
*Send Email Via Class
*--------------------------------------------------------------------*
DATA: lo_document  TYPE REF TO cl_document_bcs,
      lo_bcs       TYPE REF TO cl_bcs,
      lo_recipient TYPE REF TO if_recipient_bcs,
      lo_ex_bcs    TYPE REF TO cx_bcs,
      lv_message   TYPE string.

CLEAR: lo_document.

DATA : lv_sub TYPE so_obj_des.
lv_sub = lv_str.

lo_document = cl_document_bcs=>create_document(
i_type = 'HTM'
i_subject = lv_sub
i_text = lt_obj_cont ). "lt_txt_cont

lo_bcs = cl_bcs=>create_persistent( ).
lo_bcs->set_document( lo_document ).

lo_recipient = cl_cam_address_bcs=>create_internet_address( p_mail ).

lo_bcs->set_message_subject( ip_subject = lv_str ).   "Subject

*--------------------------------------------------------------------*
*Image from MIME
*--------------------------------------------------------------------*

DATA: o_mr_api         TYPE REF TO if_mr_api.

DATA is_folder TYPE boole_d.
DATA l_img1 TYPE xstring.
DATA l_img2 TYPE xstring.
DATA l_loio TYPE skwf_io.

IF o_mr_api IS INITIAL.

  o_mr_api = cl_mime_repository_api=>if_mr_api~get_api( ).

ENDIF.
CALL METHOD o_mr_api->get
  EXPORTING
    i_url              = '/SAP/PUBLIC/mandelbrot1.jpg'
  IMPORTING
    e_is_folder        = is_folder
    e_content          = l_img1
    e_loio             = l_loio
  EXCEPTIONS
    parameter_missing  = 1
    error_occured      = 2
    not_found          = 3
    permission_failure = 4
    OTHERS             = 5.

CALL METHOD o_mr_api->get
  EXPORTING
    i_url              = '/SAP/PUBLIC/mandelbrot2.jpg'
  IMPORTING
    e_is_folder        = is_folder
    e_content          = l_img2
    e_loio             = l_loio
  EXCEPTIONS
    parameter_missing  = 1
    error_occured      = 2
    not_found          = 3
    permission_failure = 4
    OTHERS             = 5.

*Convert XSTRING to ITAB
DATA :lt_hex1      TYPE solix_tab,
      lt_hex2      TYPE solix_tab,
      ls_hex       LIKE LINE OF lt_hex1,
      lv_img1_size TYPE sood-objlen,
      lv_img2_size TYPE sood-objlen.

CLEAR : lt_hex1, lt_hex2, ls_hex, lv_img1_size, lv_img2_size.

WHILE l_img1 IS NOT INITIAL.
  ls_hex-line = l_img1.
  APPEND ls_hex TO lt_hex1.
  SHIFT l_img1 LEFT BY 255 PLACES IN BYTE MODE.
ENDWHILE.

WHILE l_img2 IS NOT INITIAL.
  ls_hex-line = l_img2.
  APPEND ls_hex TO lt_hex2.
  SHIFT l_img2 LEFT BY 255 PLACES IN BYTE MODE.
ENDWHILE.

*Findthe Size of the image
DESCRIBE TABLE lt_hex1 LINES lv_img1_size.
DESCRIBE TABLE lt_hex2 LINES lv_img2_size.

lv_img1_size = lv_img1_size * 255.
lv_img2_size = lv_img2_size * 255.

*--------------------------------------------------------------------*
*Attach Images
*--------------------------------------------------------------------*

lo_document->add_attachment(
  EXPORTING
    i_attachment_type     =  'jpg'                  " Document Class for Attachment
    i_attachment_subject  =  'img1'                " Attachment Title
    i_attachment_size     =  lv_img1_size           " Size of Document Content
    i_att_content_hex     =  lt_hex1  " Content (Binary)
).

lo_document->add_attachment(
  EXPORTING
    i_attachment_type     =  'jpg'                  " Document Class for Attachment
    i_attachment_subject  =  'img2'                " Attachment Title
    i_attachment_size     =  lv_img2_size           " Size of Document Content
    i_att_content_hex     =  lt_hex2  " Content (Binary)
).

*--------------------------------------------------------------------*
*Add the recipient
*--------------------------------------------------------------------*
TRY.
    CALL METHOD lo_bcs->add_recipient
      EXPORTING
        i_recipient = lo_recipient
        i_express   = 'X'.
  CATCH cx_send_req_bcs.
ENDTRY.
lo_bcs->set_sender( cl_sapuser_bcs=>create( sy-uname ) ).

lo_bcs->set_send_immediately( 'X' ).

*--------------------------------------------------------------------*
*Send Mail
*--------------------------------------------------------------------*
TRY.
    CALL METHOD lo_bcs->send( ).

    COMMIT WORK.
    MESSAGE 'Send Successfully' TYPE 'S'.
  CATCH cx_bcs INTO lo_ex_bcs.
    lv_message = lo_ex_bcs->get_text( ).
ENDTRY.
