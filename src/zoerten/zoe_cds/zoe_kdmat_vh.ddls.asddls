@AbapCatalog.sqlViewName: 'ZOE_VH_KDMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'kdmat vh'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view zoe_kdmat_vh
  as select from SHSM_KNMT_REF as s
{
      //s
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key kunnr,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key vkorg,
  key kdmat,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key matnr,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key vtweg,
      kdptx,
      /* Associations */
      //s
      _Customer
}
