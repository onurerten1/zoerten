*&---------------------------------------------------------------------*
*& Include          ZOE_CL_MAIL_SEND_F01
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

    SELECT *
      FROM zoe_mail_list
      INTO TABLE @gt_mail
      WHERE uname = @sy-uname.

    IF sy-subrc <> 0.
      MESSAGE 'İlgili mail adresiniz yok' TYPE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.

    IF p_raw = 'X'.
      PERFORM send_raw.
    ELSEIF p_html = 'X'.
      PERFORM send_html.
    ELSEIF p_attch = 'X'.
      PERFORM send_attch.
    ENDIF.

  ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_RAW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
  FORM send_raw.

    TRY.
        "Create send request
        gr_send_request = cl_bcs=>create_persistent( ).


        "Email FROM...
        gr_sender = cl_sapuser_bcs=>create( sy-uname ).
        "Add sender to send request
        CALL METHOD gr_send_request->set_sender
          EXPORTING
            i_sender = gr_sender.


        "Email TO...
        LOOP AT gt_mail INTO gs_mail.
          IF gs_mail-email IS NOT INITIAL.
            gv_email = gs_mail-email.
            gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
            "Add recipient to send request
            CALL METHOD gr_send_request->add_recipient
              EXPORTING
                i_recipient = gr_recipient
                i_express   = 'X'.
          ENDIF.
        ENDLOOP.

        "Email BODY
        APPEND 'Test' TO gv_text.
        gr_document = cl_document_bcs=>create_document(
                        i_type    = gc_raw
                        i_text    = gv_text
                        i_length  = '12'
                        i_subject = gc_subject ).
        "Add document to send request
        CALL METHOD gr_send_request->set_document( gr_document ).


        "Send email
        CALL METHOD gr_send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = gv_sent_to_all ).
        IF gv_sent_to_all = 'X'.
          WRITE 'Email sent!'.
        ENDIF.

        "Commit to send email
        COMMIT WORK.


        "Exception handling
      CATCH cx_bcs INTO gr_bcs_exception.
        WRITE:
          'Error!',
          'Error type:',
          gr_bcs_exception->error_type.
    ENDTRY.

  ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_HTML
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
  FORM send_html .


    TRY.
        "Create send request
        gr_send_request = cl_bcs=>create_persistent( ).

        "Email body
        APPEND '<html>' TO gv_text.
        APPEND '<body>' TO gv_text.
        APPEND '<h1>Heading</h1>' TO gv_text.
        APPEND '<p>Paragraph</p>' TO gv_text.
        APPEND '<a href="http://www.google.com">Link</a>' TO gv_text.
        APPEND '<u1>' TO gv_text.
        APPEND '<li>Coffee</li>' TO gv_text.
        APPEND '<li>Tea</li>' TO gv_text.
        APPEND '<li>Milk</li>' TO gv_text.
        APPEND '</u1>' TO gv_text.
        APPEND '<o1>' TO gv_text.
        APPEND '<li>Coffee</li>' TO gv_text.
        APPEND '<li>Tea</li>' TO gv_text.
        APPEND '<li>Milk</li>' TO gv_text.
        APPEND '</o1>' TO gv_text.
        APPEND '</body>' TO gv_text.
        APPEND '</html>' TO gv_text.

        "Create document
        gr_document = cl_document_bcs=>create_document(
                        i_type    = gc_htm
                        i_text    = gv_text
                        i_subject = gc_subject ).

        "Add document to send request
        CALL METHOD gr_send_request->set_document( gr_document ).

        "Email from
        gr_sender = cl_sapuser_bcs=>create( sy-uname ).

        "Add sender to send request
        CALL METHOD gr_send_request->set_sender
          EXPORTING
            i_sender = gr_sender.


        "Email to
        LOOP AT gt_mail INTO gs_mail.
          IF gs_mail-email IS NOT INITIAL.
            gv_email = gs_mail-email.
            gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
            "Add recipient to send request
            CALL METHOD gr_send_request->add_recipient
              EXPORTING
                i_recipient = gr_recipient
                i_express   = 'X'.
          ENDIF.
        ENDLOOP.

        "Send email
        CALL METHOD gr_send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = gv_sent_to_all ).
        IF gv_sent_to_all = 'X'.
          WRITE 'Email sent!'.
        ENDIF.

        "Commit to send email
        COMMIT WORK.


        "Exception handling
      CATCH cx_bcs INTO gr_bcs_exception.
        WRITE:
          'Error!',
          'Error type:',
          gr_bcs_exception->error_type.
    ENDTRY.

  ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_ATTCH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
  FORM send_attch .

    TRY.
        "Create send request
        gr_send_request = cl_bcs=>create_persistent( ).

        "Email body
        APPEND '<html>' TO gv_text.
        APPEND '<body>' TO gv_text.
        APPEND '<h1>Heading</h1>' TO gv_text.
        APPEND '<p>Paragraph</p>' TO gv_text.
        APPEND '<a href="http://www.google.com">Link</a>' TO gv_text.
        APPEND '<u1>' TO gv_text.
        APPEND '<li>Coffee</li>' TO gv_text.
        APPEND '<li>Tea</li>' TO gv_text.
        APPEND '<li>Milk</li>' TO gv_text.
        APPEND '</u1>' TO gv_text.
        APPEND '<o1>' TO gv_text.
        APPEND '<li>Coffee</li>' TO gv_text.
        APPEND '<li>Tea</li>' TO gv_text.
        APPEND '<li>Milk</li>' TO gv_text.
        APPEND '</o1>' TO gv_text.
        APPEND '</body>' TO gv_text.
        APPEND '</html>' TO gv_text.

        "Create document
        gr_document = cl_document_bcs=>create_document(
                        i_type    = gc_htm
                        i_text    = gv_text
                        i_subject = gc_subject ).

        "Add attachment
        gr_document->add_attachment(
          EXPORTING
            i_attachment_type     = gc_htm
            i_attachment_subject  = 'Attachment'
            i_att_content_text    = gv_text ).


        "Add document to send request
        CALL METHOD gr_send_request->set_document( gr_document ).

        "Email from
        gr_sender = cl_sapuser_bcs=>create( sy-uname ).

        "Add sender to send request
        CALL METHOD gr_send_request->set_sender
          EXPORTING
            i_sender = gr_sender.


        "Email to
        LOOP AT gt_mail INTO gs_mail.
          IF gs_mail-email IS NOT INITIAL.
            gv_email = gs_mail-email.
            gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
            "Add recipient to send request
            CALL METHOD gr_send_request->add_recipient
              EXPORTING
                i_recipient = gr_recipient
                i_express   = 'X'.
          ENDIF.
        ENDLOOP.

        "Send email
        CALL METHOD gr_send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = gv_sent_to_all ).
        IF gv_sent_to_all = 'X'.
          WRITE 'Email sent!'.
        ENDIF.

        "Commit to send email
        COMMIT WORK.


        "Exception handling
      CATCH cx_bcs INTO gr_bcs_exception.
        WRITE:
          'Error!',
          'Error type:',
          gr_bcs_exception->error_type.
    ENDTRY.

  ENDFORM.
