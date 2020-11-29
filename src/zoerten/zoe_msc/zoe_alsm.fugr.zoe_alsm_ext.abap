FUNCTION zoe_alsm_ext.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FILENAME) LIKE  RLGRAP-FILENAME
*"     VALUE(I_BEGIN_COL) TYPE  I
*"     VALUE(I_BEGIN_ROW) TYPE  I
*"     VALUE(I_END_COL) TYPE  I
*"     VALUE(I_END_ROW) TYPE  I
*"  TABLES
*"      INTERN STRUCTURE  ZOE_ALSMEX
*"  EXCEPTIONS
*"      INCONSISTENT_PARAMETERS
*"      UPLOAD_OLE
*"----------------------------------------------------------------------
  DATA: excel_tab     TYPE  ty_t_sender.
  DATA: ld_separator  TYPE  c.
  DATA: application TYPE  ole2_object,
        workbook    TYPE  ole2_object,
        range       TYPE  ole2_object,
        worksheet   TYPE  ole2_object.
  DATA: h_cell  TYPE  ole2_object,
        h_cell1 TYPE  ole2_object.
  DATA:
    ld_rc             TYPE i.
*   Rückgabewert der Methode "clipboard_export     "

* Makro für Fehlerbehandlung der Methods
  DEFINE m_message.
    CASE sy-subrc.
      WHEN 0.
      WHEN 1.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      WHEN OTHERS. RAISE upload_ole.
    ENDCASE.
  END-OF-DEFINITION.


* check parameters
  IF i_begin_row > i_end_row. RAISE inconsistent_parameters. ENDIF.
  IF i_begin_col > i_end_col. RAISE inconsistent_parameters. ENDIF.

* Get TAB-sign for separation of fields
  CLASS cl_abap_char_utilities DEFINITION LOAD.
  ld_separator = cl_abap_char_utilities=>horizontal_tab.

* open file in Excel
  IF application-header = space OR application-handle = -1.
    CREATE OBJECT application 'Excel.Application'.
    m_message.
  ENDIF.
  CALL METHOD  OF application    'Workbooks' = workbook.
  m_message.
  CALL METHOD  OF workbook 'Open'    EXPORTING #1 = filename.
  m_message.
*  set property of application 'Visible' = 1.
*  m_message.
  GET PROPERTY OF  application 'ACTIVESHEET' = worksheet.
  m_message.

* mark whole spread sheet
  CALL METHOD OF worksheet 'Cells' = h_cell
      EXPORTING #1 = i_begin_row #2 = i_begin_col.
  m_message.
  CALL METHOD OF worksheet 'Cells' = h_cell1
      EXPORTING #1 = i_end_row #2 = i_end_col.
  m_message.

  CALL METHOD  OF worksheet 'RANGE' = range
                 EXPORTING #1 = h_cell #2 = h_cell1.
  m_message.
  CALL METHOD OF range 'SELECT'.
  m_message.

* copy marked area (whole spread sheet) into Clippboard
  CALL METHOD OF range 'COPY'.
  m_message.

* read clipboard into ABAP
  CALL METHOD cl_gui_frontend_services=>clipboard_import
    IMPORTING
      data       = excel_tab
    EXCEPTIONS
      cntl_error = 1
*     ERROR_NO_GUI         = 2
*     NOT_SUPPORTED_BY_GUI = 3
      OTHERS     = 4.
  IF sy-subrc <> 0.
    MESSAGE a037(alsmex).
  ENDIF.

  PERFORM separated_to_intern_convert TABLES excel_tab intern
                                      USING  ld_separator.

* clear clipboard
  REFRESH excel_tab.
  CALL METHOD cl_gui_frontend_services=>clipboard_export
    IMPORTING
      data       = excel_tab
    CHANGING
      rc         = ld_rc
    EXCEPTIONS
      cntl_error = 1
*     ERROR_NO_GUI         = 2
*     NOT_SUPPORTED_BY_GUI = 3
      OTHERS     = 4.

* quit Excel and free ABAP Object - unfortunately, this does not kill
* the Excel process
  CALL METHOD OF application 'QUIT'.
  m_message.

* >>>>> Begin of change note 575877
* to kill the Excel process it's necessary to free all used objects
  FREE OBJECT h_cell.       m_message.
  FREE OBJECT h_cell1.      m_message.
  FREE OBJECT range.        m_message.
  FREE OBJECT worksheet.    m_message.
  FREE OBJECT workbook.     m_message.
  FREE OBJECT application.  m_message.
* <<<<< End of change note 575877




ENDFUNCTION.
