*&---------------------------------------------------------------------*
*& Report ZOE_SF_SELECT_OPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sf_select_opt.

TABLES: pa0001.

SELECT-OPTIONS: s_pernr FOR pa0001-pernr.

DATA: fm_name TYPE rs38l_fnam.

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname           = 'ZOE_SF_SELECT_OPT'
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

CALL FUNCTION fm_name
  TABLES
    t_select = s_pernr.
