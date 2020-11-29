*----------------------------------------------------------------------*
***INCLUDE ZOE_TREE_ALV_PBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.

  PERFORM create_objects.
  PERFORM create_splitter.

  IF alv_tree IS INITIAL.
    PERFORM create_tree.
    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.
    IF sy-subrc NE 0.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = 'Automation Queue failure'(801)
          txt1  = 'Internal error:'(802)
          txt2  = 'A method in the automation queue'(803)
          txt3  = 'caused a failure.'(804).
    ENDIF.
  ENDIF.
  IF alv_container IS NOT BOUND.
    CALL METHOD splitter->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = alv_container.
  ENDIF.

ENDMODULE.
