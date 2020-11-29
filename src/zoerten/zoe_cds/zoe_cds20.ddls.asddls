@AbapCatalog.sqlViewName: 'ZOE_CDS_20'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 20'
define view ZOE_cds20
  with parameters
    p_add_days   : abap.int4,
    p_add_months : abap.int4,
    @Environment.systemField: #SYSTEM_DATE
    p_curr_date  : abap.dats
  as select from sflight as a
{
  key a.carrid                                             as FlgID,
  key a.connid                                             as FldConnID,
  key a.fldate                                             as FlgDate,
      dats_add_days(a.fldate, :p_add_days, 'INITIAL')      as Added_DT,
      dats_add_months(a.fldate, :p_add_months, 'NULL')     as Added_MT,
      dats_days_between(a.fldate, $parameters.p_curr_date) as Days_BT,
      dats_is_valid(a.fldate)                              as IsValid
}
