*&---------------------------------------------------------------------*
*& Report ZOE_EXCEL_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_excel_template.

INCLUDE ole2incl.

DATA: excel    TYPE ole2_object,
      workbook TYPE ole2_object,
      sheet    TYPE ole2_object,
      cell     TYPE ole2_object,
      row      TYPE ole2_object,
      font     TYPE ole2_object,
      range    TYPE ole2_object,
      column   TYPE ole2_object,
      interior TYPE ole2_object.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME.
PARAMETERS: p_salv RADIOBUTTON GROUP rbg1 DEFAULT 'X',
            p_ole  RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN END OF BLOCK block1.

START-OF-SELECTION.
  IF p_salv = abap_true.
    PERFORM excel_template_salv.
  ELSEIF p_ole = abap_true.
    PERFORM excel_template_ole.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form EXCEL_TEMPLATE_SALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM excel_template_salv .

  SELECT  k~vbeln,
          p~posnr,
          p~netwr,
          p~waerk
    UP TO 10 ROWS
    FROM vbak AS k
    INNER JOIN vbap AS p ON k~vbeln = p~vbeln
    INTO TABLE @DATA(lt_vbap)
    WHERE k~auart LIKE `Z%`
    ORDER BY k~vbeln, p~posnr.

  IF lt_vbap IS INITIAL.
    ASSIGN lt_vbap TO FIELD-SYMBOL(<fs_vbap>).
    IF <fs_vbap> IS ASSIGNED.
      <fs_vbap>[ 1 ] = VALUE #( vbeln = `0000000002`
                                posnr = `000010`
                                netwr = `175.50`
                                waerk = `USD` ).
    ENDIF.
  ENDIF.

  TRY.
      cl_salv_table=>factory( IMPORTING
                                r_salv_table = DATA(lr_table)
                              CHANGING
                                t_table = lt_vbap ).
    CATCH cx_salv_msg .
      RETURN.
  ENDTRY.

  TRY.
      DATA(lt_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lr_table->get_columns( )
                                                                         r_aggregations = lr_table->get_aggregations( ) ).

      DATA(lr_result) = cl_salv_ex_util=>factory_result_data_table( r_data = REF #( lt_vbap )
                                                                    t_fieldcatalog = lt_fcat ).

      cl_salv_bs_lex=>export_from_result_data_table( EXPORTING
                                                        is_format = if_salv_bs_lex_format=>mc_format_xlsx
                                                        ir_result_data_table = lr_result
                                                      IMPORTING
                                                        er_result_file = DATA(lr_xstring) ).
    CATCH cx_salv_unexpected_param_value .
      RETURN.
  ENDTRY.

  DATA(lt_xml_choice) = cl_salv_export_xml_dialog=>execute( display_mode = cl_salv_export_xml_dialog=>c_display_mode-menu_item ).

  IF lt_xml_choice IS NOT INITIAL.

    DATA(ls_xml_choice) = lt_xml_choice[ 1 ].

    TRY.
        cl_salv_export_xml_dialog=>download( s_xml_choice = ls_xml_choice
                                             xml          = lr_xstring ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXCEL_TEMPLATE_OLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM excel_template_ole.

  DATA: number    TYPE i,
        letter(1) TYPE c.

  DATA: filename    TYPE string,
        path        TYPE string,
        fullpath    TYPE string,
        user_action TYPE i.

  cl_gui_frontend_services=>file_save_dialog(
    EXPORTING
*      window_title              =
      default_extension         = `.xls`
      default_file_name         = `Excel Sablon`
*      with_encoding             =
      file_filter               = `Excel (*.xls)|*.xls`
*      initial_directory         =
*      prompt_on_overwrite       = 'X'
    CHANGING
      filename                  = filename
      path                      = path
      fullpath                  = fullpath
      user_action               = user_action
*      file_encoding             =
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      OTHERS                    = 5 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  SELECT  k~vbeln,
          p~posnr,
          p~netwr,
          p~waerk
    UP TO 10 ROWS
    FROM vbak AS k
    INNER JOIN vbap AS p ON k~vbeln = p~vbeln
    INTO TABLE @DATA(lt_vbap)
    WHERE k~auart LIKE `Z%`
    ORDER BY k~vbeln, p~posnr.

  TRY.
      cl_salv_table=>factory( IMPORTING
                                r_salv_table = DATA(lr_table)
                              CHANGING
                                t_table = lt_vbap ).
    CATCH cx_salv_msg .
      EXIT.
  ENDTRY.

  TRY.
      DATA(lt_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lr_table->get_columns( )
                                                                         r_aggregations = lr_table->get_aggregations( ) ).
    CATCH cx_salv_msg .
      RETURN.
  ENDTRY.

  CREATE OBJECT excel 'EXCEL.APPLICATION'.
  CALL METHOD OF excel 'WORKBOOKS' = workbook .
  SET PROPERTY OF excel 'VISIBLE' = 0 .
  CALL METHOD OF workbook 'Add'.
  CALL METHOD OF excel 'Worksheets' = sheet EXPORTING #1 = 1.
  CALL METHOD OF sheet 'Activate'.

  LOOP AT lt_fcat INTO DATA(ls_fcat).
    IF letter EQ 'Z' OR letter IS INITIAL.
      letter = 'A'.
    ELSE.
      SEARCH sy-abcde FOR letter.
      number = sy-fdpos + 1.
      letter = sy-abcde+number(1).
    ENDIF.
    DATA(lv_column_number) = |{ letter }1|.

    CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = lv_column_number.
    SET PROPERTY OF cell 'VALUE' = ls_fcat-reptext.

  ENDLOOP.

  LOOP AT lt_vbap INTO DATA(ls_vbap).

    CLEAR: letter,
           number.

    DATA(lv_row_number) = sy-tabix + 1.

    CALL METHOD OF excel 'ROWS' = row EXPORTING #1 = lv_row_number.
    CALL METHOD OF row 'INSERT' NO FLUSH.

    DO lines( lt_fcat ) TIMES.
      ls_fcat = lt_fcat[ col_pos = sy-index ].
      DATA(lv_field_name) = ls_fcat-fieldname.
      DATA(lv_structure_name) = `LS_VBAP`.
      ASSIGN (lv_structure_name) TO FIELD-SYMBOL(<fs_structure>).
      ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_structure> TO FIELD-SYMBOL(<fs_value>).

      IF letter EQ 'Z' OR letter IS INITIAL.
        letter = 'A'.
      ELSE.
        SEARCH sy-abcde FOR letter.
        number = sy-fdpos + 1.
        letter = sy-abcde+number(1).
      ENDIF.

      DATA(lv_cell_id) = |{ letter }{ lv_row_number }|.
      CALL METHOD OF excel 'RANGE' = cell EXPORTING #1 = lv_cell_id.
      SET PROPERTY OF cell 'VALUE' = <fs_value> NO FLUSH.
    ENDDO.

  ENDLOOP.

  DO lines( lt_fcat ) TIMES.
    CALL METHOD OF excel 'CELLS' = cell  NO FLUSH
       EXPORTING #1 = 1
                 #2 = sy-index.

    GET PROPERTY OF cell 'FONT' = font NO FLUSH.
    SET PROPERTY OF font 'BOLD' = 1 NO FLUSH.
    SET PROPERTY OF font 'SIZE' = 12.
    CALL METHOD OF cell 'INTERIOR' = range.
    SET PROPERTY OF range 'ColorIndex' = 6.
    SET PROPERTY OF range 'Pattern' = 1.
  ENDDO.

  CALL METHOD OF excel 'Columns' = column.
  CALL METHOD OF column 'Autofit'.

  CALL METHOD OF sheet 'SAVEAS'
    EXPORTING
      #1 = fullpath
      #2 = 1.

  CALL METHOD OF excel 'QUIT'.

  excel-handle = -1.
  FREE OBJECT cell.
  FREE OBJECT workbook.
  FREE OBJECT excel.
  FREE OBJECT row.
  FREE OBJECT column.

ENDFORM.
