FUNCTION conversion_exit_zdate_input.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"----------------------------------------------------------------------

  DATA : l_input  TYPE rvdat-extdatum,
         l_output TYPE sydatum.

  l_input = input.

  CALL FUNCTION 'PERIOD_AND_DATE_CONVERT_INPUT'
    EXPORTING
*     DIALOG_DATE_IS_IN_THE_PAST       = 'X'
      external_date   = l_input
      external_period = '3'
*     INTERNAL_PERIOD = ' '
*     I_PERIV         =
*     I_WERKS         =
*     I_MRPPP         =
    IMPORTING
      internal_date   = l_output
*     INTERNAL_PERIOD =
*     EV_DATE_IN_PAST =
*     EV_PERIOD_IN_PAST                =
    EXCEPTIONS
      date_invalid    = 1
      no_data         = 2
      period_invalid  = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  output = l_output.



ENDFUNCTION.
