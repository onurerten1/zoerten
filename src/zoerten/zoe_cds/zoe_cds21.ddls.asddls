@AbapCatalog.sqlViewName: 'ZOE_CDS_21'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 21'
define view zoe_cds21
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    p_curr_date : abap.dats
  as select from sflconn as a
{
  key a.agencynum                                   as FlgAgy,
  key a.flconn                                      as FlgConn,
      a.arrtime                                     as FlgArr,

      dats_tims_to_tstmp
      (   $parameters.p_curr_date,
          a.arrtime,
          abap_system_timezone($session.client, 'NULL'),
          $session.client, 'NULL'     )             as FlgArrConv,

      abap_system_timezone($session.client, 'NULL') as Time_Zone
}
