@AbapCatalog.sqlViewName: 'ZOE_CDS_13'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 13'
define view zoe_cds13
  as select distinct from makt as a
{
  key a.matnr                                as Mat_Num,
      a.maktx                                as Mat_Desc,
      length(a.maktx)                        as Des_Len,
      instr (a.maktx, 'est')                 as Des_Find,
      concat(a.maktx, a.spras)               as Des_Con,
      concat_with_space(a.maktx, a.spras, 2) as Des_Con_Space,
      left(a.maktx, 3)                       as Des_Left,
      lower(a.maktx)                         as Des_Lower
}
where
  spras = $session.system_language;
