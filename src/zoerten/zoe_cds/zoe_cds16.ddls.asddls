@AbapCatalog.sqlViewName: 'ZOE_CDS_16'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 16'
define view ZOE_CDS16
  as select from    spfli    as a
    left outer join sgeocity as b on a.cityfrom = b.city
{
  key b.city                                                                        as Source,
  key b.city                                                                        as Destination,
  key a.carrid                                                                      as Flg_ID,
  key a.connid                                                                      as Flg_Conn,
      concat( concat(lpad ( ltrim ( cast( div(a.fltime, 60) as abap.char( 12 ) ), '0' ), 2, '0' ), ':' ) ,
      lpad ( ltrim ( cast( mod(a.fltime, 60) as abap.char( 12 ) ), '0'), 2, '0' ) ) as Flg_Time
}
