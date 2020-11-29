@AbapCatalog.sqlViewName: 'ZOE_VH_PSTVY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'pstyv vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_pstyv_vh
  as select from tvapt as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key pstyv,
      vtext
}
where
  t.spras = $session.system_language
