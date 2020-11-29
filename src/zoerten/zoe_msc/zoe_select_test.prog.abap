*&---------------------------------------------------------------------*
*& Report ZOE_SELECT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_select_test.

TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr.

SELECT DISTINCT vbeln
  FROM vbrp
  INTO TABLE @DATA(lt_vp)
  WHERE matnr IN @s_matnr.

SELECT k~vbeln,
       k~xblnr
  FROM vbrk AS k
  INNER JOIN @lt_vp AS v ON k~vbeln = v~vbeln

  ORDER BY k~vbeln
  INTO TABLE @DATA(lt_data).


SELECT matnr,
       length( replace( ltrim( replace( matnr, '0', ' ' ), ' ' ), ' ', '0' ) ) AS length_matnr
  FROM mara
  GROUP BY matnr
  ORDER BY length_matnr DESCENDING, matnr ASCENDING
  INTO TABLE @DATA(lt_max_matr).

  DATA(lv_max_matnr) = lt_max_matr[ 1 ]-matnr.

BREAK-POINT.
