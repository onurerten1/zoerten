@AbapCatalog.sqlViewName: 'ZOE_V_MF_MIK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MF miktar'
define view zoe_mf_mik
  as select from    vbrp
    left outer join vbap on  vbrp.aubel = vbap.vbeln
                         and vbrp.aupos = vbap.posnr
    inner join      vbak on vbap.vbeln = vbak.vbeln
{
  vbrp.vbeln,
  vbrp.posnr,
  vbrp.uepos,
  sum( vbrp.fkimg ) as sum_fkimg
}
where
  vbrp.uepos is not initial
group by
  vbrp.vbeln,
  vbrp.posnr,
  vbrp.uepos;
