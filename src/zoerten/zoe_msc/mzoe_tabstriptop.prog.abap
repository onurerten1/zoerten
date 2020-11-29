*&---------------------------------------------------------------------*
*& Include MZOE_TABSTRIPTOP
*&---------------------------------------------------------------------*

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'TABSTRIP'
CONSTANTS: BEGIN OF C_TABSTRIP,
             TAB1 LIKE SY-UCOMM VALUE 'TABSTRIP_FC1',
             TAB2 LIKE SY-UCOMM VALUE 'TABSTRIP_FC2',
           END OF C_TABSTRIP.
*&SPWIZARD: DATA FOR TABSTRIP 'TABSTRIP'
CONTROLS:  TABSTRIP TYPE TABSTRIP.
DATA:      BEGIN OF G_TABSTRIP,
             SUBSCREEN   LIKE SY-DYNNR,
             PROG        LIKE SY-REPID VALUE 'SAPMZOE_TABSTRIP',
             PRESSED_TAB LIKE SY-UCOMM VALUE C_TABSTRIP-TAB1,
           END OF G_TABSTRIP.
DATA:      OK_CODE LIKE SY-UCOMM.
