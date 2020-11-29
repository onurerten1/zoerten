*&---------------------------------------------------------------------*
*& Report ZOE_SETLEAF_SELECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_setleaf_select.

SELECT valsign,
       valoption,
       valfrom,
       valto
  FROM setleaf
  INTO TABLE @DATA(lt_setleaf)
  WHERE setname = 'DOCTYPE'.

SELECT *
FROM t161
INTO TABLE @DATA(lt_t161)
WHERE bsart IN @lt_setleaf.
BREAK-POINT.
