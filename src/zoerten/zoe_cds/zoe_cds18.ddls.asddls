@AbapCatalog.sqlViewName: 'ZOE_CDS_18'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 18'
define view zoe_cds18
  with parameters
    p_to_curr   : abap.cuky( 5 ),
    p_conv_date : abap.dats
  as select distinct from sflight as a
{
  key a.carrid                                                  as FlgID,
  key a.connid                                                  as FlgConID,
  key a.fldate                                                  as FlgDat,
      a.price                                                   as FlgPrc,
      a.currency,
      currency_conversion( amount => a.price,
                           source_currency => a.currency,
                           target_currency => :p_to_curr,
                           exchange_rate_date => :p_conv_date ) as ConvPrice
}
where
      a.carrid = 'AZ'
  and a.fldate > '20160101';
