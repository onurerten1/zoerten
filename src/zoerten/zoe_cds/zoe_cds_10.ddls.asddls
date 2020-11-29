@AbapCatalog.sqlViewName: 'ZOE_CDS_ANNO1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Annotation 1 EN'
define view zoe_cds_10
  as select from vbak as k
    inner join   vbap as p on k.vbeln = p.vbeln
{
  key k.vbeln,
      @EndUserText.label: 'Item Count'
      @EndUserText.quickInfo: 'Number of Items'
      count(distinct p.posnr) as item_cnt
}
group by
  k.vbeln;
