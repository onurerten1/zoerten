@AbapCatalog.sqlViewName: 'ZOECDSVTEST02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'zi_oecdstest_02'
define view zi_oecdstest_02
  as select from zi_oecdstest_01
{
      //zi_oecdstest_01
  key matnr,
  key spras,
      maktx,
      replace(maktx, blank, '-') as replaced
}
