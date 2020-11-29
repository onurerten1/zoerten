*&---------------------------------------------------------------------*
*& Report ZOE_SF_CONVERT_PDF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sf_convert_pdf.

* Variable declarations
DATA: lv_form_name    TYPE tdsfname VALUE 'ZOE_SF_CONTROL_BREAK',
      lv_fmodule      TYPE rs38l_fnam,
      ls_cparam       TYPE ssfctrlop,
      ls_outoptions   TYPE ssfcompop,
      lv_bin_filesize TYPE i, " Binary File Size
      lv_file_name    TYPE string,
      lv_file_path    TYPE string,
      lv_full_path    TYPE string.

* Internal tables declaration
* Internal table to hold the OTF data
DATA: lt_otf         TYPE itcoo OCCURS 0 WITH HEADER LINE,
* Internal table to hold OTF data recd from the SMARTFORM
      lt_otf_from_fm TYPE ssfcrescl,
* Internal table to hold the data from the FM CONVERT_OTF
      lt_pdf_tab     LIKE tline OCCURS 0 WITH HEADER LINE.


* This function module call is used to retrieve the name of the Function
* module generated when the SMARTFORM is activated

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname           = lv_form_name
*   VARIANT            = ' '
*   DIRECT_CALL        = ' '
  IMPORTING
    fm_name            = lv_fmodule
  EXCEPTIONS
    no_form            = 1
    no_function_module = 2
    OTHERS             = 3.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

* Calling the SMARTFORM using the function module retrieved above
* GET_OTF parameter in the CONTROL_PARAMETERS is set to get the OTF
* format of the output


ls_cparam-no_dialog = 'X'.
ls_cparam-preview = space. " Suppressing the dialog box
" for print preview
ls_cparam-getotf = 'X'.

* Printer name to be used is provided in the export parameter
* OUTPUT_OPTIONS
ls_outoptions-tddest = 'LP01'.

CALL FUNCTION lv_fmodule
  EXPORTING
*   ARCHIVE_INDEX      =
*   ARCHIVE_INDEX_TAB  =
*   ARCHIVE_PARAMETERS =
    control_parameters = ls_cparam
*   MAIL_APPL_OBJ      =
*   MAIL_RECIPIENT     =
*   MAIL_SENDER        =
    output_options     = ls_outoptions
*   USER_SETTINGS      = 'X'
  IMPORTING
*   DOCUMENT_OUTPUT_INFO =
    job_output_info    = lt_otf_from_fm
*   JOB_OUTPUT_OPTIONS =
  EXCEPTIONS
    formatting_error   = 1
    internal_error     = 2
    send_error         = 3
    user_canceled      = 4
    OTHERS             = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

lt_otf[] = lt_otf_from_fm-otfdata[].

* Function Module CONVERT_OTF is used to convert the OTF format to PDF

CALL FUNCTION 'CONVERT_OTF'
  EXPORTING
    format                = 'PDF'
    max_linewidth         = 132
*   ARCHIVE_INDEX         = ' '
*   COPYNUMBER            = 0
*   ASCII_BIDI_VIS2LOG    = ' '
*   PDF_DELETE_OTFTAB     = ' '
  IMPORTING
    bin_filesize          = lv_bin_filesize
*   BIN_FILE              =
  TABLES
    otf                   = lt_otf
    lines                 = lt_pdf_tab
  EXCEPTIONS
    err_max_linewidth     = 1
    err_format            = 2
    err_conv_not_possible = 3
    err_bad_otf           = 4
    OTHERS                = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

* To display File SAVE dialog window
CALL METHOD cl_gui_frontend_services=>file_save_dialog
  EXPORTING
*   WINDOW_TITLE         =
    default_extension    = 'PDF'
*   DEFAULT_FILE_NAME    =
*   FILE_FILTER          =
*   INITIAL_DIRECTORY    =
*   WITH_ENCODING        =
*   PROMPT_ON_OVERWRITE  = 'X'
  CHANGING
    filename             = lv_file_name
    path                 = lv_file_path
    fullpath             = lv_full_path
*   USER_ACTION          =
*   FILE_ENCODING        =
  EXCEPTIONS
    cntl_error           = 1
    error_no_gui         = 2
    not_supported_by_gui = 3
    OTHERS               = 4.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


* Use the FM GUI_DOWNLOAD to download the generated PDF file onto the
* presentation server

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    bin_filesize            = lv_bin_filesize
    filename                = lv_full_path
    filetype                = 'BIN'
*   APPEND                  = ' '
*   WRITE_FIELD_SEPARATOR   = ' '
*   HEADER                  = '00'
*   TRUNC_TRAILING_BLANKS   = ' '
*   WRITE_LF                = 'X'
*   COL_SELECT              = ' '
*   COL_SELECT_MASK         = ' '
*   DAT_MODE                = ' '
*   CONFIRM_OVERWRITE       = ' '
*   NO_AUTH_CHECK           = ' '
*   CODEPAGE                = ' '
*   IGNORE_CERR             = ABAP_TRUE
*   REPLACEMENT             = '#'
*   WRITE_BOM               = ' '
*   TRUNC_TRAILING_BLANKS_EOL = 'X'
*   WK1_N_FORMAT            = ' '
*   WK1_N_SIZE              = ' '
*   WK1_T_FORMAT            = ' '
*   WK1_T_SIZE              = ' '
* IMPORTING
*   FILELENGTH              =
  TABLES
    data_tab                = lt_pdf_tab
*   FIELDNAMES              =
  EXCEPTIONS
    file_write_error        = 1
    no_batch                = 2
    gui_refuse_filetransfer = 3
    invalid_type            = 4
    no_authority            = 5
    unknown_error           = 6
    header_not_allowed      = 7
    separator_not_allowed   = 8
    filesize_not_allowed    = 9
    header_too_long         = 10
    dp_error_create         = 11
    dp_error_send           = 12
    dp_error_write          = 13
    unknown_dp_error        = 14
    access_denied           = 15
    dp_out_of_memory        = 16
    disk_full               = 17
    dp_timeout              = 18
    file_not_found          = 19
    dataprovider_exception  = 20
    control_flush_error     = 21
    OTHERS                  = 22.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
