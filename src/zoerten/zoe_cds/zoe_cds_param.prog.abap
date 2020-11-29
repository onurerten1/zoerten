*&---------------------------------------------------------------------*
*& Report ZOE_CDS_PARAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_param.

PARAMETERS: p_matnr TYPE matnr.

SELECT *
  FROM zoe_cds_param( p_matnr = @p_matnr )
  INTO TABLE @DATA(lt_cds).
