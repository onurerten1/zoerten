*&---------------------------------------------------------------------*
*& Report ZOE_TEXT_CONTROL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_text_control.
*/.. Data Declaration
TABLES : sscrfields.

DATA : gv_icon_name        TYPE iconname,
       gv_quickinfo        LIKE smp_dyntxt-quickinfo,
       gv_okcode           TYPE sy-ucomm,
       gv_icon_result(255) TYPE c.

DATA: gv_container   TYPE REF TO cl_gui_custom_container,
      gv_text_editor TYPE REF TO cl_gui_textedit,
      gv_text_newtxt TYPE string,
      gv_text_oldtxt TYPE string,
      gi_texttab     TYPE soli_tab.

CONSTANTS : gc_button_text TYPE c LENGTH 10 VALUE 'TE'.

*/.. Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*/.. Parameter for Text Edit Control
PARAMETERS: p_text      TYPE char40 MODIF ID md1.
SELECTION-SCREEN PUSHBUTTON 75(8) but1 USER-COMMAND click MODIF ID md1.
SELECTION-SCREEN END OF BLOCK b1.

***********************************************************************
*                  I N I T I A L I Z A T I O N                        *
***********************************************************************
INITIALIZATION.

  gv_icon_name =  'ICON_DISPLAY_MORE'.
  gv_quickinfo =  'TE'.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = gv_icon_name
      text                  = gc_button_text
      info                  = gv_quickinfo
    IMPORTING
      result                = gv_icon_result
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.

  IF sy-subrc EQ 0.
    but1 = gv_icon_result.
  ENDIF.

*---------------------------------------------------------------------*
* At selection-screen
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
*/.. Open text editor on click of the button.
  IF sscrfields-ucomm EQ 'CLICK'.
    CALL SCREEN 9001 STARTING AT 10 5.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'POPUP'.
  SET TITLEBAR 'POPUP'.

  IF gv_container IS INITIAL.
    CREATE OBJECT gv_container
      EXPORTING
        container_name              = 'CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

  ENDIF.

  CREATE OBJECT gv_text_editor
    EXPORTING
      parent                 = gv_container
      wordwrap_mode          = '2'
      wordwrap_position      = '250'
    EXCEPTIONS
      error_cntl_create      = 1
      error_cntl_init        = 2
      error_cntl_link        = 3
      error_dp_create        = 4
      gui_type_not_supported = 5.

  gv_text_newtxt = p_text.

  IF gv_text_newtxt <> gv_text_oldtxt.

    REFRESH gi_texttab.
    APPEND gv_text_newtxt TO gi_texttab.

  ENDIF.

  gv_text_editor->set_text_as_r3table( EXPORTING table = gi_texttab[] ).

  gv_text_oldtxt = gv_text_newtxt.

*/.. Set focus on the editor.
  CALL METHOD cl_gui_docking_container=>set_focus
    EXPORTING
      control = gv_text_editor.

  CALL METHOD gv_text_editor->set_readonly_mode
    EXPORTING
      readonly_mode          = 0
    EXCEPTIONS
      error_cntl_call_method = 1
      invalid_parameter      = 2
      OTHERS                 = 3.

ENDMODULE.                 " STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CASE sy-ucomm.
    WHEN 'OK'.
      gv_text_editor->get_text_as_r3table( IMPORTING table =
      gi_texttab[] ).
      EXPORT tab FROM gi_texttab[] TO MEMORY ID 'ABC' COMPRESSION ON.

      CALL METHOD cl_gui_cfw=>flush
        EXCEPTIONS
          OTHERS = 3.
      SET SCREEN 0.LEAVE SCREEN.

    WHEN 'CANCEL'.
      SET SCREEN 0.LEAVE SCREEN.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9001  INPUT
