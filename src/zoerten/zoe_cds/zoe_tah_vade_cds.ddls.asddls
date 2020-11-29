@AbapCatalog.sqlViewName: 'ZOE_V_TAH_VADE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #CONSUMPTION
@OData.publish: true
@Search.searchable: true
@EndUserText.label: 'Vergi Matrahı Tahsilat Vade CDS View'
define view zoe_tah_vade_cds
  as select distinct from vbrk
    inner join            vbrp                on vbrk.vbeln = vbrp.vbeln
    inner join            tvfk                on vbrk.fkart = tvfk.fkart
    inner join            mara                on vbrp.matnr = mara.matnr
    left outer join       vbap                on  vbrp.aubel = vbap.vbeln
                                              and vbrp.aupos = vbap.posnr
    inner join            vbak                on vbap.vbeln = vbak.vbeln
    left outer join       t023t               on  mara.matkl  = t023t.matkl
                                              and t023t.spras = $session.system_language
    left outer join       tvzbt               on  vbrk.zterm  = tvzbt.zterm
                                              and tvzbt.spras = $session.system_language
    left outer join       bseg                on  vbrk.vbeln = bseg.vbeln
                                              and bseg.netdt is not initial
    left outer join       prcd_elements as pe on  vbrk.knumv = pe.knumv
                                              and vbrp.posnr = pe.kposn
                                              and pe.kschl   = 'MWST'
  association [0..1] to zoe_fkart_vh as _tvfkt on  tvfk.fkart = _tvfkt.fkart
  association [0..1] to zoe_matnr_vh as _makt  on  vbap.matnr = _makt.matnr
  association [0..1] to zoe_pstyv_vh as _tvapt on  vbrp.pstyv = _tvapt.pstyv
  association [0..1] to zoe_kdgrp_vh as _t151t on  vbrk.kdgrp = _t151t.kdgrp
  association [0..1] to zoe_vkorg_vh as _tvkot on  vbrk.vkorg = _tvkot.vkorg
  association [0..1] to zoe_vtweg_vh as _tvtwt on  vbrk.vtweg = _tvtwt.vtweg
  association [0..1] to zoe_spart_vh as _tspat on  vbrp.spart = _tspat.spart
  association [0..1] to zoe_kdmat_vh as _kdmat on  vbap.matnr = _kdmat.matnr
                                               and vbap.kdmat = _kdmat.kdmat
  association [0..1] to zoe_werks_vh as _t001w on  vbrp.werks = _t001w.werks
  association [0..1] to zoe_lgort_vh as _t001l on  vbrp.lgort = _t001l.lgort
  association [1..1] to kna1         as _kna1  on  (
       _kna1.kunnr    = vbrk.kunrg
       or _kna1.kunnr = vbrk.kunag
     )

{
      @UI.lineItem: [{ position: 1 }]
      @UI.fieldGroup: [{ qualifier: 'General', position: 1 }]
  key vbrk.vbeln,

      @UI.lineItem: [{ position: 2 }]
      @UI.fieldGroup: [{ qualifier: 'General', position: 3 }]
  key vbrp.posnr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 2 }]
      vbrk.xblnr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 4 }]
      @UI.lineItem: [{ position: 3 }]
      vbrp.pstyv,

      @UI.fieldGroup: [{ qualifier: 'General', position: 5 }]
      @EndUserText.label: 'Kalem Tipi Tanımı'
      _tvapt.vtext,

      @UI.selectionField: [{position: 10}]
      @UI.lineItem: [{ position: 4 }]
      @UI.fieldGroup: [{ qualifier: 'General', position: 6 }]
      @Search.defaultSearchElement: true
      vbrk.fkdat,

      @UI.selectionField: [{position: 20}]
      @UI.lineItem: [{ position: 5 }]
      @UI.fieldGroup: [{ qualifier: 'General', position: 7 }]
      @Consumption.valueHelp: '_tvfkt'
      tvfk.fkart,

      @UI.fieldGroup: [{ qualifier: 'General', position: 8 }]
      @EndUserText.label: 'Belge Türü Tanımı'
      _tvfkt.vtext                             as belge_turu_tanimi,

      @UI.fieldGroup: [{ qualifier: 'General', position: 9 }]
      vbrk.ernam,

      @UI.selectionField: [{position: 100}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 10 }]
      @Consumption.valueHelp: '_t151t'
      vbrk.kdgrp,

      @UI.fieldGroup: [{ qualifier: 'General', position: 11 }]
      @EndUserText.label: 'Müşteri Grubu Tanımı'
      _t151t.ktext,

      @UI.selectionField: [{position: 60}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 12 }]
      @Consumption.valueHelp: '_kna1'
      vbrk.kunrg,

      @UI.fieldGroup: [{ qualifier: 'General', position: 13 }]
      @EndUserText.label: 'Ödeyen Adı'
      _kna1[ kunnr = $projection.kunrg ].name1 as name_kunrg,

      @UI.selectionField: [{position: 70}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 14 }]
      @Consumption.valueHelp: '_kna1'
      vbrk.kunag,

      @UI.fieldGroup: [{ qualifier: 'General', position: 15 }]
      @EndUserText.label: 'Sipariş Veren Adı'
      _kna1[ kunnr = $projection.kunag ].name1 as name_kunag,

      @UI.selectionField: [{position: 120}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 16 }]
      @Consumption.valueHelp: '_t001w'
      @UI.lineItem: [{ position: 8 }]
      vbrp.werks,

      @UI.fieldGroup: [{ qualifier: 'General', position: 17 }]
      @EndUserText.label: 'Üretim Yeri Tanımı'
      _t001w.name1,

      @UI.selectionField: [{position: 130}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 18 }]
      @Consumption.valueHelp: '_t001l'
      vbrp.lgort,

      @UI.fieldGroup: [{ qualifier: 'General', position: 19 }]
      @EndUserText.label: 'Depo Yeri Tanımı'
      _t001l.lgobe,

      @UI.selectionField: [{position: 80}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 20 }]
      @UI.lineItem: [{ position: 6 }]
      @Consumption.valueHelp: '_makt'
      vbap.matnr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 21 }]
      @UI.lineItem: [{ position: 7 }]
      _makt.maktx,

      @UI.fieldGroup: [{ qualifier: 'General', position: 22 }]
      mara.matkl,

      @UI.fieldGroup: [{ qualifier: 'General', position: 23 }]
      t023t.wgbez,

      @UI.fieldGroup: [{ qualifier: 'General', position: 24 }]
      @UI.lineItem: [{ position: 9 }]
      vbrp.fkimg,

      //  case vbak.auart
      //  when 'Z001'
      //  then sum( vbrp.fkimg )

      @UI.selectionField: [{position: 90}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 25 }]
      @Consumption.valueHelp: '_kdmat'
      vbap.kdmat,

      @UI.fieldGroup: [{ qualifier: 'General', position: 26 }]
      vbrp.eannr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 27 }]
      @UI.lineItem: [{ position: 10 }]
      vbrp.netwr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 28 }]
      @EndUserText.label: 'Birim Fiyat'
      @UI.lineItem: [{ position: 11 }]
      case vbrp.fkimg
      when 0 then 0
      else division(vbrp.netwr, vbrp.fkimg, 3)
      end                                      as birim_fiyat,

      @UI.fieldGroup: [{ qualifier: 'General', position: 29 }]
      pe.kbetr,

      @UI.fieldGroup: [{ qualifier: 'General', position: 30 }]
      vbrp.mwsbp,

      @UI.fieldGroup: [{ qualifier: 'General', position: 31 }]
      vbrp.kzwi6,

      @UI.fieldGroup: [{ qualifier: 'General', position: 32 }]
      vbrp.kzwi3,

      @UI.fieldGroup: [{ qualifier: 'General', position: 33 }]
      vbrp.kzwi4,

      //  aa*w as mal_fazlasi,

      @UI.fieldGroup: [{ qualifier: 'General', position: 34 }]
      @UI.lineItem: [{ position: 12 }]
      vbrp.waerk,

      @UI.selectionField: [{position: 30}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 35 }]
      @Consumption.valueHelp: '_tvkot'
      vbrk.vkorg,

      @UI.fieldGroup: [{ qualifier: 'General', position: 36 }]
      @EndUserText.label: 'Satış Organizasyonu Tanımı'
      _tvkot.vtext                             as satis_org_tanimi,

      @UI.selectionField: [{position: 40}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 37 }]
      @Consumption.valueHelp: '_tvtwt'
      vbrk.vtweg,

      @UI.fieldGroup: [{ qualifier: 'General', position: 38 }]
      @EndUserText.label: 'Dağıtım Kanalı Tanımı'
      _tvtwt.vtext                             as dag_kanal_tanimi,

      @UI.selectionField: [{position: 50}]
      @UI.fieldGroup: [{ qualifier: 'General', position: 39 }]
      @Consumption.valueHelp: '_tspat'
      vbrp.spart,

      @UI.fieldGroup: [{ qualifier: 'General', position: 40 }]
      @EndUserText.label: 'Bölüm Tanımı'
      _tspat.vtext                             as bolum_tanimi,

      @UI.fieldGroup: [{ qualifier: 'General', position: 41 }]
      vbrk.zterm,

      @UI.fieldGroup: [{ qualifier: 'General', position: 42 }]
      @EndUserText.label: 'Ödeme Koşulu Tanımı'
      tvzbt.vtext                              as odeme_kosul_tanimi,

      //  fatura_vade_tarihi

      @UI.fieldGroup: [{ qualifier: 'General', position: 43 }]
      bseg.netdt,

      _kdmat,
      _kna1,
      _makt,
      _t001l,
      _t001w,
      _t151t,
      _tspat,
      _tvapt,
      _tvfkt,
      _tvkot,
      _tvtwt
}
