*&---------------------------------------------------------------------*
*& Report ZOE_REPORT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_report_test.

TYPE-POOLS : slis.

DATA : lt_vbak TYPE STANDARD TABLE OF vbak.
DATA : lt_fieldcatlog TYPE slis_t_fieldcat_alv.

SELECTION-SCREEN BEGIN OF BLOCK blk1.
PARAMETERS: p_vbeln LIKE vbak-vbeln.
SELECTION-SCREEN END OF BLOCK blk1.

START-OF-SELECTION.
  SELECT *
    FROM vbak
    INTO TABLE lt_vbak
    UP TO 100 ROWS
    WHERE vbeln = p_vbeln.

END-OF-SELECTION.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'VBAK'
    CHANGING
      ct_fieldcat            = lt_fieldcatlog
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  DELETE lt_fieldcatlog WHERE col_pos > 5.

  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fieldcatlog
    TABLES
      t_outtab           = lt_vbak
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
