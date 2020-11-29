@AbapCatalog.sqlViewAppendName: 'ZOE_CDS_EXT2'
@EndUserText.label: 'Extend View 2'
extend view zoe_cds_08 with zoe_cds_09
  association to zmt_sd_colour as _colour on vbap.zzcolour = _colour.zzcolour
{
  vbap.zzcolour,
  _colour.zzcolour_txt
}
