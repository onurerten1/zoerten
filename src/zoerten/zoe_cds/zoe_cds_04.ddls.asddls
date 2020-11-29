@AbapCatalog.sqlViewName: 'ZOE_CDS_STRING'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'String Functions'
define view zoe_cds_04
  as select from makt as t
{
  key t.matnr                                as Mat_Num,
      t.maktx                                as Mat_Desc,
      length(t.maktx)                        as Des_Len,
      instr (t.maktx, 'est')                 as Des_Find,
      concat(t.maktx, t.spras)               as Des_Concat,
      concat_with_space(t.maktx, t.spras, 2) as Des_Con_Space,
      left (t.maktx, 3)                      as Des_Left,
      right(t.maktx, 3)                      as Des_Right,
      lower(t.maktx)                         as Des_Lower,
      upper(t.maktx)                         as Des_Upper,
      lpad(t.maktx, 6, 'xx')                 as Des_Lpad,
      rpad(t.maktx, 6, 'y')                  as Des_Rpad,
      ltrim(t.maktx, 't')                    as Des_Ltrim,
      rtrim(t.maktx, 't')                    as Des_Rtrim,
      replace(t.maktx, 'est', 'ough')        as Des_Replace,
      substring(t.maktx, 2, 3)               as Des_Subs
}
where
  spras = $session.system_language;
