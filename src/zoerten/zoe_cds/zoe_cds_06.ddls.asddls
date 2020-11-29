@AbapCatalog.sqlViewName: 'ZOE_CDS_ASC01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Association 1'
define view zoe_cds_06
  as select from mara
  association [1] to nsdm_v_marc as _plant on $projection.matnr = _plant.matnr
{
  key matnr,
      _plant // Make association public
}
