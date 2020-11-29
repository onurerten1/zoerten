*&---------------------------------------------------------------------*
*& Include ZOE_V001FF01
*&---------------------------------------------------------------------*
FORM get_bukrs_text.
  IF zoe_v001-bukrs IS NOT INITIAL.
    SELECT SINGLE butxt
      FROM t001
      INTO zoe_v001-butxt
      WHERE bukrs = zoe_v001-bukrs.
  ENDIF.
ENDFORM.
