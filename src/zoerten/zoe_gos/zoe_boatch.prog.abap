*****           Implementation of object type ZOE_BOATCH           *****
INCLUDE <OBJECT>.
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
