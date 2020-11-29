*&---------------------------------------------------------------------*
*& Report ZOE_TEXT_TO_SPEECH
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_text_to_speech.

INCLUDE ole2incl.

DATA : ole   TYPE ole2_object,
       voice TYPE ole2_object,
       text  TYPE string.

CREATE OBJECT voice 'SAPI.SpVoice'.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_text LIKE text.
SELECTION-SCREEN END OF BLOCK blk1.

text = p_text.

*DO 5 TIMES.
  CALL METHOD OF voice 'Speak' = ole
    EXPORTING #1 = text.
*ENDDO.
