*&---------------------------------------------------------------------*
*& Report ZOE_CDS_DENEME01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_deneme01.
DATA: gt_status TYPE STANDARD TABLE OF zoecds06.

SELECTION-SCREEN BEGIN OF BLOCK b1.
PARAMETERS: p_status TYPE j_status,
            p_langu  TYPE spras.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM list_data.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM zoecds06( p_stat = @p_status, p_lang = @p_langu )
    INTO TABLE @gt_status.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data .

  DATA:
    lv_status_rel TYPE j_status VALUE 'I0002', " Release Status
    lr_functions  TYPE REF TO cl_salv_functions, " ALV Functions
    lr_alv        TYPE REF TO cl_salv_table, " ALV Functions
    lr_display    TYPE REF TO cl_salv_display_settings, " ALV Functions
    lv_salv_msg   TYPE REF TO cx_salv_msg. "ALV Functions.

* Display the final internal table in ALV
  IF gt_status IS NOT INITIAL.
    TRY.
* Factory Method
        cl_salv_table=>factory( IMPORTING r_salv_table = lr_alv
        CHANGING t_table = gt_status ).

      CATCH cx_salv_msg INTO lv_salv_msg.
        MESSAGE lv_salv_msg TYPE 'E'.

    ENDTRY.

* Self explanatory
    lr_functions = lr_alv->get_functions( ).

    lr_functions->set_all( abap_true ).

    lr_display = lr_alv->get_display_settings( ).

    lr_display->set_striped_pattern( cl_salv_display_settings=>true ).

    lr_display->set_list_header( TEXT-001 ).

* Actual Diplay
    lr_alv->display( ).

  ELSE.
    MESSAGE 'No data found' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
