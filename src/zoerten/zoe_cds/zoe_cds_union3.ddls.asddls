@AbapCatalog.sqlViewName: 'ZOE_CDS_UNIO3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Union 3'
define view zoe_cds_union3
  as select from scustom
{
  key id
}
where
  city = 'Liverpool'
union select from sbook
{
  key customid as id
}
where
  agencynum = '00000284';
