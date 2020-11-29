CLASS zcl_oe_amdp02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_amdp_marker_hdb.

    TYPES: BEGIN OF ty_mard,
             matnr TYPE matnr,
             maktx TYPE maktx,
             werks TYPE werks_d,
             lgort TYPE lgort_d,
             labst TYPE labst,
           END OF ty_mard,
           tt_mard TYPE TABLE OF ty_mard.

    METHODS: get_mard_data
      IMPORTING
        VALUE(iv_filter) TYPE string
      EXPORTING
        VALUE(et_data)   TYPE tt_mard.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_oe_amdp02 IMPLEMENTATION.
  METHOD get_mard_data BY DATABASE PROCEDURE FOR HDB LANGUAGE
                          SQLSCRIPT OPTIONS READ-ONLY
                          USING mard makt nsdm_v_mard.

    lt_filter = APPLY_FILTER ( mard, :iv_filter );

    et_data = SELECT d.matnr,
                     t.maktx,
                     d.werks,
                     d.lgort,
                     d.labst
                     FROM NSDM_V_MARD AS d
                     INNER JOIN :lt_filter AS f
                     ON d.mandt = f.mandt
                     AND d.matnr = f.matnr
                     AND d.werks = f.werks
                     AND d.lgort = f.lgort
                     LEFT OUTER JOIN makt AS t
                     ON d.mandt = t.mandt
                     AND d.matnr = t.matnr
                     AND t.spras = SESSION_CONTEXT( 'LOCALE_SAP' )
                     WHERE d.mandt = SESSION_CONTEXT( 'CLIENT' )
                     ORDER BY d.matnr;
  ENDMETHOD.
ENDCLASS.
