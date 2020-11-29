@AbapCatalog.sqlViewName: 'ZOE_CDS_JOIN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Join Kullanım'
define view zoe_cds_02
  as select from    mara
    left outer join makt on  mara.matnr = makt.matnr
                         and makt.spras = $session.system_language
{
  mara.matnr,
  makt.maktx
}
