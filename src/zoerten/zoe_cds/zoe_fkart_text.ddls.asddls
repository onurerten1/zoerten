@AbapCatalog.sqlViewName: 'ZOE_TV_FKART'
@ObjectModel.dataCategory: #TEXT
@EndUserText.label: 'Fkart text'
@Search.searchable: true
define view ZOE_FKART_TEXT
  as select from tvfkt as text
{
      //text

  key fkart,
      @Semantics.language: true
  key spras,
      @Semantics.text:true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      vtext
}
