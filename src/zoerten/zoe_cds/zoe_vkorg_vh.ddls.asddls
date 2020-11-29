@AbapCatalog.sqlViewName: 'ZOE_VH_VKORG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'vkorg vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_vkorg_vh
  as select from tvkot as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key vkorg,
      vtext
}
where
  t.spras = $session.system_language
