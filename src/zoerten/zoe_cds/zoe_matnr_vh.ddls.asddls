@AbapCatalog.sqlViewName: 'ZOE_VH_MATNR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'matnr value help'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_matnr_vh
  as select from makt as t
{

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key matnr,
      maktx
}
where
  t.spras = $session.system_language
