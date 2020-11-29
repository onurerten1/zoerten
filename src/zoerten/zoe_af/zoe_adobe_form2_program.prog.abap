*&---------------------------------------------------------------------*
*& Report ZOE_ADOBE_FORM2_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOE_ADOBE_FORM2_PROGRAM.

DATA: gv_fm_name TYPE rs38l_fnam, " FM Name
gs_fp_docparams TYPE sfpdocparams,
gs_fp_outputparams TYPE sfpoutputparams,
gt_kna1 TYPE STANDARD TABLE OF kna1.

CONSTANTS : gv_form_name TYPE fpname VALUE 'ZOE_ADOBE_FORM2'.

START-OF-SELECTION.
SELECT * FROM kna1 INTO TABLE gt_kna1 UP TO 50 ROWS.

  CALL FUNCTION 'FP_JOB_OPEN'
CHANGING
ie_outputparams = gs_fp_outputparams
EXCEPTIONS
cancel = 1
usage_error = 2
system_error = 3
internal_error = 4
OTHERS = 5.
IF sy-subrc <> 0.
" Suitable Error Handling
ENDIF.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
EXPORTING
i_name = gv_form_name
IMPORTING
e_funcname = gv_fm_name.
IF sy-subrc <> 0.
" Suitable Error Handling
ENDIF.

CALL FUNCTION gv_fm_name
 EXPORTING
   /1BCDWB/DOCPARAMS        = gs_fp_docparams
   IT_KNA1                  = gt_kna1
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_JOB_CLOSE'.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
