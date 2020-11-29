@AbapCatalog.sqlViewName: 'ZOE_VH_LGORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'lgort vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_lgort_vh
  as select from t001l as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key werks,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key lgort,
      lgobe
}
