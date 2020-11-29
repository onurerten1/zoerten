*&---------------------------------------------------------------------*
*& Include          ZOE_OO_ALV2_CLS
*&---------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
            e_row
            e_column
            es_row_no,
      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      on_hotspot_click
            FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
            es_row_no,
      handle_user_command
                    FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      handle_data_changed
                    FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      handle_data_changed_finished
        FOR EVENT data_changed OF cl_gui_alv_grid.

ENDCLASS.

CLASS lcl_eventhandler IMPLEMENTATION.
  METHOD handle_double_click.
    PERFORM double_click USING es_row_no-row_id.
  ENDMETHOD.
  METHOD handle_toolbar.
    PERFORM handle_toolbar USING e_object.
  ENDMETHOD.
  METHOD on_hotspot_click.
    PERFORM hotspot USING es_row_no-row_id.
  ENDMETHOD.
  METHOD handle_user_command.

    DATA: lt_rows TYPE lvc_t_row.
    DATA: ls_rows TYPE lvc_s_row. "BCALV_GRID_05
    DATA: ls_ekpo LIKE zoe_item_ekpo.

    SELECT zzcolor FROM zoe_color INTO TABLE @DATA(ls_color).

    CASE e_ucomm.
      WHEN 'AKTAR'.
        CALL METHOD grid_right->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.
        IF lt_rows IS INITIAL.
          MESSAGE TEXT-i01 TYPE 'I'.
        ELSE.
          LOOP AT lt_rows INTO ls_rows.
            DATA(lv_index) = ls_rows-index.
            READ TABLE gt_data_right INTO gs_data_right INDEX lv_index.
            ls_ekpo-aedat = gs_data_right-aedat.
            ls_ekpo-bukrs = gs_data_right-bukrs.
            ls_ekpo-ebeln = gs_data_right-ebeln.
            ls_ekpo-ebelp = gs_data_right-ebelp.
            ls_ekpo-matnr = gs_data_right-matnr.
            ls_ekpo-zzcolor = gs_data_right-zzcolor.
            MODIFY zoe_item_ekpo FROM ls_ekpo.
            CLEAR ls_ekpo.
            COMMIT WORK AND WAIT.
          ENDLOOP.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
  METHOD handle_data_changed.
    PERFORM data_change USING er_data_changed.
  ENDMETHOD.
  METHOD handle_data_changed_finished.
    PERFORM data_changed_finished.
  ENDMETHOD.
ENDCLASS.
