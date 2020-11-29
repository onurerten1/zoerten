@AbapCatalog.sqlViewName: 'ZOE_V_MCHB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MCHB CDS'
define view zoe_cds_mchb
  as select from    nsdm_v_mchb as m
    left outer join makt        as t on  m.matnr = t.matnr
                                     and spras   = $session.system_language
{
  key m.matnr,
  key m.werks,
  key m.lgort,
  key m.charg,
      t.maktx,
      m.clabs,
      m.cumlm,
      m.cinsm,
      m.ceinm,
      m.cspem,
      m.cretm,
      ( m.clabs + m.cumlm + m.cinsm + m.ceinm + m.cspem + m.cretm ) as total
}
