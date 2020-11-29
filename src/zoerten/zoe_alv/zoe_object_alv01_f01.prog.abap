*&---------------------------------------------------------------------*
*& Include          ZOE_OBJECT_ALV01_F01
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

  SELECT d~matnr,
         d~werks,
         d~lgort,
         d~labst,
         m~meins
    FROM mard AS d
    INNER JOIN mara AS m ON
    m~matnr = d~matnr
    INTO CORRESPONDING FIELDS OF TABLE @gt_0100
    UP TO 25 ROWS
    WHERE d~matnr IN @so_matnr.


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

  IF gt_0100 IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_fcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'GS_0100'
*     I_STRUCTURE_NAME       =
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_inclname             = 'ZOE_OBJECT_ALV01_TOP'
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = gt_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = gt_fcat[]
*     IT_SORT_ALV     =
*     IT_FILTER_ALV   =
*     IS_LAYOUT_ALV   =
    IMPORTING
      et_fieldcat_lvc = gt_fieldcat
*     ET_SORT_LVC     =
*     ET_FILTER_LVC   =
*     ES_LAYOUT_LVC   =
    TABLES
      it_data         = gt_0100
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_fcat .

  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'MATNR'.
        gs_fieldcat-hotspot = 'X'.
      WHEN OTHERS.
    ENDCASE.
    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.
  gs_layout-language = 'E'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_alv .

  CREATE OBJECT container
    EXPORTING
      container_name = 'CONTAINER'.

  CREATE OBJECT grid
    EXPORTING
      i_parent = container.

  CALL METHOD grid->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_0100
      it_fieldcatalog = gt_fieldcat.
  DATA: receiver TYPE REF TO lcl_eventhandler.
  CREATE OBJECT receiver.
  SET HANDLER receiver->on_hotspot_click FOR grid.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&---------------------------------------------------------------------*
FORM hotspot  USING p_row TYPE sy-index.

  CLEAR: gs_0100.
  READ TABLE gt_0100 INTO gs_0100 INDEX p_row.

  SET PARAMETER ID 'MAT' FIELD gs_0100-matnr.
  CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

ENDFORM.
