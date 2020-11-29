@AbapCatalog.sqlViewName: 'ZOE_CDS_22'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 22'
define view ZOE_CDS22
  as select from mara as m
  association to marc as _plant on m.matnr = _plant.matnr
{
  key m.matnr,
      _plant
}
