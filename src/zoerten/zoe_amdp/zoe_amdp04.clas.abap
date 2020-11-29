CLASS zoe_amdp04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.

    TYPES: BEGIN OF ty_mara,
             mandt TYPE mandt,
             matnr TYPE matnr,
             maktx TYPE maktx,
           END OF ty_mara,
           tt_mara TYPE STANDARD TABLE OF ty_mara.

    METHODS:
      get_material_info
        IMPORTING
          VALUE(iv_client) TYPE mandt
          VALUE(iv_matnr)  TYPE string
        EXPORTING
          VALUE(et_info)   TYPE tt_mara
          VALUE(ev_lang)   TYPE sy-langu.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zoe_amdp04 IMPLEMENTATION.
  METHOD get_material_info BY DATABASE PROCEDURE FOR HDB LANGUAGE
                              SQLSCRIPT OPTIONS READ-ONLY USING mara makt.

    ev_lang := SESSION_CONTEXT('LOCALE_SAP');
    lt_mara = APPLY_FILTER ( mara, :iv_matnr );
    et_info = select m.mandt,
                     m.matnr,
                     x.maktx
                     FROM mara m
                     inner join :lt_mara l
                     on m.matnr = l.matnr
                     LEFT OUTER JOIN makt x
                     on m.matnr = x.matnr
                     and x.spras = :ev_lang
                     WHERE m.mandt = :iv_client
                     ORDER BY m.matnr;

  ENDMETHOD.
ENDCLASS.
