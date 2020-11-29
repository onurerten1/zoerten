*&---------------------------------------------------------------------*
*& Report ZOE_ADOBEFORM_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_adobeform_06.

PARAMETERS :
  p_atype TYPE char1,
  p_adrnr TYPE ad_addrnum,
  p_pernr TYPE ad_persnum,
  p_land1 TYPE land1.

DATA: gv_fm_name         TYPE rs38l_fnam, " FM Name
      gs_fp_docparams    TYPE sfpdocparams,
      gs_fp_outputparams TYPE sfpoutputparams.

CONSTANTS : gv_form_name TYPE fpname VALUE 'ZOE_ADOBE_FORM06'.

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
  " Suitable Error Handling
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = gv_form_name
  IMPORTING
    e_funcname = gv_fm_name.
IF sy-subrc <> 0.
  " Suitable Error Handling
ENDIF.

CALL FUNCTION gv_fm_name
  EXPORTING
    /1bcdwb/docparams = gs_fp_docparams
    iv_address_type   = p_atype
    iv_addrnumber     = p_adrnr
    iv_persnumber     = p_pernr
    iv_land1          = p_land1
* IMPORTING
*   /1BCDWB/FORMOUTPUT =
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
* <error handling>
ENDIF.
