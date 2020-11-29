*&---------------------------------------------------------------------*
*& Include          ZOE_STEP_LOOP_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.
  gv_status = sy-dynnr.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module TRANSP_ITAB_OUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE transp_itab_out OUTPUT.
  idx = sy-stepl + line.
  READ TABLE itab INTO wa INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS 'STATUS0101'.
  SET TITLEBAR 'TITLE0101'.
  gv_status = sy-dynnr.
  PERFORM get_data_0101.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS0200'.
  SET TITLEBAR 'TITLE0200'.
  gv_status = sy-dynnr.
  PERFORM get_data_0100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module TRANSP_ITAB_OUT2 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE transp_itab_out2 OUTPUT.
  idx = sy-stepl + line.
  READ TABLE itab2 INTO wa2 INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'STATUS0300'.
  SET TITLEBAR 'TITLE0300'.
  gv_status = sy-dynnr.
  PERFORM get_detail.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module TRANSP_ITAB_OUT3 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE transp_itab_out3 OUTPUT.
  idx = sy-stepl + line.
  READ TABLE itab3 INTO wa3 INDEX idx.
ENDMODULE.
