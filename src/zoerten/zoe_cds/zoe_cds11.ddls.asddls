@AbapCatalog.sqlViewName: 'ZOECDS11'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Aggregate Exp'
define view zoe_cds11
  as select from sflight as a
{
  key a.carrid                         as FlgCarr,
      a.connid                         as FlgNum,
      max( a.price )                   as MaxPrice,
      min( a.price )                   as MinPrice,
      avg( a.price as abap.dec(15,2) ) as AvgPrice,
      //fltp_to_dec( avg( a.price ) as abap.dec( 15, 2 ) ) as AvgPrice,
      sum( a.price )                   as SumPrice,
      count( * )                       as TotalCount
}
group by
  a.carrid,
  a.connid
//having
//  carrid = 'AA';
