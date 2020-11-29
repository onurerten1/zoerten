*&---------------------------------------------------------------------*
*& Report ZOE_EMB_IMAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_emb_image.

DATA: o_mr_api         TYPE REF TO if_mr_api.

DATA is_folder TYPE boole_d.
DATA l_current TYPE xstring.
DATA l_loio TYPE skwf_io.

IF o_mr_api IS INITIAL.

  o_mr_api = cl_mime_repository_api=>if_mr_api~get_api( ).

ENDIF.

CALL METHOD o_mr_api->get
  EXPORTING
    i_url              = '/SAP/PUBLIC/SAPLOGO_BIG.bmp'
  IMPORTING
    e_is_folder        = is_folder
    e_content          = l_current
    e_loio             = l_loio
  EXCEPTIONS
    parameter_missing  = 1
    error_occured      = 2
    not_found          = 3
    permission_failure = 4.

DATA: b64data TYPE string.

CALL FUNCTION 'SSFC_BASE64_ENCODE'
  EXPORTING
    bindata = l_current
  IMPORTING
    b64data = b64data.
IF sy-subrc <> 0.

ENDIF.

DATA lv_length TYPE i.
DATA lv_len2 TYPE i.

DATA: wa_mail_body TYPE LINE OF soli_tab,
      gt_mail_body LIKE TABLE OF wa_mail_body.

CLEAR wa_mail_body.
MOVE '<html>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '<head>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '<title>Hello</title>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-   1">' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '</head>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '<body>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
wa_mail_body  = '<em><font'  .
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
wa_mail_body  = 'color="#0000FF" size="+7" face="Arial,'.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
wa_mail_body  = 'Helvetica, sans-serif">Test Image</font></em>'.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
*add image base64 content
wa_mail_body = '<img src="data:image/gif;base64,'.

APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.

lv_length = strlen( b64data ).
lv_len2 = lv_length / 255.

wa_mail_body = b64data.

APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
DATA lv_len3 TYPE i.
DATA: temp1 TYPE i,
      temp2 TYPE i.
DO lv_len2 TIMES.
  lv_len3 = 255 * sy-index.

  IF lv_len3 <= lv_length.
    wa_mail_body = b64data+lv_len3.
    IF wa_mail_body IS NOT INITIAL.
      APPEND wa_mail_body TO gt_mail_body.
      CLEAR wa_mail_body.
    ELSE.
      EXIT.
    ENDIF.
  ELSEIF lv_len3 > lv_length.

    EXIT.

  ENDIF.
ENDDO.

wa_mail_body = '"alt="Happy birthday" align="middle" width="304" height="228" />'.
APPEND wa_mail_body TO gt_mail_body.

CLEAR wa_mail_body.
MOVE '</body>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.


CLEAR wa_mail_body.
MOVE '</html>' TO wa_mail_body.
APPEND wa_mail_body TO gt_mail_body.

DATA : lt_mail_body  TYPE soli_tab,
       lwa_mail_body LIKE LINE OF lt_mail_body.

DATA: l_subject TYPE so_obj_des.

l_subject = 'Test : Image in mail'.

DATA: lr_email_body TYPE REF TO cl_document_bcs.
lr_email_body = cl_document_bcs=>create_document(
                                 i_type = 'HTM'
                                 i_text = gt_mail_body
                                 i_subject = l_subject ).
DATA: lr_email TYPE REF TO cl_bcs.
lr_email = cl_bcs=>create_persistent( ).
lr_email->set_document( lr_email_body ).

DATA: lr_receiver    TYPE REF TO cl_cam_address_bcs,
      l_mail_address TYPE adr6-smtp_addr.

l_mail_address = 'onur.erten@mbis.com.tr'.

lr_receiver = cl_cam_address_bcs=>create_internet_address( l_mail_address ).
lr_email->add_recipient( i_recipient = lr_receiver ).

"Set Sender and send mail
DATA: l_sender TYPE REF TO cl_sapuser_bcs.
l_sender = cl_sapuser_bcs=>create( sy-uname ).
lr_email->set_sender( l_sender ).
lr_email->set_send_immediately( 'X' ).  "Send email directly
DATA: l_send_result TYPE os_boolean.
l_send_result = lr_email->send( i_with_error_screen = 'X' ).

COMMIT WORK.
