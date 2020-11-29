@AbapCatalog.sqlViewName: 'ZOECDS04'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'zoe_cds04'
define view zoe_cds04 as select from jcds {
key objnr,
key stat,
key chgnr,
    inact    
}
