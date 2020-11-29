*&---------------------------------------------------------------------*
*& Report ZOE_SUPP_DIALOG_SF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_supp_dialog_sf.

DATA: fm_name TYPE rs38l_fnam.

DATA : ls_cparam TYPE ssfctrlop,
       ls_output TYPE ssfcompop.

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname           = 'ZOE_SF_SUPP_DIALOG'
*   VARIANT            = ' '
*   DIRECT_CALL        = ' '
  IMPORTING
    fm_name            = fm_name
  EXCEPTIONS
    no_form            = 1
    no_function_module = 2
    OTHERS             = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

ls_cparam-preview = 'X'.
ls_cparam-no_dialog = 'X'.
ls_output-tddest = 'LP01'.

CALL FUNCTION fm_name
  EXPORTING
    control_parameters = ls_cparam
    output_options     = ls_output
    user_settings      = ' '.
