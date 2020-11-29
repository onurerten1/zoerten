CLASS zcl_oe_amdp01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    TYPES: tt_mara TYPE TABLE OF mara.
    TYPES: tt_string TYPE TABLE OF zoe_string_test.

    INTERFACES: if_amdp_marker_hdb.

    METHODS get_data
      EXPORTING VALUE(et_string) TYPE tt_string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_oe_amdp01 IMPLEMENTATION.
  METHOD get_data BY DATABASE PROCEDURE FOR HDB LANGUAGE
                  SQLSCRIPT OPTIONS READ-ONLY USING zoe_string_test.
    et_string = select mandt,
                       zzindex,
                       SUBSTR_REGEXPR('(.+)\-(.+)\-(.+)' IN string GROUP 2 ) as string
*                       string
                       from ZOE_STRING_TEST;
  ENDMETHOD.
ENDCLASS.
