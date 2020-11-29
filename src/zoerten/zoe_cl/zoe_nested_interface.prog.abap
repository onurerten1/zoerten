*&---------------------------------------------------------------------*
*& Report zoe_nested_interface
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_nested_interface.

INTERFACE sales_a.
  METHODS: display.
ENDINTERFACE.

INTERFACE sales_b.
  METHODS: select IMPORTING vbelnlow  TYPE vbak-vbeln
                            vbelnhigh TYPE vbak-vbeln.
  INTERFACES sales_a.
ENDINTERFACE.

CLASS sales DEFINITION.
  PUBLIC SECTION.
    DATA: tab TYPE TABLE OF vbak,
          wa  TYPE vbak.
    INTERFACES sales_b.
ENDCLASS.

CLASS sales IMPLEMENTATION.
  METHOD: sales_b~select.
    SELECT *
    FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE @tab
    WHERE vbeln >= @vbelnlow
    AND   vbeln <= @vbelnhigh.
  ENDMETHOD.
  METHOD: sales_a~display.
    LOOP AT tab INTO wa.
      WRITE : / wa-vbeln, wa-erdat, wa-erzet, wa-ernam.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  TABLES: vbak.

  SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.

  DATA: obj TYPE REF TO sales.

  CREATE OBJECT obj.

  obj->sales_b~select( EXPORTING vbelnlow = s_vbeln-low
                                 vbelnhigh = s_vbeln-high ).

  obj->sales_a~display( ).
