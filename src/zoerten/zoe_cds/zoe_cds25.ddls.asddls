@AbapCatalog.sqlViewName: 'ZOE_CDS_25'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 25'
define view zoe_cds25 with parameters
@EndUserText.label: 'Year'
p_mjahr : mjahr
 as select from zoe_cds24 {
    @Aggregation.default: #SUM
    sum(1) as Reject,
    kunnr,
    MON,
    YYEAR
}
where YYEAR  = :p_mjahr
group by kunnr, MON, YYEAR;
