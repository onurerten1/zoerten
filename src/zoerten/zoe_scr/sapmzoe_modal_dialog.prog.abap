*&---------------------------------------------------------------------*
*& Modulpool SAPMZOE_MODAL_DIALOG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzoe_modal_dialog.
TABLES mara.
TYPES : matnr TYPE mara-matnr,
        ersda TYPE mara-ersda,
        ernam TYPE mara-ernam,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl.

START-OF-SELECTION.
  CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'DISPLAY'.
      CALL SCREEN 0110
      STARTING AT 4 10
      ENDING AT  50 20.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  SELECT SINGLE matnr,
                ersda,
                ernam,
                mtart,
                matkl
    FROM mara
    INTO ( @mara-matnr,
           @mara-ersda,
           @mara-ernam,
           @mara-mtart,
           @mara-matkl )
    WHERE matnr = @mara-matnr.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
