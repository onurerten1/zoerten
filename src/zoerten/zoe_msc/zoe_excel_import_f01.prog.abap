*&---------------------------------------------------------------------*
*& Include          ZOE_EXCEL_IMPORT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_EXCEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_excel.

  TRY.

* Dosya seçme diyaloğu
      cl_gui_frontend_services=>file_open_dialog( EXPORTING
                                                    file_filter = |xlsx (*.xlsx)\|*.xlsx\||
                                                  CHANGING
                                                    file_table  = gt_file
                                                    rc          = gv_rc
                                                    user_action = gv_user_action ).

*CATCH .

  ENDTRY.

  IF gv_user_action = cl_gui_frontend_services=>action_ok.

    p_file = gt_file[ 1 ].

  ELSE.

    CLEAR: p_file.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  DATA: lv_filesize        TYPE w3param-cont_len,
        lv_filetype        TYPE w3param-cont_type,
        lt_bin_data        TYPE w3mimetabtype,
        lt_worksheet_names TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.

  DATA: BEGIN OF ls_data,
          vbeln LIKE vbap-vbeln,
          posnr LIKE vbap-posnr,
          matnr LIKE vbap-matnr,
          lgort LIKE vbap-lgort,
          meins LIKE vbap-meins,
        END OF ls_data,
        lt_data LIKE TABLE OF ls_data.

  FIELD-SYMBOLS: <sheet> TYPE table.

  TRY.

      IF gv_user_action = cl_gui_frontend_services=>action_ok AND lines( gt_file ) > 0.

        cl_gui_frontend_services=>gui_upload( EXPORTING
                                                filename   = |{ gt_file[ 1 ]-filename }|
                                                filetype   = 'BIN'
                                              IMPORTING
                                                filelength = lv_filesize
                                              CHANGING
                                                data_tab   = lt_bin_data ).

        DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix = lt_bin_data ).

        DATA(lo_excel) = NEW cl_fdt_xl_spreadsheet( document_name = CONV #( gt_file[ 1 ]-filename )
                                                    xdocument     = lv_bin_data ).

        lo_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING
                                                                worksheet_names = lt_worksheet_names ).

        IF lines( lt_worksheet_names ) > 0.

          DATA(lo_sheet_itab) = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( lt_worksheet_names[ 1 ] ).

          ASSIGN lo_sheet_itab->* TO <sheet>.

        ENDIF.

      ENDIF.

    CATCH cx_root INTO DATA(lx_text).
      MESSAGE lx_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.

  IF <sheet> IS ASSIGNED.

    DELETE <sheet> INDEX 1.

    gt_sheet = CORRESPONDING #( <sheet> ).

    lt_data = CORRESPONDING #( gt_sheet MAPPING vbeln = a
                                                posnr = b
                                                matnr = c
                                                lgort = d
                                                meins = e ).

    DELETE lt_data WHERE vbeln = space
                   AND   posnr = space
                   AND   matnr = space
                   AND   lgort = space
                   AND   meins = space.

    LOOP AT lt_data INTO ls_data.

      ls_data-vbeln = |{ ls_data-vbeln ALPHA = IN }|.
      ls_data-posnr = |{ ls_data-posnr ALPHA = IN }|.
      ls_data-matnr = |{ ls_data-matnr ALPHA = IN }|.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = ls_data-meins
          language       = 'E'
*         language       = sy-langu
        IMPORTING
          output         = ls_data-meins
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      MODIFY lt_data FROM ls_data.

    ENDLOOP.

  ENDIF.

ENDFORM.
