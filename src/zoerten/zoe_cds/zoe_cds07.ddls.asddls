@AbapCatalog.sqlViewName: 'ZOECDS07'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'mara-vbap'
define view zoe_cds07
  as select from    vbap as soitem
    left outer join mara as prod on soitem.matnr = prod.matnr
{
  key soitem.vbeln,
      soitem.posnr,
      soitem.arktx,
      prod.matnr,
      prod.mtart,
      prod.mbrsh,
      prod.matkl
}
where
  prod.matnr like 'EWM%';
