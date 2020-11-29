*&---------------------------------------------------------------------*
*& Include          ZOE_OO_ALV2_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.

  PERFORM create_objects.
  PERFORM splitter.
  PERFORM coloring.
  gv_check = 1.
  PERFORM fill_fcat1 USING '_LEFT'.
  PERFORM modify_fcat_left.
  PERFORM fill_layout1.
  PERFORM create_alv1 USING '_LEFT'.
  CLEAR: gv_check.


ENDMODULE.
