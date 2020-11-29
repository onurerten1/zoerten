@AbapCatalog.sqlViewName: 'ZOE_CDS_12'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS deneme 12'
define view zoe_cds12
  as select distinct from sflight as a
{
  abs(-2)           as Abs_op,

  ceil(25.3)        as Ceil_op,
  floor(25.3)       as Floor_op,

  div(5,3)          as Div_op,
  division(5, 3, 5) as Division_op,
  mod(5,3)          as Mod_op,

  a.price           as Flg_prc,
  round(a.price,1)  as Round_op
}
