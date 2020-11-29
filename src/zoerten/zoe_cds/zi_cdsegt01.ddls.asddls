@AbapCatalog.sqlViewName: 'ZOEDCSEGT01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Eğitim 1'
define view zi_cdsegt01
  as select from sflight as a
{
      //a
  key mandt,
  key carrid,
  key connid,
  key fldate,
      price,
      currency,
      planetype,
      seatsmax,
      seatsocc,
      paymentsum,
      seatsmax_b,
      seatsocc_b,
      seatsmax_f,
      seatsocc_f
}
