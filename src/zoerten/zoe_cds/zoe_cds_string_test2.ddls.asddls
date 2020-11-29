@AbapCatalog.sqlViewName: 'ZOECDSVSTR2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'string test2'
define view zoe_cds_string_test2
  as select from zoe_string_test     as t
    inner join   zoe_cds_string_test as z on t.zzindex = z.zzindex
{

  key t.zzindex,
      t.string,
      instr (t.string, '-') as location2
}
