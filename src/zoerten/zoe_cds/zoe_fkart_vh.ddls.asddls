@AbapCatalog.sqlViewName: 'ZOE_VH_FKART'
@AbapCatalog.compiler.compareFilter:true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@EndUserText.label: 'Fkart value help'
define view zoe_fkart_vh
  as select from tvfkt as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key fkart,
      vtext
}
where
  t.spras = $session.system_language
