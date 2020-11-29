@AbapCatalog.sqlViewName: 'ZOEVIEW01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Deneme'
define view zoe_cds_view01
  as select from scustom
{
  scustom.id,
  scustom.name,
  scustom.city
}
