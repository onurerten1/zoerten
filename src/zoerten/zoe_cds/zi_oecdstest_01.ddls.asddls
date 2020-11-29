@AbapCatalog.sqlViewName: 'ZOECDSVTEST01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds test'
define view zi_oecdstest_01
  as select from makt
{
      //makt
  key matnr,
  key spras,
      maktx,
      cast( ' ' as abap.char( 1 ) ) as blank
      //      replace( maktx, coalesce( cast( ''  as abap.char( 1 ) ), cast( '' as abap.char( 1 ) ) ), '-' ) as replaced
}
where
  spras = $session.system_language;
