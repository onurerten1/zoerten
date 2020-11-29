@AbapCatalog.sqlViewName: 'ZOE_CDS_ASS01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Association CDS Deneme 01'
define view zoe_cds_assc01
  as select from spfli as c
  association [0..*] to sflight as _sflight on  c.carrid = _sflight.carrid
                                            and c.connid = _sflight.connid
{
  key carrid,
  key connid,
      distance,
      distid,

      _sflight[inner].fldate
}
