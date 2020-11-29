@AbapCatalog.sqlViewName: 'ZOE_CDS_14'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 14'
define view zoe_cds14
  as select distinct from makt as a
{
  a.maktx                         as Mat_Desc,
  right(a.maktx,5)                as Des_Right,

  lpad(a.maktx,6,'xx')            as Des_lpad,
  rpad(a.maktx,6,'y')             as Des_rpad,
  ltrim(a.maktx,'t')              as Des_ltrim,
  rtrim(a.maktx,'t')              as Des_rtrim,
  replace(a.maktx, 'est', 'ough') as Des_replace,
  substring(a.maktx, 2, 1)        as Des_subs,
  upper(a.maktx)                  as Des_upper
}
