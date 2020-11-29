@AbapCatalog.sqlViewName: 'ZOEVMFSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Malzeme Fazlası CDS View'
define view zoe_malz_faz
  as select from vbrp
{
      //vbrp

  key vbeln,
      uepos,
      sum( fkimg ) as mf_miktar,
      vrkme
}
where
  uepos is not initial
group by
  vbeln,
  uepos,
  vrkme
