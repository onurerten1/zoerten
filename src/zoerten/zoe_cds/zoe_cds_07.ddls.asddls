@AbapCatalog.sqlViewName: 'ZOE_CDS_ASC02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Association 2'
define view zoe_cds_07
  as select from vbak
  association [0..1] to vbap as _item on $projection.vbeln = _item.vbeln
{
  key vbeln,
      ernam,
      erdat,
      netwr,
      waerk,
      sum(_item.netwr)              as sum_it,
      count( distinct _item.posnr ) as count_it,
      _item
}
group by
  vbeln,
  ernam,
  erdat,
  netwr,
  waerk,
  _item.posnr;
