@EndUserText.label: 'Table Func'
define table function zoe_cds02
  with parameters
    @Environment.systemField: #CLIENT
    clnt   :abap.clnt,
    carrid :s_carr_id
returns
{
  client   :s_mandt;
  carrname :s_carrname;
  connid   :s_conn_id;
  cityfrom :s_from_cit;
  cityto   :s_to_city;
}
implemented by method
  CL_EXAMPLE_AMDP=>GET_FLIGHTS;