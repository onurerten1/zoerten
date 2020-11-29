@AbapCatalog.sqlViewName: 'ZOE_CDS_UNIO1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Union 1'
define view zoe_cds_11
  as select from scustom
{
  key id,
  key 'Customer' as type,
      name,
      city,
      country
}
union select from stravelag
{
  key agencynum  as id,
  key 'Agency  ' as type,
      name,
      city,
      country
}
