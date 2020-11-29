*&---------------------------------------------------------------------*
*& Report ZOE_ENHANCEMENT_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_enhancement_deneme.


START-OF-SELECTION.
ENHANCEMENT-SECTION ZOE_ENHANCE_SECTION SPOTS ZOE_IMPLEMENT_SPOT .
WRITE : / 'Enhancement Section'.
END-ENHANCEMENT-SECTION.
SELECT *
  FROM vbak
  INTO TABLE @DATA(lt_vbak)
  UP TO 10 ROWS.

SORT lt_vbak BY vbeln.

IF lt_vbak IS NOT INITIAL.
  LOOP AT lt_vbak INTO DATA(ls_data).
    WRITE :  /02 ls_data-vbeln,
              20 ls_data-erdat,
              35 ls_data-erzet,
              45 ls_data-ernam.
  ENDLOOP.
ENDIF.
