FUNCTION conversion_exit_zdate_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"----------------------------------------------------------------------
  DATA : l_input  TYPE sydatum,
         l_output TYPE rvdat-extdatum.

  l_input = input.

  CALL FUNCTION 'PERIOD_AND_DATE_CONVERT_OUTPUT'
    EXPORTING
*     COUNTRY         = ' '
      internal_date   = l_input
      internal_period = '3'
*     LANGUAGE        = SYST-LANGU
*     I_PERIV         =
*     I_WERKS         =
*     I_MRPPP         =
    IMPORTING
      external_date   = l_output
*     EXTERNAL_PERIOD =
*     EXTERNAL_PRINTTEXT       =
    EXCEPTIONS
      date_invalid    = 1
      periode_invalid = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  output = l_output.



ENDFUNCTION.
