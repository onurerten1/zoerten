*&---------------------------------------------------------------------*
*& Report ZOE_CDS_ASSOCIATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_association.

SELECT FROM zoe_cds_ass01
  FIELDS carrid,
         connid,
         SUM( distance ) AS distance
  WHERE carrid = 'AA'
  AND   connid = '17'
  GROUP BY carrid, connid
  INTO TABLE @DATA(lt_result).

IF sy-subrc = 0.
  cl_demo_output=>display_data( lt_result ).
ENDIF.
