@AbapCatalog.sqlViewName: 'ZOE_V_VBRK_FAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VBRK CDS View'
@Search.searchable: true
@VDM.viewType: #BASIC
@UI.headerInfo: { typeName: 'Fatura Belgesi',
                  typeNamePlural: 'Fatura Belgeleri' }
define view zoe_fat_vbrk
  as select from    vbrk  as v
    left outer join bseg  as b on  v.vbeln = b.vbeln
                               and b.netdt is not initial
    left outer join tvzbt as z on  v.zterm = z.zterm
                               and z.spras = $session.system_language
  association [0..*] to zoe_fat_vbrp as _items on $projection.vbeln = _items.vbeln
  association [1]    to zoe_fkart_vh as _fkart on v.fkart = _fkart.fkart
  association [1]    to zoe_vkorg_vh as _vkorg on v.vkorg = _vkorg.vkorg
  association [1]    to zoe_vtweg_vh as _vtweg on v.vtweg = _vtweg.vtweg
  association [1]    to zoe_kdgrp_vh as _kdgrp on v.kdgrp = _kdgrp.kdgrp
  association [1]    to kna1         as _kna1  on (
      _kna1.kunnr    = v.kunrg
      or _kna1.kunnr = v.kunag
    )
{
      @UI.facet: [
                  {   id: 'idHead',
                      purpose: #HEADER,
                      label: 'Fatura',
                      type: #FIELDGROUP_REFERENCE,
                      targetQualifier: 'fgHeader' },
                  {   id: 'idHeader',
                      type: #COLLECTION,
                      label: 'Başlık',
                      position: 10 },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Fatura Bilgileri',
                        parentId: 'idHeader',
                        id: 'idFatura',
                        position: 10,
                        targetQualifier: 'fgFatura' },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Muhatap Bilgileri',
                        parentId: 'idHeader',
                        id: 'idMuhatap',
                        position: 20,
                        targetQualifier: 'fgMuhatap' },
                    {   type: #FIELDGROUP_REFERENCE,
                        label: 'Diğer Bilgiler',
                        parentId: 'idHeader',
                        id: 'idDiger',
                        position: 30,
                        targetQualifier: 'fgDiger' },
                  { id: 'idItems',
                    type: #LINEITEM_REFERENCE,
                    label: 'Kalem',
                    position: 20,
                    targetElement: '_items' }]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 10 }]
  key v.vbeln,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 20 }]
      v.xblnr,

      @UI.lineItem: [{ position: 30 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
      v.fkdat,

      @UI.lineItem: [{ position: 40 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 20 }]
      @UI.selectionField: [{ position: 20 }]
      @ObjectModel.text.element: ['belge_turu_tanimi']
      @Consumption.valueHelp: '_fkart'
      v.fkart,

      @Semantics.text: true
      @EndUserText.label: 'Belge Türü Tanımı'
      _fkart.vtext                             as belge_turu_tanimi,

      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 30 }]
      v.ernam,

      @UI.lineItem: [{ position: 60 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 10 }]
      @UI.selectionField: [{ position: 30 }]
      @ObjectModel.text.element: ['ktext']
      @Consumption.valueHelp: '_kdgrp'
      v.kdgrp,

      @Semantics.text: true
      @EndUserText.label: 'Müşteri Grubu Tanımı'
      _kdgrp.ktext,

      @UI.lineItem: [{ position: 70 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 20 }]
      @ObjectModel.text.element: ['name_kunrg']
      v.kunrg,

      @Semantics.text: true
      @EndUserText.label: 'Ödeyen Adı'
      _kna1[ kunnr = $projection.kunrg ].name1 as name_kunrg,

      @UI.lineItem: [{ position: 80 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 30 }]
      @ObjectModel.text.element: ['name_kunag']
      v.kunag,

      @Semantics.text: true
      @EndUserText.label: 'Sipraiş Veren Adı'
      _kna1[ kunnr = $projection.kunag ].name1 as name_kunag,

      @UI.lineItem: [{ position: 90 }]
      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 10 }]
      @UI.selectionField: [{ position: 40 }]
      @ObjectModel.text.element: ['satis_org_tanimi']
      @Consumption.valueHelp: '_vkorg'
      v.vkorg,

      @Semantics.text: true
      @EndUserText.label: 'Satış Organizasyonu Tanımı'
      _vkorg.vtext                             as satis_org_tanimi,

      @UI.lineItem: [{ position: 100 }]
      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 20 }]
      @UI.selectionField: [{ position: 50 }]
      @ObjectModel.text.element: ['dagitim_kanali_tanimi']
      @Consumption.valueHelp: '_vtweg'
      v.vtweg,

      @Semantics.text: true
      @EndUserText.label: 'Dağıtım Kanalı Tanımı'
      _vtweg.vtext                             as dagitim_kanali_tanimi,

      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 30 }]
      @ObjectModel.text.element: ['odeme_kosulu_tanimi']
      v.zterm,

      @Semantics.text: true
      @EndUserText.label: 'Ödeme Koşulu Tanımı'
      z.vtext                                  as odeme_kosulu_tanimi,

      _kna1,
      _items,
      _fkart,
      _vkorg,
      _vtweg,
      _kdgrp

}
