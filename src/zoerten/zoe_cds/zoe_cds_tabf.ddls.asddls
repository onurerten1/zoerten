@EndUserText.label: 'CDS Table Function Test 01'
define table function zoe_cds_tabf
  with parameters
    @Environment.systemField: #CLIENT
    clnt   : abap.clnt,
    carrid : s_carr_id
returns
{
  client   : s_mandt;
  carrname : s_carrname;
  connid   : s_conn_id;
  cityfrom : s_from_cit;
  cityto   : s_to_city;
}
implemented by method
  zcl_oe_amdp_tabf=>get_flights;