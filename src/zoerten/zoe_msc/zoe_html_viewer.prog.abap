*&---------------------------------------------------------------------*
*& Report ZOE_HTML_VIEWER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_html_viewer.

TYPES : BEGIN OF y_html,
          dataset(255) TYPE c,
        END OF y_html.

DATA: e_data  TYPE y_html,
      ts_data TYPE STANDARD TABLE OF y_html,
      e_user  TYPE usr03,
      ok_code TYPE sy-ucomm,
      w_uname TYPE char20,
      w_url   TYPE char255.

DATA : ref_cont TYPE REF TO cl_gui_custom_container,
       ref_html TYPE REF TO cl_gui_html_viewer.

PARAMETERS p_url(255) DEFAULT 'https://www.google.com/'.

START-OF-SELECTION.

  PERFORM f_genearte_html.

  CALL SCREEN 9000.
*&---------------------------------------------------------------------*
*& Form F_GENEARTE_HTML
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_genearte_html .

  w_url = p_url.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'STATUS9000'.
  SET TITLEBAR 'HTML Page'.

  CREATE OBJECT ref_cont
    EXPORTING
      container_name              = 'CONT'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  IF sy-subrc <> 0.

  ENDIF.

  CREATE OBJECT ref_html
    EXPORTING
      parent             = ref_cont
    EXCEPTIONS
      cntl_error         = 1
      cntl_install_error = 2
      dp_install_error   = 3
      dp_error           = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.

  ENDIF.


  CALL METHOD ref_html->load_data
    EXPORTING
      type                 = 'text'
      subtype              = 'html'
    IMPORTING
      assigned_url         = w_url
    CHANGING
      data_table           = ts_data
    EXCEPTIONS
      dp_invalid_parameter = 1
      dp_error_general     = 2
      cntl_error           = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.

  ENDIF.

  CALL METHOD ref_html->show_url
    EXPORTING
      url                    = p_url
    EXCEPTIONS
      cntl_error             = 1
      cnht_error_not_allowed = 2
      cnht_error_parameter   = 3
      dp_error_general       = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
*	WHEN .
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
