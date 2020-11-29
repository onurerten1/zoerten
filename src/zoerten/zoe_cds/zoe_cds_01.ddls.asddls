@AbapCatalog.sqlViewName: 'ZOE_CDS_CREATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Yaratma'
define view zoe_cds_01
  as select from mara
{
  key matnr,
      mtart,
      matkl,
      meins
}
