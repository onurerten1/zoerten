@AbapCatalog.sqlViewName: 'ZOE_V_MARD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MARD CDS'
define view zoe_cds_mard
  as select from    nsdm_v_mard as m
    left outer join makt        as t on  m.matnr = t.matnr
                                     and t.spras = $session.system_language
{
  key m.matnr,
  key m.werks,
  key m.lgort,
      t.maktx,
      m.labst,
      m.umlme,
      m.insme,
      m.einme,
      m.speme,
      m.retme,
      ( m.labst + m.umlme + m.insme + m.einme + m.speme + m.retme ) as total
}
