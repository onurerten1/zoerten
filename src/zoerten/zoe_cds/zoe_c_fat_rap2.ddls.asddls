@AbapCatalog.sqlViewName: 'ZOECFATRAP2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura Raporu Consumption View 2'
@OData.publish: true
@UI.headerInfo: { typeName: 'Fatura Belgesi',
                  typeNamePlural: 'Fatura Belgeleri' }
@VDM.viewType: #CONSUMPTION
define view zoe_c_fat_rap2
  as select distinct from zoe_fat_vbrp2
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

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 10 }]
  key vbeln,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 20 }]
      _header.xblnr,

      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 10 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 10 }]
      _header.fkdat,

      @UI.lineItem: [{ position: 40 }]
      @UI.selectionField: [{ position: 20 }]
      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 20 }]
      _header.fkart,
      _header.belge_turu_tanimi,

      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 30 }]
      _header.ernam,

      @UI.lineItem: [{ position: 60 }]
      @UI.selectionField: [{ position: 30 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 10 }]
      _header.kdgrp,
      _header.ktext,

      @UI.lineItem: [{ position: 70 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 20 }]
      _header.kunrg,
      _header.name_kunrg,

      @UI.lineItem: [{ position: 80 }]
      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 30 }]
      _header.kunag,
      _header.name_kunag,

      @UI.lineItem: [{ position: 90 }]
      @UI.selectionField: [{ position: 40 }]
      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 10 }]
      _header.vkorg,
      _header.satis_org_tanimi,

      @UI.lineItem: [{ position: 100 }]
      @UI.selectionField: [{ position: 50 }]
      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 20 }]
      _header.vtweg,
      _header.dagitim_kanali_tanimi,

      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 30 }]
      _header.zterm,
      _header.odeme_kosulu_tanimi,

      //zoe_fat_vbrp2
      @UI.selectionField: [{ position: 60 }]
      @UI.lineItem: [{exclude: true}]
      werks,
      @UI.selectionField: [{ position: 70 }]
      @UI.lineItem: [{exclude: true}]
      lgort,
      @UI.selectionField: [{ position: 80 }]
      @UI.lineItem: [{exclude: true}]
      matnr,
      @UI.selectionField: [{ position: 90 }]
      @UI.lineItem: [{exclude: true}]
      spart,

      /* Associations */
      //zoe_fat_vbrp2
      _header,
      _lgort,
      _matnr,
      _spart,
      _werks
}
