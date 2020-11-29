*&---------------------------------------------------------------------*
*& Include zoe_mm_mat_maint_f01
*&---------------------------------------------------------------------*
FORM list_data.

  DATA(lo_table) = cl_salv_gui_table_ida=>create_for_cds_view( `ZOE_MM_CDS_MALZ_GRN_BKM` ).

  DATA(lo_sel) = NEW cl_salv_range_tab_collector( ).

  lo_sel->add_ranges_for_name( iv_name = `MATNR` it_ranges = s_matnr[] ).
  lo_sel->add_ranges_for_name( iv_name = `WERKS` it_ranges = s_werks[] ).
  lo_sel->add_ranges_for_name( iv_name = `VKORG` it_ranges = s_vkorg[] ).
  lo_sel->add_ranges_for_name( iv_name = `VTWEG` it_ranges = s_vtweg[] ).
  lo_sel->add_ranges_for_name( iv_name = `MTART` it_ranges = s_mtart[] ).

  lo_sel->get_collected_ranges(
            IMPORTING
              et_named_ranges = DATA(lt_named_ranges) ).

  lo_table->set_select_options( it_ranges = lt_named_ranges ).

  lo_table->selection(  )->set_selection_mode( iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-single ).

  lo_table->display_options( )->enable_alternating_row_pattern(  ).

  lo_table->field_catalog( )->display_options( )->display_as_link_to_action( iv_field_name = `MATNR` ).

  lo_table->field_catalog( )->get_all_fields(
                                IMPORTING
                                  ets_field_names = DATA(lt_field_names) ).


  lo_table->fullscreen( )->display( ).

ENDFORM.
