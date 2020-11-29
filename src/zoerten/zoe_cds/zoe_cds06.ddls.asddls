@AbapCatalog.sqlViewName: 'ZOECDS06'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'parameters'
define view zoe_cds06
  with parameters
    p_stat : j_status,
    p_lang : spras
  as select from    jcds
    left outer join tj02t on jcds.stat = tj02t.istat
{
  key jcds.objnr,
      jcds.stat,
      jcds.chgnr,
      jcds.inact,
      tj02t.txt04,
      tj02t.txt30
}
where
      jcds.stat   = $parameters.p_stat
  and tj02t.spras = $parameters.p_lang;
