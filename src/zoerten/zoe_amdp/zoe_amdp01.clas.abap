CLASS zoe_amdp01 DEFINITION PUBLIC.
  PUBLIC SECTION.

    TYPES: tt_mara TYPE TABLE OF mara.

    INTERFACES: if_amdp_marker_hdb.

    METHODS: my_method
      IMPORTING VALUE(im_matnr) TYPE mara-matnr
      EXPORTING VALUE(et_mara)  TYPE tt_mara.

ENDCLASS.



CLASS zoe_amdp01 IMPLEMENTATION.
  METHOD my_method BY DATABASE PROCEDURE FOR HDB LANGUAGE
                      SQLSCRIPT OPTIONS READ-ONLY USING mara.
    et_mara = SELECT * FROM mara WHERE matnr = im_matnr;
  ENDMETHOD.
ENDCLASS.
