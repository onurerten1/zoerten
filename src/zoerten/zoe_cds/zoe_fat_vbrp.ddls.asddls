@AbapCatalog.sqlViewName: 'ZOE_V_VBRP_FAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VBRP CDS View'
@VDM.viewType: #BASIC
@UI.headerInfo: { typeName: 'Kalem',
                  typeNamePlural: 'Kalemler' }
define view zoe_fat_vbrp
  as select distinct from vbrp          as v
    inner join            vbrk          as k  on v.vbeln = k.vbeln
    left outer join       mara          as m  on v.matnr = m.matnr
    left outer join       t023t         as mt on  m.matkl  = mt.matkl
                                              and mt.spras = $session.system_language
    left outer join       vbap          as vp on  v.aubel = vp.vbeln
                                              and v.aupos = vp.posnr
    inner join            vbak          as vb on vp.vbeln = vb.vbeln
    left outer join       prcd_elements as p  on  k.knumv = p.knumv
                                              and v.posnr = p.kposn
                                              and p.kschl = 'MWST'
  association [1] to zoe_pstyv_vh as _pstyv on v.pstyv = _pstyv.pstyv
  association [1] to zoe_werks_vh as _werks on v.werks = _werks.werks
  association [1] to zoe_lgort_vh as _lgort on v.lgort = _lgort.lgort
  association [1] to zoe_matnr_vh as _matnr on v.matnr = _matnr.matnr
  association [1] to zoe_spart_vh as _spart on v.spart = _spart.spart
{
      @UI.facet: [
                  {   id: 'idItemInfo',
                      purpose: #HEADER,
                      label: 'Fatura Kalemi',
                      type: #FIELDGROUP_REFERENCE,
                      targetQualifier: 'fgFatKalem' },
                  {   id: 'idItem',
                      type: #COLLECTION,
                      label: 'Kalem',
                      position: 10 },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Kalem Bilgileri',
                        parentId: 'idItem',
                        id: 'idKalemBilgi',
                        position: 10,
                        targetQualifier: 'fgKalemBilgi' },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Malzeme Bilgileri',
                        parentId: 'idItem',
                        id: 'idMalzeme',
                        position: 20,
                        targetQualifier: 'fgMalzeme' },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Fiyat Bilgileri',
                        parentId: 'idItem',
                        id: 'idFiyat',
                        position: 30,
                        targetQualifier: 'fgFiyat' },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Bölüm Bilgileri',
                        parentId: 'idItem',
                        id: 'idBolum',
                        position: 40,
                        targetQualifier: 'fgBolum' }]

      @UI.fieldGroup: [{ qualifier: 'fgFatKalem', position: 10 }]
  key v.vbeln,

      @UI.lineItem: [{ position: 10 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatKalem', position: 20 }]
  key v.posnr,

      @UI.lineItem: [{ position: 20 }]
      @UI.fieldGroup: [{ qualifier: 'fgKalemBilgi', position: 20 }]
      @ObjectModel.text.element: ['kalem_tipi_tanimi']
      @Consumption.valueHelp: '_pstyv'
      v.pstyv,

      @Semantics.text: true
      @EndUserText.label: 'Kalem Tipi Tanımı'
      _pstyv.vtext                           as kalem_tipi_tanimi,

      @UI.lineItem: [{ position: 30 }]
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 10 }]
      @ObjectModel.text.element: ['uy_tanimi']
      @Consumption.valueHelp: '_werks'
      v.werks,

      @Semantics.text: true
      @EndUserText.label: 'Üretim Yeri Tanımı'
      _werks.name1                           as uy_tanimi,

      @UI.lineItem: [{ position: 40 }]
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 20 }]
      @ObjectModel.text.element: ['lgobe']
      @Consumption.valueHelp: '_lgort'
      v.lgort,

      @Semantics.text: true
      _lgort.lgobe,

      @UI.lineItem: [{ position: 50 }]
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 30 }]
      @ObjectModel.text.element: ['maktx']
      @Consumption.valueHelp: '_matnr'
      v.matnr,

      @Semantics.text: true
      _matnr.maktx,

      @UI.lineItem: [{ position: 60 }]
      @UI.fieldGroup: [{ qualifier: 'fgMalzeme', position: 40 }]
      @ObjectModel.text.element: ['wgbez']
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
      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 20 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      v.netwr,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 30 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @EndUserText.label: 'Birim Fiyat'
      case v.fkimg
      when 0 then 0
      else division(v.netwr, v.fkimg, 2) end as birim_fiyat,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 40 }]
      p.kbetr,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 50 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      v.mwsbp,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 60 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @EndUserText.label: 'Brüt Tutar'
      v.kzwi6,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 70 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @EndUserText.label: 'Kurum İskonto Oranı'
      v.kzwi3,

      @UI.fieldGroup: [{ qualifier: 'fgFiyat', position: 80 }]
      @Semantics.quantity.unitOfMeasure: 'waerk'
      @EndUserText.label: 'Diğer İndirimler'
      v.kzwi4,

      @Semantics.currencyCode: true
      v.waerk,

      @UI.fieldGroup: [{ qualifier: 'fgBolum', position: 10 }]
      @ObjectModel.text.element: ['bolum_tanimi']
      @Consumption.valueHelp: '_spart'
      v.spart,

      @Semantics.text: true
      @EndUserText.label: 'Bölüm Tanımı'
      _spart.vtext                           as bolum_tanimi,

      _pstyv,
      _werks,
      _lgort,
      _matnr,
      _spart
}
