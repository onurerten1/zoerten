@AbapCatalog.sqlViewName: 'ZOE_CDS_AGGR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Aggregate Fonksiyonları'
define view zoe_cds_03
  as select from sflight as s
{
  key s.carrid                 as FlgCarr,
      max( s.price )           as MaxPrice,
      min( s.price )           as MinPrice,
      avg( s.price as S_PRICE) as AvgPrice,
      sum( s.price )           as SumPrice,
      count( * )               as TotalCount
}
group by
  s.carrid;
