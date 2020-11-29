@AbapCatalog.sqlViewName: 'ZOECFATRAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura Raporu Consumption View'
@OData.publish: true
@VDM.viewType: #CONSUMPTION
define view zoe_c_fat_rap
  as select distinct from zoe_fat_vbrk as z
{
      //      @UI.facet: [
      //                  {   id: 'idHead',
      //                      purpose: #HEADER,
      //                      label: 'Fatura',
      //                      type: #FIELDGROUP_REFERENCE,
      //                      targetQualifier: 'fgHeader' },
      //                  {   id: 'idHeader',
      //                      type: #COLLECTION,
      //                      label: 'Başlık',
      //                      position: 10 },
      //                    {   type: #FIELDGROUP_REFERENCE,
      //                        label: 'Fatura Bilgileri',
      //                        parentId: 'idHeader',
      //                        id: 'idFatura',
      //                        position: 10,
      //                        targetQualifier: 'fgFatura' },
      //                    {   type: #FIELDGROUP_REFERENCE,
      //                        label: 'Muhatap Bilgileri',
      //                        parentId: 'idHeader',
      //                        id: 'idMuhatap',
      //                        position: 20,
      //                        targetQualifier: 'fgMuhatap' },
      //                    {   type: #FIELDGROUP_REFERENCE,
      //                        label: 'Diğer Bilgiler',
      //                        parentId: 'idHeader',
      //                        id: 'idDiger',
      //                        position: 30,
      //                        targetQualifier: 'fgDiger' },
      //                  { id: 'idItems',
      //                    type: #LINEITEM_REFERENCE,
      //                    label: 'Kalem',
      //                    position: 20,
      //                    targetElement: '_items' }]

      //zoe_fat_vbrk
      //      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      //      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 10 }]
  key vbeln,

      //      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      //      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 20 }]
      xblnr,

      //      @UI.lineItem: [{ position: 30 }]
      //      @UI.selectionField: [{ position: 10 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 10 }]
      fkdat,

      //      @UI.lineItem: [{ position: 40 }]
      //      @UI.selectionField: [{ position: 20 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgFatura', position: 20 }]
      fkart,
      belge_turu_tanimi,

      //      @UI.fieldGroup: [{ qualifier: 'fgHeader', position: 30 }]
      ernam,

      //      @UI.lineItem: [{ position: 60 }]
      //      @UI.selectionField: [{ position: 30 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 10 }]
      kdgrp,
      ktext,

      //      @UI.lineItem: [{ position: 70 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 20 }]
      kunrg,
      name_kunrg,

      //      @UI.lineItem: [{ position: 80 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgMuhatap', position: 30 }]
      kunag,
      name_kunag,

      //      @UI.lineItem: [{ position: 90 }]
      //      @UI.selectionField: [{ position: 40 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 10 }]
      vkorg,
      satis_org_tanimi,

      //      @UI.lineItem: [{ position: 100 }]
      //      @UI.selectionField: [{ position: 50 }]
      //      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 20 }]
      vtweg,
      dagitim_kanali_tanimi,

      //      @UI.fieldGroup: [{ qualifier: 'fgDiger', position: 30 }]
      zterm,
      odeme_kosulu_tanimi,

      /* Associations */
      //zoe_fat_vbrk
      _fkart,
      _items,
      _kdgrp,
      _kna1,
      _vkorg,
      _vtweg
}
