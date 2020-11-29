@AbapCatalog.sqlViewName: 'ZOECDS09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'authorization'
define view zoe_cds09
  as select from sflight    as a
    inner join   sflconnpos as b on a.carrid = b.carrid
{
  key a.carrid    as MyFlightCarrier,
      b.agencynum as MyAgencyNumber
}
