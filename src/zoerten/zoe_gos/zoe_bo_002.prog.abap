*****           Implementation of object type ZOE_BO_002           *****
INCLUDE <object>.
BEGIN_DATA OBJECT. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
" begin of private,
"   to declare private attributes remove comments and
"   insert private attributes here ...
" end of private,
  BEGIN OF KEY,
      PURCHASINGDOCUMENT LIKE ZOE_ITEM_EKPO-EBELN,
      ITEM LIKE ZOE_ITEM_EKPO-EBELP,
  END OF KEY.
END_DATA OBJECT. " Do not change.. DATA is generated

begin_method gosaddobjects changing container.
DATA:
  service(255),
  busidentifs  LIKE borident OCCURS 0,
  ls_borident  TYPE borident.

CLEAR ls_borident.
ls_borident-logsys = space.
ls_borident-objtype = 'ZOE_BO_002'.
ls_borident-objkey = object-key.
APPEND ls_borident TO busidentifs.

swc_get_element container 'Service' service.
swc_set_table container 'BusIdentifs' busidentifs.
end_method.
