*&---------------------------------------------------------------------*
*& Report ZOE_DYNAMIC_TABLE_SELECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_dynamic_table_select.

*"Type-pool............................................................
TYPE-POOLS : slis.

*"Parameters elements..................................................
PARAMETERS : p_table TYPE tabname OBLIGATORY,       " Table Name
             p_no    TYPE i .         " No of Records to be displayed

DATA:
  w_dref TYPE REF TO data,          " w_dref reference variable
  t_line TYPE c LENGTH 20.          " w_line to hold a line

DATA :
  t_fcat  TYPE slis_t_fieldcat_alv.

FIELD-SYMBOLS: <t_itab> TYPE STANDARD TABLE.

START-OF-SELECTION.
  SELECT SINGLE
         tabname                       " Table Name
    FROM dd02l
    INTO t_line
   WHERE tabname   EQ p_table
     AND as4vers   EQ ' '
     AND as4local  EQ 'A'
     AND tabclass  NE 'INTTAB'
     AND tabclass  NE 'APPEND'.

  IF sy-subrc EQ 0.
    CREATE DATA w_dref TYPE STANDARD TABLE OF (p_table).
    ASSIGN w_dref->* TO <t_itab>.
    IF sy-subrc EQ 0.
      SELECT *                         " All Fields
        FROM (p_table)
        INTO TABLE <t_itab> UP TO p_no ROWS.

      IF sy-subrc EQ 0.
        PERFORM fill_catalog.
        PERFORM display.
      ELSE.
        MESSAGE TEXT-002 TYPE 'S'.
        EXIT.
      ENDIF.                           " IF sy-subrc EQ 0...
    ELSE.
      MESSAGE TEXT-003 TYPE 'S'.
      EXIT.
    ENDIF.
  ELSE.
    MESSAGE TEXT-003 TYPE 'S'.
    LEAVE LIST-PROCESSING.
  ENDIF.                               " IF sy-subrc EQ 0...

FORM display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = t_fcat
    TABLES
      t_outtab      = <t_itab>
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE 'E'
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    EXIT.
  ENDIF.                               " IF sy-subrc <> 0...
ENDFORM.                               " DISPLAY

FORM fill_catalog .
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = p_table
    CHANGING
      ct_fieldcat            = t_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE 'E'
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    EXIT.
  ENDIF.                               " IF sy-subrc <> 0...
ENDFORM.
