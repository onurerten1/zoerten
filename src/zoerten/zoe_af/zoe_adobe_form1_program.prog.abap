*&---------------------------------------------------------------------*
*& Report ZOE_ADOBE_FORM1_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_adobe_form1_program.

TABLES: apb_lpd_otr_keys.

DATA: gv_fm_name         TYPE rs38l_fnam,
      gs_fp_docparams    TYPE sfpdocparams,
      gs_fp_outputparams TYPE sfpoutputparams.

CONSTANTS: gv_form_name TYPE fpname VALUE 'ZOE_ADOBE_FORM1'.

PARAMETERS: p_text TYPE char30.

CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = gs_fp_outputparams
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5.
IF sy-subrc <> 0.
*  implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = gv_form_name
  IMPORTING
    e_funcname = gv_fm_name.

CALL FUNCTION gv_fm_name
  EXPORTING
    /1bcdwb/docparams = gs_fp_docparams
    iv_text           = p_text
  EXCEPTIONS
    usage_error       = 1
    system_error      = 2
    internal_error    = 3
    OTHERS            = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_JOB_CLOSE'
  EXCEPTIONS
    usage_error    = 1
    system_error   = 2
    internal_error = 3
    OTHERS         = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
