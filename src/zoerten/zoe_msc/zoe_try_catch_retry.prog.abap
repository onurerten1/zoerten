*&---------------------------------------------------------------------*
*& Report ZOE_TRY_CATCH_RETRY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_try_catch_retry.

PARAMETERS p1_value TYPE i .
PARAMETERS p2_value TYPE i .
DATA result TYPE p DECIMALS 2.

PARAMETERS n1 TYPE i.
PARAMETERS n2 TYPE i.
DATA result2 TYPE i VALUE 10.

TRY.

    result = p1_value / p2_value.

  CATCH cx_sy_zerodivide.

    p1_value = 0.
    RETRY.

ENDTRY.

WRITE: 'Final Result: ', result.

TRY.
    TRY.

        result2 = result2 + ( n1 + n2 ).
        result2 = result2 + ( n1 / n2 ).
        result2 = result2 + 10.

      CATCH cx_sy_conversion_no_number.
        WRITE : 'conversion error'.

      CLEANUP.

        WRITE : 'THIS IS CLEAN UP SECTION'.
        result2  = 10.
        WRITE: / 'VALUE OF RESULT :' , result2.

    ENDTRY.

  CATCH cx_sy_zerodivide.
    WRITE : / 'DIVIDE BY ZERO EXCEPTION'.

ENDTRY.
