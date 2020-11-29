*----------------------------------------------------------------------*
***INCLUDE ZOE_ALV_DENEME_SEN_PBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.

  IF splitter IS INITIAL.
    PERFORM create_container.
    PERFORM create_splitter.
  ENDIF.

  IF gt_fieldcat_top[] IS INITIAL.
    PERFORM fill_fieldcat USING '_TOP'.
    PERFORM modify_fieldcat USING '_TOP'.
  ENDIF.

  PERFORM fill_layout USING '_TOP'.
  PERFORM create_alv USING '_TOP'.

ENDMODULE.
