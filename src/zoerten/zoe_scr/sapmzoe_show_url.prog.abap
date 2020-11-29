*&---------------------------------------------------------------------*
*& Modulpool SAPMZOE_SHOW_URL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzoe_show_url.

DATA: container      TYPE REF TO cl_gui_custom_container,
      html_viewer    TYPE REF TO cl_gui_html_viewer,
      gv_init,
      gv_frame(1255),
      gv_url(255)    VALUE 'http:/www.google.com'.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS0100'.
* SET TITLEBAR 'xxx'.

  IF gv_init IS INITIAL.
    CREATE OBJECT container
      EXPORTING
        container_name = 'CONTAINER'.
    CREATE OBJECT html_viewer
      EXPORTING
        parent = container.
    IF sy-subrc NE 0.

    ENDIF.

    CALL METHOD cl_gui_cfw=>flush.

    IF sy-subrc NE 0.

    ENDIF.
    gv_init = 'X'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'DISPLAY'.
      CALL METHOD html_viewer->show_url
        EXPORTING
          url   = gv_url
          frame = gv_frame.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
