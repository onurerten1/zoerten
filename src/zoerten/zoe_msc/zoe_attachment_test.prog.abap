*&---------------------------------------------------------------------*
*& Report ZOE_ATTACHMENT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_attachment_test.
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.
ENDCLASS.
SELECTION-SCREEN BEGIN OF BLOCK blk WITH FRAME.
PARAMETERS: p_create RADIOBUTTON GROUP rbg DEFAULT 'X',
            p_disp   RADIOBUTTON GROUP rbg.
SELECTION-SCREEN END OF BLOCK blk.

START-OF-SELECTION.
  SELECT *
    FROM zoe_item_ekpo
    INTO TABLE @DATA(lt_data).

END-OF-SELECTION.
  TRY.
      cl_salv_table=>factory(
                       IMPORTING
                         r_salv_table = DATA(lr_table)
                       CHANGING
                         t_table      = lt_data ).

      lr_table->get_display_settings( )->set_striped_pattern( abap_true ).
      lr_table->get_columns( )->set_optimize( abap_true ).
      lr_table->get_functions( )->set_all( abap_true ).

      lr_table->set_screen_status(
                  EXPORTING
                    report        = sy-repid
                    pfstatus      = 'SALV_STANDARD'
                    set_functions = lr_table->c_functions_all ).

      lr_table->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

      DATA(lr_events) = lr_table->get_event( ).
      DATA(lr_event) = NEW lcl_handle_events( ).
      SET HANDLER lr_event->on_user_command FOR lr_events.

      lr_table->display( ).

    CATCH cx_salv_msg INTO DATA(salv_exception).
  ENDTRY.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE salv_de_function.

  DATA: lv_type(1).

  IF p_create = abap_true.
    lv_type = 'E'.
  ELSE.
    lv_type = 'D'.
  ENDIF.

  CASE i_ucomm.
    WHEN 'ATTCH'.
      PERFORM add_disp_attachment USING lv_type.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_DISP_ATTACHMENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_TYPE
*&---------------------------------------------------------------------*
FORM add_disp_attachment USING p_type.

  CONSTANTS: lc_objtype TYPE borident-objtype VALUE `ZOE_BOATCH`.

  DATA: ls_object     TYPE borident,
        lv_avaible(1).

  CLEAR: ls_object,
       lv_avaible.

  DATA(lt_selected) = lr_table->get_selections( )->get_selected_rows( ).

  IF lines( lt_selected ) GT 1.
    MESSAGE 'Tek satır seçiniz' TYPE 'E'.
  ELSEIF lines( lt_selected ) = 0.
    MESSAGE 'Satır seçiniz' TYPE 'E'.
  ELSE.
    DATA(ls_data) = lt_data[ lt_selected[ 1 ] ].
  ENDIF.

  ls_object-objtype = lc_objtype.
  ls_object-objkey = |{ ls_data-ebeln }{ ls_data-ebelp }|.

  DATA(lo_manager) = NEW cl_gos_manager( is_object    = ls_object
                                         ip_no_commit = abap_false
                                         ip_mode      = p_type ).

  lo_manager->start_service_direct(
                EXPORTING
                  ip_service         = 'VIEW_ATTA'
                  is_object          = ls_object
                  ip_check_available = abap_true
                IMPORTING
                  ep_available       = lv_avaible
                EXCEPTIONS
                  no_object          = 1
                  object_invalid     = 2
                  execution_failed   = 3
                  OTHERS             = 4 ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF lv_avaible = abap_true.

    lo_manager->start_service_direct(
                  EXPORTING
                    ip_service         = 'VIEW_ATTA'
                    is_object          = ls_object
                  EXCEPTIONS
                    no_object          = 1
                    object_invalid     = 2
                    execution_failed   = 3
                    OTHERS             = 4 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSEIF lv_avaible = abap_false AND p_type = 'E'.

    lo_manager->get_context_menu( is_object = ls_object ).

    lo_manager->dispatch_menu_command(
                  EXPORTING
                    ip_fcode       = '%GOS_PCATTA_CREA'
                  EXCEPTIONS
                    no_menu_opened = 1
                    OTHERS         = 2 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.
    MESSAGE 'Dosya Bulunamadı' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

  lo_manager->unpublish( ).

ENDFORM.
