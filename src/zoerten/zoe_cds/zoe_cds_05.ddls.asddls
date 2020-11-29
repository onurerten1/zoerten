@AbapCatalog.sqlViewName: 'ZOE_CDS_PARAM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS with Parameters'
define view zoe_cds_05
  with parameters
    p_matnr : matnr
  as select from    mara as m
    left outer join makt as t on  m.matnr = t.matnr
                              and t.spras = $session.system_language
{
  key m.matnr,
      t.maktx

}
where
  m.matnr = $parameters.p_matnr;
