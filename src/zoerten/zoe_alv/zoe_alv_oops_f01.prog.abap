*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_OOPS_F01
*&---------------------------------------------------------------------*

FORM get_data.


  SELECT * FROM ekko INTO TABLE lt_ekko UP TO 50 ROWS.
  LOOP AT lt_ekko INTO ls_ekko.
    ls_output-ebeln = ls_ekko-ebeln.
    ls_output-bukrs = ls_ekko-bukrs.
    ls_output-bstyp = ls_ekko-bstyp.
    ls_output-aedat = ls_ekko-aedat.
    ls_output-ernam = ls_ekko-ernam.

    APPEND ls_output TO lt_output.
    CLEAR ls_output.
  ENDLOOP.

  SORT lt_output BY ebeln.



  IF lt_output IS NOT INITIAL.
    CALL SCREEN 100.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM alv  USING    p_id TYPE sy-index.
*  CLEAR: grid2, container2.

  CLEAR: lt_output2, ls_output2.
  READ TABLE lt_output INTO ls_output INDEX p_id.
  IF sy-subrc = 0.
    SELECT * FROM ekpo INTO CORRESPONDING FIELDS OF TABLE lt_output2
    WHERE ebeln = ls_output-ebeln.
  ENDIF.

  REFRESH lt_fieldcat2.
  CLEAR: lw_fieldcat2.

  lw_fieldcat2-fieldname = 'EBELN'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Purchase Order'.
  lw_fieldcat2-col_pos = 1.
  lw_fieldcat2-outputlen = 18.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'EBELP'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Item'.
  lw_fieldcat2-col_pos = 2.
  lw_fieldcat2-outputlen = 5.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'MATNR'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Material'.
*  lw_fieldcat2-hotspot = 'X'.
  lw_fieldcat2-col_pos = 3.
  lw_fieldcat2-outputlen = 18.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'WERKS'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Plant'.
  lw_fieldcat2-col_pos = 4.
  lw_fieldcat2-outputlen = 5.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'MENGE'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Quantity'.
  lw_fieldcat2-col_pos = 5.
  lw_fieldcat2-outputlen = 18.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'MEINS'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Unit'.
  lw_fieldcat2-col_pos = 6.
  lw_fieldcat2-outputlen = 18.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'NETWR'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Value'.
  lw_fieldcat2-col_pos = 7.
  lw_fieldcat2-outputlen = 18.
  lw_fieldcat2-do_sum = 'X'.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.

  lw_fieldcat2-fieldname = 'AEDAT'.
  lw_fieldcat2-seltext =
  lw_fieldcat2-reptext = 'Created Date'.
  lw_fieldcat2-col_pos = 8.
  lw_fieldcat2-outputlen = 18.
  APPEND lw_fieldcat2 TO lt_fieldcat2.
  CLEAR lw_fieldcat2.



  lw_layout2-cwidth_opt = 'X'.

  IF grid2 IS INITIAL.
    CREATE OBJECT container2
      EXPORTING
        container_name = 'CONTAINER2'.

    CREATE OBJECT grid2
      EXPORTING
        i_parent = container2.

    CALL METHOD grid2->set_table_for_first_display
      EXPORTING
        is_layout       = lw_layout2
      CHANGING
        it_outtab       = lt_output2
        it_fieldcatalog = lt_fieldcat2.

  ELSE.

    grid2->refresh_table_display(
*    EXPORTING
*      is_stable      =                  " With Stable Rows/Columns
*      i_soft_refresh =                  " Without Sort, Filter, etc.
*    EXCEPTIONS
*      finished       = 1                " Display was Ended (by Export)
*      others         = 2
   ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  DATA receiver2     TYPE REF TO lcl_eventhandler.
  CREATE OBJECT receiver2.
  SET HANDLER receiver2->handle_double_click2 FOR grid2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form TRANSACTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM transaction  USING    p_id2 TYPE sy-index.
  READ TABLE lt_output2 INTO ls_output2 INDEX p_id2.
  SET PARAMETER ID 'MAT' FIELD ls_output2-matnr.
  CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SEND_MAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_popup.
  DATA: ls_read LIKE LINE OF lt_output2.
  DATA: lv_text(128).
  CLEAR gt_mailtxt[].
  LOOP AT lt_output2 INTO ls_read.
    READ TABLE lt_output2 INTO ls_read INDEX sy-tabix.
    CONCATENATE ls_read-ebeln ls_read-ebelp ls_read-matnr
            ls_read-werks INTO lv_text
            SEPARATED BY space.
    gt_mailtxt-line = lv_text.
    APPEND gt_mailtxt.
  ENDLOOP.

  CLEAR gt_mailsub.
  gt_mailsub-obj_name = 'Test'.
  gt_mailsub-obj_langu = sy-langu.
  gt_mailsub-obj_descr = 'ALV Mail'.



  gt_mailrec-rec_type = 'U'.
  gt_mailrec-receiver = 'onur.erten@mbis.com.tr'.
  APPEND gt_mailrec.

  CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = gt_mailsub
*     DOCUMENT_TYPE              = 'RAW'
*     PUT_IN_OUTBOX              = ' '
*     COMMIT_WORK                = ' '
*     IP_ENCRYPT                 =
*     IP_SIGN                    =
* IMPORTING
*     SENT_TO_ALL                =
*     NEW_OBJECT_ID              =
    TABLES
*     OBJECT_HEADER              =
      object_content             = gt_mailtxt
*     CONTENTS_HEX               =
*     OBJECT_PARA                =
*     OBJECT_PARB                =
      receivers                  = gt_mailrec
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  COMMIT WORK AND WAIT.



*  MESSAGE lv_text TYPE 'I'.
ENDFORM.
