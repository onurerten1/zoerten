@AbapCatalog.sqlViewName: 'ZOE_V_VBRPFAT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VBRP CDS View 2'
@VDM.viewType: #BASIC
define view zoe_fat_vbrp2
  as select distinct from vbrp  as v
    left outer join       mara  as m  on v.matnr = m.matnr
    left outer join       t023t as mt on  m.matkl  = mt.matkl
                                      and mt.spras = $session.system_language
    left outer join       vbap  as vp on  v.aubel = vp.vbeln
                                      and v.aupos = vp.posnr
    left outer join       tspat as sp on  v.spart  = sp.spart
                                      and sp.spras = $session.system_language
  association [1..1] to zoe_fat_vbrk2 as _header on $projection.vbeln = _header.vbeln
  association [1]    to zoe_pstyv_vh  as _pstyv  on v.pstyv = _pstyv.pstyv
  association [1]    to zoe_werks_vh  as _werks  on v.werks = _werks.werks
  association [1]    to zoe_lgort_vh  as _lgort  on v.lgort = _lgort.lgort
  association [1]    to zoe_matnr_vh  as _matnr  on v.matnr = _matnr.matnr
  association [1]    to zoe_spart_vh  as _spart  on v.spart = _spart.spart
{
      @UI.fieldGroup: [{ qualifier: 'fgFatKalem', position: 10 }]
  key v.vbeln,

      @UI.lineItem: [{ position: 10 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatKalem', position: 20 }]
  key v.posnr,

      @UI.lineItem: [{ position: 20 }]
      @ObjectModel.text.element: ['kalem_tipi_tanimi']
      @UI.fieldGroup: [{ qualifier: 'fgKalemBilgi', position: 20 }]
      v.pstyv,

      @Semantics.text: true
      @EndUserText.label: 'Kalem Tipi Tanımı'
      _pstyv.vtext                           as kalem_tipi_tanimi,

      @UI.lineItem: [{ position: 30 }]
      @ObjectModel.text.element: ['uy_tanimi']
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 10 }]
      @Consumption.valueHelp: '_werks'
      v.werks,

      @Semantics.text: true
      @EndUserText.label: 'Üretim Yeri Tanımı'
      _werks.name1                           as uy_tanimi,

      @UI.lineItem: [{ position: 40 }]
      @ObjectModel.text.element: ['lgobe']
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 20 }]
      @Consumption.valueHelp: '_lgort'
      v.lgort,

      @Semantics.text: true
      _lgort.lgobe,

      @UI.lineItem: [{ position: 50 }]
      @ObjectModel.text.element: ['maktx']
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 30 }]
      @Consumption.valueHelp: '_matnr'
      v.matnr,

      @Semantics.text: true
      _matnr.maktx,

      @UI.lineItem: [{ position: 60 }]
      @ObjectModel.text.element: ['wgbez']
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 40 }]
      m.matkl,

      @Semantics.text: true
      mt.wgbez,

      @UI.lineItem: [{ position: 70 }]
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 10 }]
      @Semantics.quantity.unitOfMeasure: 'vrkme'
      v.fkimg,

      @Semantics.unitOfMeasure: true
      v.vrkme,

      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 90 }]
      vp.kdmat,

      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 100 }]
      v.eannr,

      @UI.lineItem: [{ position: 70 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 20 }]
      v.netwr,

      @EndUserText.label: 'Birim Fiyat'
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 30 }]
      case v.fkimg
      when 0 then 0
      else division(v.netwr, v.fkimg, 2) end as birim_fiyat,

      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 40 }]
      v.mwsbp,

      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 50 }]
      @EndUserText.label: 'Brüt Tutar'
      v.kzwi6,

      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 60 }]
      @EndUserText.label: 'Kurum İskonto Oranı'
      v.kzwi3,

      @Semantics.quantity.unitOfMeasure: 'waerk'
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 70 }]
      @EndUserText.label: 'Diğer İndirimler'
      v.kzwi4,

      @Semantics.currencyCode: true
      v.waerk,

      @ObjectModel.text.element: ['bolum_tanimi']
      @UI.fieldGroup: [{ qualifier: 'fgBolum', position: 10 }]
      @Consumption.valueHelp: '_spart'
      v.spart,

      @Semantics.text: true
      @EndUserText.label: 'Bölüm Tanımı'
      _spart.vtext                           as bolum_tanimi,

      _pstyv,
      _werks,
      _lgort,
      _matnr,
      _spart,
      _header
}
