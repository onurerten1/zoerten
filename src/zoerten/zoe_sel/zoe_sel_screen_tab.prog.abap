*&---------------------------------------------------------------------*
*& Report ZOE_SEL_SCREEN_TAB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sel_screen_tab.

DATA flag(1) TYPE c.
* SUBSCREEN 1
SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: field1(20) TYPE c,
            field2(20) TYPE c,
            field3(20) TYPE c.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN END OF SCREEN 100.
* SUBSCREEN 2
SELECTION-SCREEN BEGIN OF SCREEN 200 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: q1(20) TYPE c,
            q2(20) TYPE c,
            q3(20) TYPE c.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF SCREEN 200.
* STANDARD SELECTION SCREEN
SELECTION-SCREEN: BEGIN OF TABBED BLOCK mytab FOR 10 LINES,
                  TAB (20) button1 USER-COMMAND push1,
                  TAB (20) button2 USER-COMMAND push2,
                  END OF BLOCK mytab.

INITIALIZATION.
  button1 = 'TAB1'.
  button2 = 'TAB2'.
  mytab-prog = sy-repid.
  mytab-dynnr = 100.
  mytab-activetab = 'BUTTON1'.

AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN 1000.
      CASE sy-ucomm.
        WHEN 'PUSH1'.
          mytab-dynnr = 100.
          mytab-activetab = 'BUTTON1'.
        WHEN 'PUSH2'.
          mytab-dynnr = 200.
          mytab-activetab = 'BUTTON2'.
      ENDCASE.
    WHEN 100.
      MESSAGE s888(sabapdocu) WITH TEXT-040 sy-dynnr.
    WHEN 200.
      MESSAGE s888(sabapdocu) WITH TEXT-050 sy-dynnr.
  ENDCASE.
MODULE init_0100 OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'MOD'.
      CASE flag.
        WHEN 'X'.
          screen-input = '1'.
        WHEN ' '.
          screen-input = '0'.
      ENDCASE.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
MODULE user_command_0100 INPUT.
  MESSAGE s888(sabapdocu) WITH TEXT-050 sy-dynnr.
  CASE sy-ucomm.
    WHEN 'TOGGLE'.
      IF flag = ' '.
        flag = 'X'.
      ELSEIF flag = 'X'.
        flag = ' '.
      ENDIF.
  ENDCASE.
ENDMODULE.

START-OF-SELECTION.
  WRITE: / 'Field1:', field1,'Q1:', q1,
         / 'Field2:', field2,'Q2:', q2,
         / 'Field3:', field3,'Q3:', q3.
