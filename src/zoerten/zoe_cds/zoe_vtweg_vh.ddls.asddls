@AbapCatalog.sqlViewName: 'ZOE_VH_VTWEG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'vtweg vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_vtweg_vh
  as select from tvtwt as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key vtweg,
      vtext
}
where
  t.spras = $session.system_language
