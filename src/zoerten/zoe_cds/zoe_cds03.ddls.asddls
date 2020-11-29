@AbapCatalog.sqlViewName: 'ZOECDSMARA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds mara'
define view zoe_cds03
  as select from    mara
    left outer join makt on  mara.matnr = makt.matnr
                         and makt.spras = 'T'
{
  mara.matnr,
  makt.maktx,
  mara.meins,
  mara.matkl
}
