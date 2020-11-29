@AbapCatalog.sqlViewName: 'ZOECFATRPR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura Raporu Consumption View'
@OData.publish: true
@VDM.viewType: #CONSUMPTION
define view zoe_c_fat_rapr
  as select from zoe_fat_vbrk
{

      //zoe_fat_vbrk
  key vbeln,
      xblnr,
      fkdat,
      fkart,
      belge_turu_tanimi,
      ernam,
      kdgrp,
      ktext,
      kunrg,
      name_kunrg,
      kunag,
      name_kunag,
      vkorg,
      satis_org_tanimi,
      vtweg,
      dagitim_kanali_tanimi,
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
