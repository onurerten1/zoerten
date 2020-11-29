*&---------------------------------------------------------------------*
*& Include          ZOE_ADOBEFORM_13_F01
*&---------------------------------------------------------------------*

CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = gs_fp_outparams
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = gv_form_name
  IMPORTING
    e_funcname = gv_fm_name.
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =

CALL FUNCTION gv_fm_name
  EXPORTING
    /1bcdwb/docparams = gs_fp_docparams
    v_row_r           = p_rowr
    v_row_l           = p_rowl
  EXCEPTIONS
    usage_error       = 1
    system_error      = 2
    internal_error    = 3
    OTHERS            = 4.
IF sy-subrc <> 0.

* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
  EXCEPTIONS
    usage_error    = 1
    system_error   = 2
    internal_error = 3
    OTHERS         = 4.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
