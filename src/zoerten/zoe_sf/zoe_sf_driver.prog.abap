*&---------------------------------------------------------------------*
*& Report ZOE_SF_DRIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sf_driver.

DATA: fname TYPE rs38l_fnam.

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname           = 'ZOE_SF_ADDRESS'
*   VARIANT            = ' '
*   DIRECT_CALL        = ' '
  IMPORTING
    fm_name            = fname
  EXCEPTIONS
    no_form            = 1
    no_function_module = 2
    OTHERS             = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION fname
* EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
  EXCEPTIONS
    formatting_error = 1
    internal_error   = 2
    send_error       = 3
    user_canceled    = 4
    OTHERS           = 5.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
