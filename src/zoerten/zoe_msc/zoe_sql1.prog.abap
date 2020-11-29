*&---------------------------------------------------------------------*
*& Report ZOE_SQL1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sql1.

SELECT m~matnr,
       t~maktx,
       length( t~maktx ) AS length
  FROM mara AS m
  LEFT OUTER JOIN makt AS t ON
  m~matnr EQ t~matnr AND
  t~spras EQ @sy-langu
  INTO TABLE @DATA(lt_mara).

SELECT matnr,
       werks,
       lgort,
       charg,
       MAX( clabs ) AS max
  FROM mchb
  INTO TABLE @DATA(lt_mchb)
  GROUP BY matnr, werks, lgort, charg.

SELECT AVG( labst ) AS avg
  FROM mard
  INTO TABLE @DATA(lt_mard).

SELECT vbeln FROM vbak
  UNION
  SELECT vbeln FROM mska
  INTO TABLE @DATA(lt_vbeln).

SELECT *
  FROM vbak
  WHERE EXISTS
  ( SELECT kdauf
      FROM caufv )
  ORDER BY erdat DESCENDING
  INTO TABLE @DATA(lt_vbak).


SELECT concat( ebeln,ebelp ) AS ebelnp
  FROM ekpo
  INTO TABLE @DATA(lt_ekpo).



BREAK-POINT.
