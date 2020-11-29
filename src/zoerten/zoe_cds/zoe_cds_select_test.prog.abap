*&---------------------------------------------------------------------*
*& Report ZOE_CDS_SELECT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_select_test.


SELECT lot~insplotcreatedonlocaldate,
       lot~inspectionlot,
       lot~plant,
       lot~material,
       mt~materialname,
       lot~manufacturingorder,
       lot~purchasingdocument,
       lot~insplotselectionsupplier,
       lot~batch,
       lot~inspectionlottype,
       it~inspectionlottypetext
  FROM i_inspectionlot AS lot
  LEFT OUTER JOIN i_materialtext AS mt ON lot~material = mt~material
  AND                                     mt~language = @sy-langu
  LEFT OUTER JOIN i_inspectionlottypetext AS it ON lot~inspectionlottype = it~inspectionlottype
  AND                                              it~language = @sy-langu
  INTO TABLE @DATA(lt_inspectionlot).

BREAK-POINT.
