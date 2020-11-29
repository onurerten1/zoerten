@AbapCatalog.sqlViewName: 'ZOE_VH_WERKS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'werks vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_werks_vh
  as select from t001w as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key werks,
      name1
}
where
  t.spras = $session.system_language
