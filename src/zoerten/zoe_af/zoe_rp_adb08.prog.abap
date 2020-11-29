*&---------------------------------------------------------------------*
*& Report ZOE_RP_ADB08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOE_RP_ADB08.

*Data Declarations
DATA : it_sflight TYPE zoe_sflight_tt.
DATA :
  w_doc_param       TYPE sfpdocparams,"Doc Parameters
  w_output_param    TYPE sfpoutputparams,
                                       "Output Parameters
  result            TYPE sfpjoboutput. "Joboutput
DATA :
  fm_name    TYPE rs38l_fnam.          "Function Module name
* Determine print data, Data which will be displayed on the form
SELECT * FROM sflight
         INTO TABLE it_sflight
         UP TO 20 ROWS.
IF sy-subrc NE 0 .
ENDIF.
* Determine the function module which is generated at the runtime for
* the pdf form used
CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = 'ZOE_ST_ADB08'
  IMPORTING
    e_funcname = fm_name.
* This function module is used to specify settings for the form output.
* To specify whether you want the form to be printed, archived, or sent
* back to the application program as a PDF.
* The form output is controlled using the parameters (w_ouput_param)
* with the type SFPOUTPUTPARAMS.
CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = w_output_param
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
* Set the language field the component of structure /1bcdwb/docparams
w_doc_param-langu = 'EN'.
* Call the function module and passing the form interface values
CALL FUNCTION fm_name
  EXPORTING
   /1bcdwb/docparams         = w_doc_param
    it_sflight               = it_sflight
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   usage_error              = 1
   system_error             = 2
   internal_error           = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
* To complete the processing of the form
CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             = result
 EXCEPTIONS
   usage_error          = 1
   system_error         = 2
   internal_error       = 3
   OTHERS               = 4
           .
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
