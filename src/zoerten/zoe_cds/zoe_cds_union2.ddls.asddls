@AbapCatalog.sqlViewName: 'ZOE_CDS_UNIO2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Union 2'
define view zoe_cds_union2
  as select from scustom
{
  key id
}
where
  city = 'Liverpool'
union all select from sbook
{
  key customid as id
}
where
  agencynum = '00000284';
