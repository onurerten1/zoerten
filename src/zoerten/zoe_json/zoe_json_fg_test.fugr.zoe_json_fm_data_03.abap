FUNCTION zoe_json_fm_data_03.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_URL) TYPE  URL
*"  EXPORTING
*"     REFERENCE(EV_RESPONSE) TYPE  STRING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
  DATA: http_client   TYPE REF TO if_http_client,
        url           TYPE string,
        ls_return     TYPE bapiret2,
        lx_exception  TYPE REF TO cx_root,
        lv_response   TYPE string,
        lv_code       TYPE i,
        lv_err_string TYPE string,
        len           TYPE i,
        strval        TYPE string,
        intval        TYPE i,
        numval        TYPE cats_its_fields-num_value,
        negatif       TYPE xfeld,
        url_json      TYPE ad_uriscr.

  DATA: ls_json TYPE zoe_json_st_poke_tab,
        lt_json TYPE TABLE OF zoe_json_st_poke_tab,
        ls_tab  TYPE zoe_json_st_poke,
        lt_tab  TYPE TABLE OF zoe_json_st_poke.

  FIELD-SYMBOLS: <fs_t_data> TYPE ANY TABLE,
                 <fs_s_data> TYPE any,
                 <fs_val>    TYPE any.

  url_json = to_lower( iv_url ).

  IF to_upper( url_json(4) ) NE 'HTTP'.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'URL'
                    message_v2 = 'Hatalı URL adresi, HTTP veya HTTPS eksik.'
                    message_v3 = url_json ) TO et_return.
    EXIT.
  ELSE.
    url = url_json.
  ENDIF.

  cl_http_client=>create_by_url( EXPORTING
                                  url                    = url
                                 IMPORTING
                                  client                 = http_client
                                 EXCEPTIONS
                                  argument_not_found     = 1
                                  plugin_not_active      = 2
                                  internal_error         = 3
                                  OTHERS                 = 4 ).

  IF sy-subrc <> 0.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'CREATE_BY_URL'
                    message_v3 = url_json
                    message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'ARGUMENT_NOT_FOUND'
                                                    WHEN '2' THEN 'PLUGIN_NOT_ACTIVE'
                                                    WHEN '3' THEN 'INTERNAL_ERROR'
                                                    WHEN '4' THEN 'HTTP ERROR' ) ) TO et_return.
  ELSE.
    http_client->request->set_method( if_http_request=>co_request_method_get ).
  ENDIF.

  CHECK http_client IS NOT INITIAL.
  http_client->propertytype_logon_popup = if_http_client=>co_disabled.
  http_client->send( EXCEPTIONS http_communication_failure = 1
                                http_invalid_state         = 2
                                http_processing_failed     = 3
                                http_invalid_timeout       = 4
                                OTHERS                     = 5 ).

  IF sy-subrc <> 0.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'SEND'
                    message_v3 = url_json
                    message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'HTTP_COMMUNICATION_FAILURE'
                                                    WHEN '2' THEN 'HTTP_INVALID_STATE'
                                                    WHEN '3' THEN 'HTTP_PROCESSING_FAILED'
                                                    WHEN '4' THEN 'HTTP_INVALID_TIMEOUT'
                                                    WHEN '5' THEN 'HTTP ERROR' ) ) TO et_return.
  ENDIF.

  TRY.
      http_client->receive( EXCEPTIONS
                              http_communication_failure = 1
                              http_invalid_state         = 2
                              http_processing_failed     = 3
                              OTHERS                     = 4 ).
      IF sy-subrc <> 0.
        APPEND VALUE #( type = 'E'
                        message_v1 = 'RECEIVE'
                        message_v3 = url_json
                        message_v2 = SWITCH #( sy-subrc WHEN '1' THEN 'HTTP_COMMUNICATION_FAILURE'
                                                        WHEN '2' THEN 'HTTP_INVALID_STATE'
                                                        WHEN '3' THEN 'HTTP_PROCESSING_FAILED'
                                                        WHEN '4' THEN 'HTTP ERROR' ) ) TO et_return.
      ENDIF.

      "200 başarılı, 404 bulunamadı, 500 server hatası
      http_client->response->get_status( IMPORTING
                                            code = lv_code
                                            reason = lv_err_string ).
    CATCH cx_root INTO lx_exception.
      lv_err_string = lx_exception->get_text( ).
      APPEND VALUE #( type = 'E'
                      message_v1 = 'CX_ROOT'
                      message_v2 = lv_err_string ) TO et_return.
  ENDTRY.

  IF lv_code NE '200'.
    APPEND VALUE #( type = 'E'
                    message_v1 = 'HTTP STATUS ERROR'
                    message_v3 = url_json
                    message_v2 = |HTTP ERROR: { lv_code }| ) TO et_return.
  ENDIF.

  CHECK lv_code EQ '200'. " 200 başarılı

  lv_response = http_client->response->get_cdata( ).

  ev_response = lv_response.

  DATA(ref) = zcl_json_data=>convert( json = lv_response ).

  ASSIGN ref->* TO FIELD-SYMBOL(<fs_data>).

  IF <fs_data> IS ASSIGNED.
*    ls_json = CORRESPONDING #( <fs_data> ).
  ENDIF.



ENDFUNCTION.
