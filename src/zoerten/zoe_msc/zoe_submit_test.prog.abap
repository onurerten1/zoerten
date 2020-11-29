*&---------------------------------------------------------------------*
*& Report ZOE_SUBMIT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_submit_test.

DATA  BEGIN OF lt_list OCCURS 0.
INCLUDE STRUCTURE abaplist.
DATA  END OF lt_list.
DATA: BEGIN OF listasci OCCURS 5000,
        default(256) TYPE c,
      END OF listasci.

CALL FUNCTION 'LIST_FREE_MEMORY'
  TABLES
    listobject = lt_list.

*SUBMIT zoe_report_test AND RETURN EXPORTING LIST TO MEMORY WITH p_vbeln = '5'.
SUBMIT ZOE_SALV_PATTERN AND RETURN EXPORTING LIST TO MEMORY.

CALL FUNCTION 'LIST_FROM_MEMORY'
  TABLES
    listobject = lt_list
  EXCEPTIONS
    not_found  = 1
    OTHERS     = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'LIST_TO_ASCI'
* EXPORTING
*   LIST_INDEX               = -1
*   WITH_LINE_BREAK          = ' '
* IMPORTING
*   LIST_STRING_ASCII        =
*   LIST_DYN_ASCII           =
  TABLES
    listasci           = listasci
    listobject         = lt_list
  EXCEPTIONS
    empty_list         = 1
    list_index_invalid = 2
    OTHERS             = 3.

BREAK-POINT.
