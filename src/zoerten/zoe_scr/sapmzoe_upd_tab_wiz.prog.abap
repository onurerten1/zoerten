*&---------------------------------------------------------------------*
*& Modulpool SAPMZOE_UPD_TAB_WIZ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzoe_upd_tab_wiz.

TABLES: mara.
TYPES: BEGIN OF ty_makt.
    INCLUDE STRUCTURE makt.
TYPES: END OF ty_makt,
tt_makt TYPE STANDARD TABLE OF ty_makt.

DATA: gt_makt     TYPE tt_makt,
      gs_makt     TYPE ty_makt,
      gt_makt_old TYPE tt_makt,
      gs_makt_old TYPE ty_makt.
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
*SELECT-OPTIONS: s_matnr FOR mara-matnr.
*SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  PERFORM get_materials.
*&---------------------------------------------------------------------*
*& Form GET_MATERIALS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_materials .

*  SELECT *
*    FROM makt
*    INTO TABLE @gt_makt
*    WHERE matnr IN @s_matnr AND
*          spras EQ @sy-langu.

  APPEND LINES OF gt_makt TO gt_makt_old.

  CALL SCREEN 0100.

ENDFORM.
