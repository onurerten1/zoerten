*&---------------------------------------------------------------------*
*& Report ZOE_SELECTION_COMMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_selection_comment.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS r1 RADIOBUTTON GROUP rad .
SELECTION-SCREEN COMMENT 5(83) TEXT-001 FOR FIELD r1.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS r2 RADIOBUTTON GROUP rad.
SELECTION-SCREEN COMMENT 5(83) TEXT-002 FOR FIELD r2.
SELECTION-SCREEN END OF LINE.
