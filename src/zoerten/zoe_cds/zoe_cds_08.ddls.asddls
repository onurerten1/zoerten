@AbapCatalog.sqlViewName: 'ZOE_CDS_EXT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Extend View 1'
define view zoe_cds_08
  as select from vbap
{
  key vbeln,
  key posnr,
      matnr,
      arktx
}
