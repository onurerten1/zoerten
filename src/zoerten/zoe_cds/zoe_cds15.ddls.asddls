@AbapCatalog.sqlViewName: 'ZOE_CDS_15'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 15'
define view zoe_cds15
  as select from sflight as a
{
  key a.connid                  as Flg_Connid,

      lpad( a.connid, 6, '22' ) as Flg_lpad,
      rpad( a.connid, 6, '99' ) as Flg_rpad,
      ltrim( a.connid, '0' )    as Flg_ltrim,
      a.fldate                  as Flg_Date,
      rtrim( a.fldate, '8' )    as Flg_rtrim
}
