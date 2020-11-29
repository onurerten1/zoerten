*&---------------------------------------------------------------------*
*& Report ZOE_EBAN_MSEG_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_eban_mseg_deneme.

SELECT m~matnr,
       m~werks,
       e~banfn,
       m~menge,
       e~knttp,
       t~knttx,
       m~mblnr
  FROM eban AS e
  INNER JOIN mseg AS m
  ON e~ebeln = m~ebeln
  LEFT OUTER JOIN t163i AS t
  ON t~knttp = e~knttp
  AND t~spras = @sy-langu
  INTO TABLE @DATA(lt_data)
  WHERE e~knttp NE @space AND
        e~ebeln NE @space.

SELECT m~mblnr,
       m~zeile,
       m~mjahr,
       m~matnr,
       e~banfn,
       e~knttp,
       t~knttx
  FROM mseg AS m
  INNER JOIN eban AS e
  ON m~ebeln = e~ebeln
  LEFT OUTER JOIN t163i AS t
  ON t~knttp = e~knttp
  AND t~spras = @sy-langu
  INTO TABLE @DATA(lt_data2)
  WHERE e~knttp NE @space
  AND   e~ebeln NE @space.


BREAK-POINT.
