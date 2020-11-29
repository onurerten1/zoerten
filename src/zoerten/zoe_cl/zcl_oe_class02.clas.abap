CLASS zcl_oe_class02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_oe_class01 .

  PUBLIC SECTION.

    INTERFACES zoe_interface .

    DATA text1 TYPE char10 .
    DATA text2 TYPE char10 .

    METHODS get_name .
    METHODS get_date .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OE_CLASS02 IMPLEMENTATION.


  METHOD get_date.

    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
      EXPORTING
        date_internal            = sy-datum
      IMPORTING
        date_external            = text2
      EXCEPTIONS
        date_internal_is_invalid = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.


  METHOD get_name.
    text1 = sy-uname.
  ENDMETHOD.


  METHOD zoe_interface~message.
    WRITE: / 'Interface'.
  ENDMETHOD.
ENDCLASS.
