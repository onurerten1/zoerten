@AbapCatalog.sqlViewName: 'ZOE_V_VBRKFAT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VBRK CDS View 2'
@Search.searchable: true
@VDM.viewType: #BASIC
define view zoe_fat_vbrk2
  as select from    vbrk  as v
    left outer join bseg  as b on  v.vbeln = b.vbeln
                               and b.netdt is not initial
    left outer join tvzbt as z on  v.zterm = z.zterm
                               and z.spras = $session.system_language
  association [1] to zoe_fkart_vh as _fkart on v.fkart = _fkart.fkart
  association [1] to zoe_vkorg_vh as _vkorg on v.vkorg = _vkorg.vkorg
  association [1] to zoe_vtweg_vh as _vtweg on v.vtweg = _vtweg.vtweg
  association [1] to zoe_kdgrp_vh as _kdgrp on v.kdgrp = _kdgrp.kdgrp
  association [1] to kna1         as _kna1  on (
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
                        targetQualifier: 'fgDiger' }
        ]

  key v.vbeln,
      v.xblnr,

      @Search.defaultSearchElement: true
      v.fkdat,

      @ObjectModel.text.element: ['belge_turu_tanimi']
      @Consumption.valueHelp: '_fkart'
      v.fkart,

      @EndUserText.label: 'Belge Türü Tanımı'
      @Semantics.text: true
      _fkart.vtext                             as belge_turu_tanimi,

      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 30 }]
      v.ernam,

      @ObjectModel.text.element: ['ktext']
      @Consumption.valueHelp: '_kdgrp'
      v.kdgrp,

      @EndUserText.label: 'Müşteri Grubu Tanımı'
      @Semantics.text: true
      _kdgrp.ktext,

      @ObjectModel.text.element: ['name_kunrg']
      v.kunrg,

      @Semantics.text: true
      @EndUserText.label: 'Ödeyen Adı'
      _kna1[ kunnr = $projection.kunrg ].name1 as name_kunrg,

      @ObjectModel.text.element: ['name_kunag']
      v.kunag,

      @Semantics.text: true
      @EndUserText.label: 'Sipraiş Veren Adı'
      _kna1[ kunnr = $projection.kunag ].name1 as name_kunag,

      @ObjectModel.text.element: ['satis_org_tanimi']
      @Consumption.valueHelp: '_vkorg'
      v.vkorg,

      @Semantics.text: true
      @EndUserText.label: 'Satış Organizasyonu Tanımı'
      _vkorg.vtext                             as satis_org_tanimi,

      @ObjectModel.text.element: ['dagitim_kanali_tanimi']
      @Consumption.valueHelp: '_vtweg'
      v.vtweg,

      @Semantics.text: true
      @EndUserText.label: 'Dağıtım Kanalı Tanımı'
      _vtweg.vtext                             as dagitim_kanali_tanimi,

      @ObjectModel.text.element: ['odeme_kosulu_tanimi']
      v.zterm,

      @Semantics.text: true
      @EndUserText.label: 'Ödeme Koşulu Tanımı'
      z.vtext                                  as odeme_kosulu_tanimi,

      _kna1,
      _fkart,
      _vkorg,
      _vtweg,
      _kdgrp

}
