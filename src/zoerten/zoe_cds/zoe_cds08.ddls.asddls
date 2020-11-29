@AbapCatalog.sqlViewName: 'ZOECDS08'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'association'
@OData.publish: true
define view zoe_cds08
  as select from vbak as soHdr
  association [1..1] to zoe_cds07 as _itemProd on $projection.vbeln = _itemProd.vbeln
{
  key soHdr.vbeln,
      soHdr.auart,
      _itemProd.posnr,
      _itemProd.matnr,
      _itemProd.arktx,
      _itemProd.mtart,
      _itemProd.mbrsh,
      _itemProd // Make association public
}
where
      soHdr.auart     like 'Z%'
  and _itemProd.posnr is not null
