*&---------------------------------------------------------------------*
*& Include          ZOE_SCE_CIKTI_REV_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init.

  DATA(ls_functext_01) = VALUE smp_dyntxt( icon_id = icon_configuration
                                           icon_text = TEXT-001
                                           quickinfo = TEXT-001 ).

  sscrfields-functxt_01 = ls_functext_01.

  b_templ = TEXT-002.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SCREEN_LOOP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_loop.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        IF p_table = abap_true.
          screen = VALUE #( input = 0
                            invisible = 1 ).
        ENDIF.
*      WHEN .
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TEMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM template.

  SELECT vbeln,
         matnr,
         kunag,
         fkimg,
         vrkme,
         netwr,
         waerk
    FROM zoe_sd_mt
    UP TO 5 ROWS
    INTO TABLE @DATA(lt_template).

  IF lt_template IS INITIAL.

  ENDIF.

  TRY.
      cl_salv_table=>factory( IMPORTING
                                r_salv_table = DATA(gr_table)
                              CHANGING
                                t_table = lt_template ).
    CATCH cx_salv_msg .
      RETURN.
  ENDTRY.

  TRY.
      DATA(lt_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = gr_table->get_columns( )
                                                                         r_aggregations = gr_table->get_aggregations( ) ).

      DATA(lr_result) = cl_salv_ex_util=>factory_result_data_table( r_data = REF #( lt_template )
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
*& Form FILE_UPLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM file_upload.

  TRY.
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

  DATA: lr_columns TYPE REF TO cl_salv_columns.

  DATA: BEGIN OF ls_sheet,
          a TYPE string,
          b TYPE string,
          c TYPE string,
          d TYPE string,
          e TYPE string,
          f TYPE string,
          g TYPE string,
        END OF ls_sheet,
        lt_sheet LIKE TABLE OF ls_sheet.

  FIELD-SYMBOLS: <fs_sheet> TYPE table.

  IF p_table = abap_true.

    SELECT z~vbeln,
           p~posnr,
           k~fkdat,
           k~fkart,
           z~matnr,
           p~arktx,
           z~kunag,
           concat_with_space( b~name_org1 , b~name_org2, 1 ) AS name,
           z~fkimg,
           z~vrkme,
           z~netwr,
           p~mwsbp,
           z~waerk
      FROM zoe_sd_mt AS z
      LEFT OUTER JOIN vbrk    AS k ON z~vbeln = k~vbeln
      LEFT OUTER JOIN vbrp    AS p ON z~vbeln = p~vbeln
      LEFT OUTER JOIN but000  AS b ON z~kunag = b~partner
      INTO TABLE @DATA(lt_data).

  ELSEIF p_excel = abap_true.

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

            ASSIGN lo_sheet_itab->* TO <fs_sheet>.

          ENDIF.

        ENDIF.

      CATCH cx_root INTO DATA(lx_text).
        MESSAGE lx_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.

    IF <fs_sheet> IS ASSIGNED.

      DELETE <fs_sheet> INDEX 1.

      lt_sheet = CORRESPONDING #( <fs_sheet> ).

      lt_data = CORRESPONDING #( lt_sheet MAPPING vbeln = a
                                                  matnr = b
                                                  kunag = c
                                                  fkimg = d
                                                  vrkme = e
                                                  netwr = f
                                                  waerk = g ).

      LOOP AT lt_data INTO DATA(ls_data).
        ls_data-vbeln = |{ ls_data-vbeln ALPHA = IN }|.
        ls_data-matnr = |{ ls_data-matnr ALPHA = IN }|.
        ls_data-kunag = |{ ls_data-kunag ALPHA = IN }|.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input          = ls_data-vrkme
*           LANGUAGE       = SY-LANGU
          IMPORTING
            output         = ls_data-vrkme
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.

        ENDIF.
        MODIFY lt_data FROM ls_data.
      ENDLOOP.
    ENDIF.

    IF lt_data IS NOT INITIAL.
      SELECT k~vbeln,
             p~posnr,
             k~fkdat,
             k~fkart,
             p~matnr,
             p~arktx,
             k~kunag,
             concat_with_space( b~name_org1 , b~name_org2, 1 ) AS name,
             p~fkimg,
             p~vrkme,
             p~netwr,
             p~mwsbp,
             k~waerk
        FROM vbrk AS k
        INNER JOIN vbrp         AS p ON k~vbeln = p~vbeln
        LEFT OUTER JOIN but000  AS b ON k~kunag = b~partner
        INNER JOIN @lt_data     AS l ON p~vbeln = l~vbeln
        AND                             p~matnr = l~matnr
        INTO TABLE @DATA(lt_data_new).

      CLEAR: lt_data[].

      lt_data[] = lt_data_new[].

    ENDIF.

  ENDIF.

  IF lt_data IS NOT INITIAL.
    SELECT vbeln,
           matnr
      FROM vbrp
      INTO TABLE @DATA(lt_existence_check)
      FOR ALL ENTRIES IN @lt_data
      WHERE vbeln = @lt_data-vbeln
      AND   matnr = @lt_data-matnr.

    LOOP AT lt_data INTO ls_data.
      DATA(ls_existence_check) = lt_existence_check[ vbeln = ls_data-vbeln
                                                     matnr = ls_data-matnr ].
      IF ls_existence_check IS INITIAL.
        DELETE lt_data INDEX sy-tabix.
      ENDIF.
    ENDLOOP.


    TRY.

        cl_salv_table=>factory( IMPORTING
                                  r_salv_table   = gr_table
                                CHANGING
                                  t_table        = lt_data ).

        gr_table->get_display_settings( )->set_striped_pattern( abap_true ).
        gr_table->get_columns( )->set_optimize( abap_true ).
        gr_table->get_functions( )->set_all( abap_true ).

        gr_table->set_screen_status( EXPORTING
                                      report = sy-repid
                                      pfstatus = 'SALV_STANDARD'
                                      set_functions = gr_table->c_functions_all ).

        DATA(lr_selections) = gr_table->get_selections( ).
        lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

        DATA(lr_layout) = gr_table->get_layout( ).
        DATA(lr_key) = VALUE salv_s_layout_key( report = sy-repid ).
        lr_layout->set_key( lr_key ).
        lr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

        lr_columns = gr_table->get_columns( ).
        lr_columns->set_optimize( abap_true ).

        PERFORM change_column USING lr_columns:
        "FIELD TECH  INVS HOTS  KEY  CURR QUAN  L-M Text   S Text
        'VBELN' '' '' 'X' 'X' '' '' '' '',
        'NAME' '' '' '' '' '' '' TEXT-003 TEXT-003.

        DATA(lr_events) = gr_table->get_event( ).
        DATA(lr_handle) = NEW lcl_handle_events( ).

        SET HANDLER lr_handle->on_user_command  FOR lr_events.
        SET HANDLER lr_handle->on_link_click    FOR lr_events.
        SET HANDLER lr_handle->on_double_click  FOR lr_events.

        gr_table->display( ).

      CATCH cx_salv_msg INTO DATA(lx_salv_exception).
        MESSAGE lx_salv_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_COLUMN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SALV_COLUMNS
*&      --> GR_TABLE_>DISPLAY(
*&      --> )
*&---------------------------------------------------------------------*
FORM change_column  USING po_columns TYPE REF TO cl_salv_columns
                          pv_fieldname TYPE c
                          pv_technical TYPE c
                          pv_invisible TYPE c
                          pv_hotspot   TYPE c
                          pv_key       TYPE c
                          pv_currref   TYPE c
                          pv_quanref   TYPE c
                          pv_fieldtextlm TYPE c
                          pv_fieldtexts TYPE c.

  DATA: lo_column TYPE REF TO cl_salv_column_table,
        lv_short  TYPE scrtext_s,
        lv_medium TYPE scrtext_m,
        lv_long   TYPE scrtext_l.
  TRY .
      lo_column ?= po_columns->get_column( pv_fieldname ).
      IF pv_technical IS NOT INITIAL.
        lo_column->set_technical( abap_true ).
      ENDIF.
      IF pv_invisible IS NOT INITIAL.
        lo_column->set_visible( abap_false ).
        RETURN.
      ENDIF.
      IF pv_key IS NOT INITIAL.
        lo_column->set_key( value = if_salv_c_bool_sap=>true ).
      ENDIF.
      IF pv_hotspot IS NOT INITIAL.
        lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
      ENDIF.
      IF pv_currref IS NOT INITIAL.
        lo_column->set_currency_column( pv_currref ).
      ELSEIF pv_quanref IS NOT INITIAL.
        lo_column->set_quantity_column( pv_quanref ).
      ENDIF.
      IF pv_fieldtextlm IS NOT INITIAL.
        lv_medium = lv_long = pv_fieldtextlm.
        lo_column->set_medium_text( lv_medium ).
        lo_column->set_long_text( lv_long ).
      ENDIF.
      IF pv_fieldtexts IS NOT INITIAL.
        lv_short = pv_fieldtexts.
        lo_column->set_short_text( lv_short ).
      ENDIF.
    CATCH cx_salv_not_found.
    CATCH cx_salv_data_error.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command  USING    p_e_salv_function.

  CASE p_e_salv_function.
    WHEN 'PRINT'.
      PERFORM print.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING    p_row
                                   p_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_LINK_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_link_click  USING    p_row
                                 p_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PRINT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print.

  DATA(lo_selections) = gr_table->get_selections( ).
  DATA(lt_selected_rows) = lo_selections->get_selected_rows( ).


ENDFORM.
