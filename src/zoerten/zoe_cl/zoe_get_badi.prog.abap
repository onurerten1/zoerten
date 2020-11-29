*&---------------------------------------------------------------------*
*& Report ZOE_GET_BADI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_get_badi.

TABLES: mara.

DATA: badi TYPE REF TO zoe_badi_mat_det.

PARAMETERS: p_matnr TYPE mara-matnr OBLIGATORY.

START-OF-SELECTION.

  BREAK oerten.

  GET BADI badi.

  CALL BADI badi->get_materials
    EXPORTING
      matnr = p_matnr
    CHANGING
      mara  = mara.
