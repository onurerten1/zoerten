CLASS zcl_oe_amdp_tabf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.
    CLASS-METHODS: get_flights FOR TABLE FUNCTION zoe_cds_tabf.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_oe_amdp_tabf IMPLEMENTATION.
  METHOD get_flights BY DATABASE FUNCTION FOR HDB LANGUAGE
                      SQLSCRIPT OPTIONS READ-ONLY USING scarr spfli.

    RETURN SELECT sc.mandt as client,
                  sc.carrname,
                  sp.connid,
                  sp.cityfrom,
                  sp.cityto
                  from scarr as sc
                  inner join spfli as sp on sc.mandt = sp.mandt
                  and sc.carrid = sp.carrid
                  where sp.mandt = :clnt
                    and sp.carrid = :carrid
                    order by sc.mandt, sc.carrname, sp.connid;
  endmethod.
ENDCLASS.
