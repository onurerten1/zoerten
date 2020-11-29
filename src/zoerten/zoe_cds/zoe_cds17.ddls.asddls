@AbapCatalog.sqlViewName: 'ZOE_CDS_17'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 17'
define view ZOE_CDS17
  as select distinct from mara as a
{
  key a.matnr                                                                          as Material,
      a.brgew                                                                          as MatQuan,
      a.meins                                                                          as SrcUnit,
      a.gewei                                                                          as TgtUnit,
      unit_conversion( quantity => brgew, source_unit => meins, target_unit => gewei ) as ConvF1
}
where
  a.matnr = '837';
