*&---------------------------------------------------------------------*
*& Report ZOE_BO_GOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_bo_gos.
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
DATA: go_manager TYPE REF TO cl_gos_manager.

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

  CASE i_ucomm.
    WHEN 'GOS1'.
      PERFORM gos_01 USING 'E'.
    WHEN 'GOS2'.
      PERFORM gos_01 USING 'D'.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GOS_01
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gos_01 USING p_view_type TYPE c.

  CONSTANTS: lv_objtype TYPE borident-objtype VALUE `ZOE_BO_002`.
  DATA: lv_obj        TYPE borident,
        lv_service    TYPE sgs_srvnam,
        lv_avaible(1).

  CLEAR: lv_service,
         lv_obj,
         lv_avaible.

  DATA(lt_selected) = lr_table->get_selections( )->get_selected_rows( ).

  IF lines( lt_selected ) GT 1.
    MESSAGE 'select one row only' TYPE 'E'.
  ELSEIF lines( lt_selected ) = 0.
    MESSAGE 'select a row' TYPE 'E'.
  ELSE.
    DATA(ls_data) = lt_data[ lt_selected[ 1 ] ].
  ENDIF.

  lv_obj-objtype = lv_objtype.

  lv_obj-objkey = |{ ls_data-ebeln }{ ls_data-ebelp }|.


  DATA(lv_manager) = NEW cl_gos_manager( is_object    = lv_obj
                                         ip_no_commit = abap_false
                                         ip_mode      = p_view_type ).

  lv_manager->start_service_direct(
                EXPORTING
                  ip_service         = 'VIEW_ATTA'
                  is_object          = lv_obj
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

    lv_manager->start_service_direct(
                  EXPORTING
                    ip_service         = 'VIEW_ATTA'
                    is_object          = lv_obj
                  EXCEPTIONS
                    no_object          = 1
                    object_invalid     = 2
                    execution_failed   = 3
                    OTHERS             = 4 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.

    lv_manager->get_context_menu( is_object = lv_obj ).

    lv_manager->dispatch_menu_command(
                  EXPORTING
                    ip_fcode       = '%GOS_PCATTA_CREA'
                  EXCEPTIONS
                    no_menu_opened = 1
                    OTHERS         = 2 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.



ENDFORM.
