*&---------------------------------------------------------------------*
*& Include          ZOE_TREE_ALV_CLS
*&---------------------------------------------------------------------*
CLASS lcl_toolbar_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS: on_function_selected
                  FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING fcode.


ENDCLASS.
CLASS lcl_toolbar_event_receiver IMPLEMENTATION.
  METHOD on_function_selected.
    DATA: lt_selected_nodes TYPE lvc_t_nkey,
          lv_selected_node  TYPE lvc_nkey,
          lv_fname          TYPE lvc_fname.
    CASE fcode.
      WHEN 'DETAIL'.
        CALL METHOD alv_tree->get_selected_nodes
          CHANGING
            ct_selected_nodes = lt_selected_nodes.

        CALL METHOD cl_gui_cfw=>flush.
        READ TABLE lt_selected_nodes INTO lv_selected_node INDEX 1.
        READ TABLE gt_output INTO gs_output INDEX lv_selected_node.
        IF gs_output IS NOT INITIAL.
          CLEAR: gt_vbap.
          SELECT *
            FROM vbap
            INTO CORRESPONDING FIELDS OF TABLE @gt_vbap
            WHERE vbeln = @gs_output-vbeln.
          IF grid IS INITIAL.
            CREATE OBJECT grid
              EXPORTING
                i_parent = alv_container.
            PERFORM fill_layout.
            PERFORM create_fcat.
            PERFORM create_alv.
          ELSE.
            PERFORM refresh_alv .
          ENDIF.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
