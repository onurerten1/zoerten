@AbapCatalog.sqlViewName: 'ZOEVSTRT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'string test'
define view zoe_cds_string_test
  as select from zoe_string_test
{
  key zzindex,
      string,
      instr (string, '-')                     as location1
}
