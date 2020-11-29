*&---------------------------------------------------------------------*
*& Include          ZOE_CDS_DENEME02_F01
*&---------------------------------------------------------------------*
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
    FROM zoecds10( p_date = @p_date )
    INTO TABLE @gt_data.

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

  IF gt_data IS NOT INITIAL.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = alv
                                CHANGING t_table = gt_data ).
      CATCH cx_salv_msg INTO salv_msg.
        MESSAGE salv_msg TYPE 'E'.
    ENDTRY.

    functions = alv->get_functions( ).

    functions->set_all( abap_true ).

    display = alv->get_display_settings( ).

    display->set_striped_pattern( cl_salv_display_settings=>true ).

    display->set_list_header( TEXT-001 ).

    alv->display( ).

  ELSE.

    MESSAGE 'No data found' TYPE 'I'.
    LEAVE LIST-PROCESSING.

  ENDIF.

ENDFORM.
