*&---------------------------------------------------------------------*
*& Report zoe_time_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_time_test.

PARAMETERS: p_time1 TYPE sy-uzeit DEFAULT sy-uzeit,
            p_time2 TYPE sy-uzeit.

cl_abap_tstmp=>td_subtract(
    EXPORTING
        date1 = CONV d( sy-datum )
        time1 = CONV t( p_time2 )
        date2 = CONV d( sy-datum )
        time2 = CONV t( p_time1 )
     IMPORTING
        res_secs = DATA(diff) ).

DATA: secs      TYPE i,
      hours_out TYPE i.

CALL FUNCTION 'SWI_DURATION_DETERMINE'
  EXPORTING
    start_date = sy-datum
    end_date   = sy-datum
    start_time = p_time1
    end_time   = p_time2
  IMPORTING
    duration   = secs.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input                = secs
*       round_sign           = space
        unit_in              = `S`
        unit_out             = `H`
      IMPORTING
*       add_const            =
*       decimals             =
*       denominator          =
*       numerator            =
        output               = hours_out
      EXCEPTIONS
        conversion_not_found = 1
        division_by_zero     = 2
        input_invalid        = 3
        output_invalid       = 4
        overflow             = 5
        type_invalid         = 6
        units_missing        = 7
        unit_in_not_found    = 8
        unit_out_not_found   = 9
        OTHERS               = 10.
    IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


WRITE: hours_out.
