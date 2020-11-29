@AbapCatalog.sqlViewName: 'ZOE_CDS_23'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 23'
define view zoe_cds23
  as select from spfli
  association to sflight as _flight on  spfli.carrid = _flight.carrid
                                    and spfli.connid = _flight.connid
{
  key carrid,
  key connid,
      _flight
}
