*&---------------------------------------------------------------------*
*& Report ZOE_HTML_TABLE1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_html_table1.
*----------------------------------------------------------------*
*        D A T A   D E C L A R A T I O N
*----------------------------------------------------------------*
*-HTML Table
DATA:
  t_html    TYPE STANDARD TABLE OF w3html WITH HEADER LINE,
  " Html Table
*- Declare Internal table and Fieldcatalog
  it_flight TYPE STANDARD TABLE OF sflight WITH HEADER LINE,
  " Flights Details
  it_fcat   TYPE lvc_t_fcat WITH HEADER LINE.
" Fieldcatalog
*-Variables
DATA:
  v_lines     TYPE i,
  v_field(40).
*-Fieldsymbols
FIELD-SYMBOLS: <fs> TYPE any.
*----------------------------------------------------------------*
*        S T A R T - O F - S E L E C T I O N
*----------------------------------------------------------------*
START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO TABLE it_flight
    UP TO 20 ROWS.
*----------------------------------------------------------------*
*        E N D - O F - S E L E C T I O N
*----------------------------------------------------------------*
END-OF-SELECTION.
*-Fill the Column headings and Properties
* Field catalog is used to populate the Headings and Values of
* The table cells dynamically
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SFLIGHT'
    CHANGING
      ct_fieldcat            = it_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2.
  DELETE it_fcat WHERE fieldname = 'MANDT'.
  t_html-line = '<html>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '<thead>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '<tr>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '<td><h1>Flights Details</h1></td>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '</tr>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '</thead>'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '<table border = "1">'.
  APPEND t_html.
  CLEAR t_html.
  t_html-line = '<tr>'.
  APPEND t_html.
  CLEAR t_html.
*-Populate HTML columns from Filedcatalog
  LOOP AT it_fcat.
    CONCATENATE '<th bgcolor = "green" fgcolor = "black">'
        it_fcat-scrtext_l
        '</th>' INTO t_html-line.
    APPEND t_html.
    CLEAR t_html.
  ENDLOOP.
  t_html-line = '</tr>'.
  APPEND t_html.
  CLEAR t_html.
  DESCRIBE TABLE it_fcat LINES v_lines.
*-Populate HTML table from Internal table data
  LOOP AT it_flight.
    t_html-line = '<tr>'.
    APPEND t_html.
    CLEAR t_html.
*-Populate entire row of HTML table Dynamically
*-With the Help of Fieldcatalog.
    DO v_lines TIMES.
      READ TABLE it_fcat INDEX sy-index.
      CONCATENATE 'IT_FLIGHT-' it_fcat-fieldname INTO v_field.
      ASSIGN (v_field) TO <fs>.
      t_html-line = '<td>'.
      APPEND t_html.
      CLEAR t_html.
      t_html-line = <fs>.
      APPEND t_html.
      CLEAR t_html.
      t_html-line = '</td>'.
      APPEND t_html.
      CLEAR t_html.
      CLEAR v_field.
      UNASSIGN <fs>.
    ENDDO.
    t_html-line = '</tr>'.
    APPEND t_html.
    CLEAR t_html.
  ENDLOOP.
  t_html-line = '</table>'.
  APPEND t_html.
  CLEAR t_html.
*-Download  the HTML into frontend
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = 'C:\Users\OERTEN\Documents\ABAP Belgeler\flights.htm'
    TABLES
      data_tab                = t_html
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
*-Display the HTML file
  CALL METHOD cl_gui_frontend_services=>execute
    EXPORTING
      document               = 'C:\Users\OERTEN\Documents\ABAP Belgeler\flights.htm'
      operation              = 'OPEN'
    EXCEPTIONS
      cntl_error             = 1
      error_no_gui           = 2
      bad_parameter          = 3
      file_not_found         = 4
      path_not_found         = 5
      file_extension_unknown = 6
      error_execute_failed   = 7
      synchronous_failed     = 8
      not_supported_by_gui   = 9
      OTHERS                 = 10.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
