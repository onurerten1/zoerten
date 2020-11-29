*&---------------------------------------------------------------------*
*& Report ZOE_F4_HELPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_f4_helps.
PARAMETERS: p_date LIKE sy-datum DEFAULT sy-datum,
            p_time LIKE sy-uzeit DEFAULT sy-uzeit,
            p_year TYPE numc4 DEFAULT sy-datum(4).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_date.

  CALL FUNCTION 'F4_DATE'
    EXPORTING
      date_for_first_month         = sy-datum
      display                      = ' '
*     FACTORY_CALENDAR_ID          = ' '
*     GREGORIAN_CALENDAR_FLAG      = ' '
*     HOLIDAY_CALENDAR_ID          = ' '
*     PROGNAME_FOR_FIRST_MONTH     = ' '
*     DATE_POSITION                = ' '
    IMPORTING
      select_date                  = p_date
*     SELECT_WEEK                  =
*     SELECT_WEEK_BEGIN            =
*     SELECT_WEEK_END              =
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      date_after_range             = 2
      date_before_range            = 3
      date_invalid                 = 4
      factory_calendar_not_found   = 5
      holiday_calendar_not_found   = 6
      parameter_conflict           = 7
      OTHERS                       = 8.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_time.

  CALL FUNCTION 'F4_CLOCK'
    EXPORTING
      start_time    = sy-uzeit
      display       = ' '
    IMPORTING
      selected_time = p_time.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_year.

  CALL FUNCTION 'REAL_ESTATE_F4_YEAR'
    EXPORTING
*     I_YEAR        =
      i_popup_title = 'Year'
    IMPORTING
      e_year        = p_year.
