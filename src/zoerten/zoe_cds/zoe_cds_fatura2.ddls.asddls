@AbapCatalog.sqlViewName: 'ZOE_CDS_FAT_RAP2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds fatura 2'
define view zoe_cds_fatura2
  as select from zoe_cds_fatura
{
  //zoe_cds_fatura
  vtweg,
  vstel,
  fkart,
  vtext,
  xblnr,
  vbeln,
  kunrg,
  name1,
  kunag,
  name11,
  fkdat,
  zterm,
  text1,
  posnr,
  matnr,
  arktx,
  fkimg,
  netwr,
  brmfy,
  mwsbp,
  toptt,
  waerk,
  trynf,
  trybf,
  tryvr,
  @EndUserText.label: 'TRY Total Price'
  @EndUserText.quickInfo: 'TRY Total Price'
  ( trynf + tryvr ) as trytt,
  vgbel,
  lifex,
  wadat_ist,
  aubel,
  brgew,
  ntgew,
  matkl,
  inco1,
  inco2,
  rfbsk,
  ernam,
  erdat,
  stawn 
}

