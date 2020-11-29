*&---------------------------------------------------------------------*
*& Include          ZOE_FS_EXCEL_01_F01
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


  DATA: lt_tab TYPE ddobjname.

  lt_tab = p_table.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = lt_tab
    TABLES
      dfies_tab      = gt_res[]
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR: gv_count.
  LOOP AT gt_res.
    ADD 1 TO gv_count.
  ENDLOOP.
*  gv_count = gv_count - 1.
*  DELETE gt_res INDEX 1.

  PERFORM build_fieldcat.
  PERFORM get_excel.
  PERFORM create_dy_tab.
  PERFORM show_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_EXCEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_excel.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = gv_count
      i_end_row               = 9999
    TABLES
      intern                  = gt_excel[]
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DO gv_count TIMES.
    DELETE gt_excel INDEX 1.
  ENDDO.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_DY_TAB
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_dy_tab .
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = gt_fieldcat
    IMPORTING
      ep_table        = gt_table.

  ASSIGN gt_table->* TO <gs_table>.

  CREATE DATA gw_line LIKE LINE OF <gs_table>.
  ASSIGN gw_line->* TO <gs_line>.

  DATA: tabix TYPE sy-tabix.



  LOOP AT gt_excel INTO gs_excel.

    ASSIGN COMPONENT gs_excel-col OF STRUCTURE <gs_line> TO <fs1>.
    IF <fs1> IS ASSIGNED.
      <fs1> = gs_excel-value.
      UNASSIGN <fs1>.
    ENDIF.

    IF gs_excel-col = gv_count.
      APPEND <gs_line> TO <gs_table>.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcat .

  DATA: ls_res LIKE LINE OF gt_res.
  DO gv_count TIMES.
    READ TABLE gt_res INTO ls_res INDEX sy-index .
    ls_res-intlen = ls_res-leng.
    CLEAR: gw_fieldcat.
    MOVE-CORRESPONDING ls_res TO gw_fieldcat.
    APPEND gw_fieldcat TO gt_fieldcat.
  ENDDO.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_alv .

  IF <gs_table> IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

  gw_layout-cwidth_opt = 'X'.

  IF grid IS INITIAL.

    CREATE OBJECT container
      EXPORTING
        container_name = 'CONTAINER'.

    CREATE OBJECT grid
      EXPORTING
        i_parent = container.

    CALL METHOD grid->set_table_for_first_display
      EXPORTING
        is_layout       = gw_layout
      CHANGING
        it_fieldcatalog = gt_fieldcat
        it_outtab       = <gs_table>.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_table .

  LOOP AT <gs_table> ASSIGNING FIELD-SYMBOL(<fs_tab>) .

    IF <fs_tab> IS  ASSIGNED.
      MODIFY (p_table) FROM <fs_tab>.
    ENDIF.

  ENDLOOP.

ENDFORM.
