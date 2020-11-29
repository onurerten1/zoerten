CLASS zoe_amdp03 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.

    TYPES: BEGIN OF gtys_scrap,
             mandt    TYPE mandt,
             budat    TYPE budat,
             arbid    TYPE objektid,
             veran    TYPE ap_veran,
             werks    TYPE werks_d,
             aufnr    TYPE aufnr,
             gmnga    TYPE ru_gmnga,
             xmnga    TYPE ru_xmnga,
             grund    TYPE co_agrnd,
             grtxt    TYPE grtxt,
             kaptprog TYPE kaptprog,
             plnbez   TYPE matnr,
             maktx    TYPE maktx,
             stprs    TYPE stprs,
             prctr    TYPE prctr,
             bwart    TYPE bwart,
             mtart    TYPE mtart,
             mtbez    TYPE mtbez,
             arbpl    TYPE arbpl,
             p_val    TYPE prcd_elements-kwert,
             s_val    TYPE prcd_elements-kwert,
             scp_p    TYPE bseg-dmbtr,
             dppms    TYPE prcd_elements-kwert,
           END OF gtys_scrap,
           gtyt_scrap TYPE STANDARD TABLE OF gtys_scrap.

    METHODS:
      fetch_prod_scrap
        IMPORTING
          VALUE(iv_client) TYPE mandt
          VALUE(iv_langu)  TYPE string
          VALUE(iv_matnr)  TYPE string
          VALUE(iv_aufk)   TYPE string
          VALUE(iv_afru)   TYPE string
          VALUE(iv_arbpl)  TYPE string
          VALUE(iv_bwart)  TYPE string
        EXPORTING
          VALUE(et_scrap)  TYPE gtyt_scrap,

      display
        CHANGING
          it_scrap TYPE gtyt_scrap.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zoe_amdp03 IMPLEMENTATION.
  METHOD fetch_prod_scrap BY DATABASE PROCEDURE FOR HDB LANGUAGE
                          SQLSCRIPT OPTIONS READ-ONLY
                          USING mara afru afko makt matdoc t157e t134t mbew aufk crhd.

    lt_mara = APPLY_FILTER ( mara, :iv_matnr );
    lt_aufk = APPLY_FILTER ( aufk, :iv_aufk );
    lt_afru = APPLY_FILTER ( afru, :iv_afru );
    lt_crhd = APPLY_FILTER ( crhd, :iv_arbpl );
    lt_matdoc = APPLY_FILTER ( matdoc, :iv_bwart );

     et_scrap =  SELECT   a.mandt,
                          a.budat,
                          a.arbid,
                          j.veran,
                          a.werks,
                          a.aufnr,
                          a.gmnga,
                          a.xmnga,
                          a.grund,
                          g.grtxt,
                          a.kaptprog,
                          b.plnbez,
                          e.maktx,
                          m.STPRS,
                          c.prctr,
                          d.bwart,
                          f.mtart,
                          h.MTBEZ,
                          j.arbpl,
                          ( gmnga * stprs ) AS p_val,
                          ( xmnga * stprs ) AS s_val,

                          CASE
                            WHEN gmnga = 0 THEN 0
                            ELSE ( xmnga / gmnga ) * 100
                          END AS scp_p,

                          CASE
                            WHEN GMNGA = 0 THEN 0
                            ELSE ( xmnga / gmnga ) * 1000000
                          END AS dppms

                          FROM :lt_afru a
                          INNER JOIN afko b
                            ON a.mandt = b.mandt AND
                               a.aufnr = b.aufnr
                          INNER JOIN :lt_aufk c
                            ON a.mandt = c.mandt AND
                               a.aufnr = c.aufnr
                          INNER JOIN :lt_matdoc d
                            ON a.mandt  = d.mandt AND
                               b.plnbez = d.matnr AND
                               a.aufnr  = d.aufnr
                          INNER JOIN :lt_mara f
                            ON a.mandt  = f.mandt AND
                               b.plnbez = f.matnr
                          LEFT OUTER JOIN makt e
                            ON e.mandt = a.mandt AND
                               e.matnr = b.plnbez AND
                               e.spras = :iv_langu
                          LEFT OUTER JOIN t157e g
                            ON g.mandt = a.mandt AND
                               g.bwart = d.bwart AND
                               g.grund = a.grund AND
                               g.spras = :iv_langu
                          LEFT OUTER JOIN t134t h
                            ON h.mandt = a.mandt AND
                               h.mtart = f.mtart AND
                               h.spras = :iv_langu
                          INNER JOIN :lt_crhd j
                            ON j.mandt = a.mandt AND
                               j.objty = 'A'     AND
                               j.objid = a.arbid
                          INNER JOIN mbew m
                            ON m.mandt = a.mandt  AND
                               m.matnr = b.plnbez AND
                               m.bwkey = a.werks
                          where a.mandt = :iv_client
                          ORDER BY b.plnbez, a.werks;
  ENDMETHOD.

  METHOD display.
    TRY.
        cl_salv_table=>factory(
                IMPORTING
                r_salv_table = DATA(lo_table)
                CHANGING
                t_table = it_scrap ).
      CATCH cx_salv_msg.
    ENDTRY.

    lo_table->get_functions( )->set_all( ).

    lo_table->get_columns( )->set_optimize( ).

    lo_table->display( ).
  ENDMETHOD.

ENDCLASS.
