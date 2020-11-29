*&---------------------------------------------------------------------*
*& Report ZOE_TRIGGER_EVENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_trigger_event.

CALL FUNCTION 'BP_EVENT_RAISE'
  EXPORTING
    eventid                = 'ZOE_EVENT'
  EXCEPTIONS
    bad_eventid            = 1
    eventid_does_not_exist = 2
    eventid_missing        = 3
    raise_failed           = 4
    OTHERS                 = 5.
IF sy-subrc <> 0.
  WRITE: 'Event failed to trigger'.
ELSE.
  WRITE: 'Event triggered'.
ENDIF.
