*&---------------------------------------------------------------------*
*& Report ZOE_SEND_MAIL_TABLE_HTML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_send_mail_table_html.

CONSTANTS: gc_subject TYPE so_obj_des VALUE 'Mail Test',
           gc_htm     TYPE char03 VALUE 'HTM'.

DATA: gv_mlrec         TYPE so_obj_nam,
      gv_sent_to_all   TYPE os_boolean,
      gv_email         TYPE adr6-smtp_addr,
      gv_subject       TYPE so_obj_des,
      gv_text          TYPE bcsy_text,
      gr_send_request  TYPE REF TO cl_bcs,
      gr_bcs_exception TYPE REF TO cx_bcs,
      gr_recipient     TYPE REF TO if_recipient_bcs,
      gr_sender        TYPE REF TO cl_sapuser_bcs,
      gr_document      TYPE REF TO cl_document_bcs.

DATA: BEGIN OF gs_data,
        matnr LIKE mara-matnr,
        maktx LIKE makt-maktx,
        matkl LIKE mara-matkl,
        mtart LIKE mara-mtart,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.

DATA: gs_mail LIKE zoe_mail_list,
      gt_mail LIKE TABLE OF gs_mail.

CLASS lcl_handle_events DEFINITION DEFERRED.
DATA: gr_table   TYPE REF TO cl_salv_table.
DATA: gr_events  TYPE REF TO lcl_handle_events.
DATA: g_okcode   TYPE syucomm.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function,

      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column,

      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column.
ENDCLASS.
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.

  METHOD on_double_click.
    PERFORM handle_double_click USING row
                                      column.
  ENDMETHOD.

  METHOD on_link_click.
    PERFORM handle_link_click USING row
                                    column.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  SELECT m~matnr,
         t~maktx,
         m~matkl,
         m~mtart
    FROM mara AS m
    LEFT OUTER JOIN makt AS t ON m~matnr = t~matnr
    AND                          t~spras = @sy-langu
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    UP TO 50 ROWS
  ORDER BY m~matnr.

  SELECT *
    FROM zoe_mail_list
    INTO TABLE @gt_mail.

END-OF-SELECTION.

  DATA: salv_exception TYPE REF TO cx_salv_msg.
  DATA: salv_columns   TYPE REF TO cl_salv_columns.
  DATA: salv_layout  TYPE REF TO cl_salv_layout,
        salv_variant TYPE slis_vari,
        salv_key     TYPE salv_s_layout_key.
  DATA: salv_events TYPE REF TO cl_salv_events_table.
  DATA: salv_selections TYPE REF TO cl_salv_selections.
  TRY.
      cl_salv_table=>factory(
            IMPORTING
              r_salv_table = gr_table
            CHANGING
              t_table      = gt_data
          ).

      gr_table->get_display_settings( )->set_striped_pattern( abap_true ).
      gr_table->get_columns( )->set_optimize( abap_true ).
      gr_table->get_functions( )->set_all( abap_true ).

      gr_table->set_screen_status(
        EXPORTING
          report        = sy-repid
          pfstatus      = 'SALV_STANDARD'
          set_functions = gr_table->c_functions_all
      ).
      salv_selections = gr_table->get_selections( ).
      salv_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      salv_layout = gr_table->get_layout( ).
      salv_columns = gr_table->get_columns( ).
      salv_columns->set_optimize( abap_true ).
      salv_key-report = sy-repid.
      salv_layout->set_key( salv_key ).
      salv_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

      salv_events = gr_table->get_event( ).
      CREATE OBJECT gr_events.
      SET HANDLER gr_events->on_user_command FOR salv_events.
      SET HANDLER gr_events->on_link_click FOR salv_events.
      SET HANDLER gr_events->on_double_click FOR salv_events.

      PERFORM change_column USING salv_columns:
      "FIELD       TECH  INVS HOTS  KEY  CURR QUAN  L-M Text   S Text
      'MANDT' '' 'X' '' '' '' '' '' ''.

      gr_table->display( ).

    CATCH cx_salv_msg INTO salv_exception.
  ENDTRY.
*&---------------------------------------------------------------------*
*& Form CHANGE_COLUMN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SALV_COLUMNS
*&      --> GR_TABLE_>DISPLAY(
*&      --> )
*&---------------------------------------------------------------------*
FORM change_column  USING po_columns TYPE REF TO cl_salv_columns
                          pv_fieldname TYPE c
                          pv_technical TYPE c
                          pv_invisible TYPE c
                          pv_hotspot   TYPE c
                          pv_key       TYPE c
                          pv_currref   TYPE c
                          pv_quanref   TYPE c
                          pv_fieldtextlm TYPE c
                          pv_fieldtexts TYPE c.

  DATA lo_column  TYPE REF TO cl_salv_column_table.
  DATA lv_short TYPE scrtext_s.
  DATA lv_medium TYPE scrtext_m.
  DATA lv_long TYPE scrtext_l.
  TRY .
      lo_column ?= po_columns->get_column( pv_fieldname ).
      IF pv_technical IS NOT INITIAL.
        lo_column->set_technical( abap_true ).
      ENDIF.
      IF pv_invisible IS NOT INITIAL.
        lo_column->set_visible( abap_false ).
        RETURN.
      ENDIF.
      IF pv_key IS NOT INITIAL.
        lo_column->set_key( value = if_salv_c_bool_sap=>true ).
      ENDIF.
      IF pv_hotspot IS NOT INITIAL.
        lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
      ENDIF.
      IF pv_currref IS NOT INITIAL.
        lo_column->set_currency_column( pv_currref ).
      ELSEIF pv_quanref IS NOT INITIAL.
        lo_column->set_quantity_column( pv_quanref ).
      ENDIF.
      IF pv_fieldtextlm IS NOT INITIAL.
        lv_medium = lv_long = pv_fieldtextlm.
        lo_column->set_medium_text( lv_medium ).
        lo_column->set_long_text( lv_long ).
      ENDIF.
      IF pv_fieldtexts IS NOT INITIAL.
        lv_short = pv_fieldtexts.
        lo_column->set_short_text( lv_short ).
      ENDIF.
    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command  USING i_ucomm TYPE salv_de_function.

  CASE i_ucomm.
    WHEN 'MAIL'.
      PERFORM send_mail.
*  	WHEN .
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING p_row TYPE salv_de_row
                                p_column TYPE salv_de_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_LINK_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_link_click  USING p_row TYPE salv_de_row
                              p_column TYPE salv_de_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_MAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM send_mail .

  DATA: lo_column   TYPE REF TO  cl_salv_column_list.

  DATA(lt_selections) = gr_table->get_selections( ).
  DATA(lt_rows) = lt_selections->get_selected_rows( ).
  DATA(lo_cols) = gr_table->get_columns( ).
  DATA(lt_cols) = lo_cols->get( ).

  APPEND '<!DOCTYPE html>' TO gv_text.
  APPEND '<html>' TO gv_text.
  APPEND '<head>' TO gv_text.
  APPEND '<style>' TO gv_text.
  APPEND 'table,' TO gv_text.
  APPEND 'th,' TO gv_text.
  APPEND 'td {' TO gv_text.
  APPEND 'border-collapse: separate;' TO gv_text.
  APPEND 'border-style: double;' TO gv_text.
  APPEND '}' TO gv_text.
  APPEND 'th,' TO gv_text.
  APPEND 'td {' TO gv_text.
  APPEND 'padding: 15px;' TO gv_text.
  APPEND '}' TO gv_text.
  APPEND 'h2 {' TO gv_text.
  APPEND 'font-family: Calibri;' TO gv_text.
  APPEND '}' TO gv_text.
  APPEND 'pre {' TO gv_text.
  APPEND 'font-family: Calibri;' TO gv_text.
  APPEND '}' TO gv_text.
  APPEND '</style>' TO gv_text.
  APPEND '</head>' TO gv_text.
  APPEND '<body>' TO gv_text.
  APPEND '<h2>Material Table</h2>' TO gv_text.
  APPEND '<p>' TO gv_text.
  APPEND '<pre>Sayın ilgili,</pre>' TO gv_text.
  APPEND '<br>' TO gv_text.
  APPEND '<pre>Malzemeler ile ilgili tablo aşağıdadır.</pre>' TO gv_text.
  APPEND '<br>' TO gv_text.
  APPEND '<pre>İyi Çalışmalar.</pre>' TO gv_text.
  APPEND '</p>' TO gv_text.
  APPEND '<br>' TO gv_text.
  APPEND '<table style="width: 100%;">' TO gv_text.
  APPEND '<tr>' TO gv_text.

  LOOP AT lt_cols INTO DATA(ls_cols).
    lo_column ?= ls_cols-r_column.
    DATA(lv_head) = '<th>' && lo_column->get_medium_text( ) && '</th>'.
    APPEND lv_head TO  gv_text.
  ENDLOOP.

  APPEND '</tr>' TO gv_text.

  LOOP AT lt_rows INTO DATA(ls_rows).
    APPEND '<tr>' TO gv_text.
    READ TABLE gt_data INTO gs_data INDEX ls_rows.
    DATA(lv_matnr) = '<td>' && |{ gs_data-matnr ALPHA = OUT }| && '</td>'.
    APPEND lv_matnr TO gv_text.
    DATA(lv_maktx) = '<td>' && gs_data-maktx && '</td>'.
    APPEND lv_maktx TO gv_text.
    DATA(lv_matkl) = '<td>' && gs_data-matkl && '</td>'.
    APPEND lv_matkl TO gv_text.
    DATA(lv_mtart) = '<td>' && gs_data-mtart && '</td>'.
    APPEND lv_mtart TO gv_text.
    APPEND '</tr>' TO gv_text.
  ENDLOOP.

  APPEND '</table>' TO gv_text.
  APPEND '</body>' TO gv_text.
  APPEND '</html>' TO gv_text.

  TRY.
      "Create send request
      gr_send_request = cl_bcs=>create_persistent( ).

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
