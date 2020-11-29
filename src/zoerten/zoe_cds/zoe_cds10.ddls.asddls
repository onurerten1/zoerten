@AbapCatalog.sqlViewName: 'ZOECDS10'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Deneme 10'
define view zoe_cds10
  with parameters
    p_date : abap.dats
  as select from sflight as a
{
  key a.carrid                 as FlgCarr,
  key a.connid                 as FlgConn,
  key case ( a.planetype )
  when '737-400' then 'BOEING'
  when 'A340-600' then 'AIRBUS'
  else 'OTHERS'
  end                          as FlgType,
  key a.fldate,
      case
      when a.price is null then 'error'
      when a.price < 200 then 'Budget'
      when a.price >= 200 and
           a.price < 400 then 'Business'
           else 'Very Costly'
           end                 as flight_type,
      $session.system_language as language
}
where
  a.fldate = $parameters.p_date;
