@AbapCatalog.sqlViewName: 'ZOE_CDS_24'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds deneme 24'
define view zoe_cds24
  as select from    vbak
    inner join      vbap  on  vbak.vbeln = vbap.vbeln
                          and vbap.abgru != ''
    left outer join tvagt on  vbap.abgru = tvagt.abgru
                          and spras      = $session.system_language
{
      @EndUserText.label: 'Sale Document No'
  key vbak.vbeln,
      @EndUserText.label: 'Line Item No'
      vbap.posnr,
      @EndUserText.label: 'Material'
      vbap.matnr,
      @EndUserText.label: 'Description'
      vbap.arktx,
      @EndUserText.label: 'Customer Number'
      vbak.kunnr,
      @EndUserText.label: 'Reason for Rejection'
      vbap.abgru,
      @EndUserText.label: 'Description'
      tvagt.bezei,
      @EndUserText.label: 'Document No Date'
      vbak.audat,
      @EndUserText.label: 'Month'
      substring(vbak.audat, 5, 2) as MON,
      @EndUserText.label: 'Year'
      substring(vbak.audat, 1, 4) as YYEAR
}
