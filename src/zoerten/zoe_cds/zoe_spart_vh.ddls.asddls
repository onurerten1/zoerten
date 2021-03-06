@AbapCatalog.sqlViewName: 'ZOE_VH_SPART'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'spart vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_spart_vh
  as select from tspat as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key spart,
      vtext
}
where
  t.spras = $session.system_language
