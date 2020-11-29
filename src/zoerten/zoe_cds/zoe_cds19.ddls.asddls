@AbapCatalog.sqlViewName: 'ZOE_CDS_19'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 19'
define view zoe_cds19
  with parameters
    p_amt : abap.curr( 5, 2 )
  as select distinct from sflight as a
{
  key a.carrid                                                  as FlgID,
  key a.connid                                                  as FldConID,
  key a.fldate                                                  as FlgDat,
      a.currency,
      decimal_shift( amount => :p_amt, currency => a.currency ) as Dec_Shift
}
