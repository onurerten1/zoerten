@AbapCatalog.sqlViewName: 'ZOECDS05'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'join'
define view zoe_cds05
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
  spras = 'T'
