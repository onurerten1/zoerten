*&---------------------------------------------------------------------*
*& Report ZOE_EVENT_TRIGGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_event_trigger.

DATA: key LIKE sweinstcou-objkey.

key = 'OE-0001-TEST'.

CALL FUNCTION 'SWE_EVENT_CREATE'
  EXPORTING
    objtype           = 'BUS1001006'
    objkey            = key
    event             = 'CREATED'
*   CREATOR           = ' '
*   TAKE_WORKITEM_REQUESTER       = ' '
*   START_WITH_DELAY  = ' '
*   START_RECFB_SYNCHRON          = ' '
*   NO_COMMIT_FOR_QUEUE           = ' '
*   DEBUG_FLAG        = ' '
*   NO_LOGGING        = ' '
*   IDENT             =
*   IMPORTING
*   EVENT_ID          =
*   RECEIVER_COUNT    =
*   TABLES
*   EVENT_CONTAINER   =
  EXCEPTIONS
    objtype_not_found = 1
    OTHERS            = 2.

IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ELSE.
  WRITE 'Event Triggered'.
ENDIF.

COMMIT WORK.
