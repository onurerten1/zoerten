@AbapCatalog.sqlViewName: 'ZOE_VH_KDGRP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'kdgrp vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_kdgrp_vh
  as select from t151t as t
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key kdgrp,
      ktext
}
where
  t.spras = $session.system_language
