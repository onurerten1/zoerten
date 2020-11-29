@AbapCatalog.sqlViewName: 'ZOE_CDS_26'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Annotations Deneme'
define view zoe_cds26
  as select from scarr
{
  carrid,
  carrname,
  @EndUserText.label: 'Currency Code'
  currcode,
  url @<EndUserText.label: 'Homepage'
      @<EndUserText.quickInfo: 'URL for Airline'
}
