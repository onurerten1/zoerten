CLASS zoe_amdp02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_amdp_marker_hdb.

    TYPES: BEGIN OF ty_order,
             vbeln      TYPE vbeln,
             posnr      TYPE posnr,
             vkorg      TYPE vkorg,
             item_price TYPE netwr_ap,
           END OF ty_order,
           tt_order TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.

    CLASS-METHODS get_salesorder_details
      IMPORTING
        VALUE(iv_vbeln) TYPE vbeln
      EXPORTING
        VALUE(et_order) TYPE tt_order.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zoe_amdp02 IMPLEMENTATION.
  METHOD get_salesorder_details BY DATABASE PROCEDURE FOR HDB LANGUAGE
                                SQLSCRIPT OPTIONS READ-ONLY USING vbak vbap.

    et_order = SELECT DISTINCT vbak.vbeln,
                      vbap.posnr,
                      vbak.vkorg,
                      vbap.netwr as item_price
                      FROM vbak
                      INNER JOIN vbap
                      ON vbak.vbeln = vbap.vbeln
                      WHERE vbak.vbeln = iv_vbeln;
  ENDMETHOD.
ENDCLASS.
