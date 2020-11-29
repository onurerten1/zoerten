*&---------------------------------------------------------------------*
*& Report zoe_abstract_method
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_abstract_method.

INTERFACE sales.
  METHODS: select IMPORTING vbelnlow  TYPE vbak-vbeln
                            vbelnhigh TYPE vbak-vbeln,

    display.
ENDINTERFACE.

CLASS sales_a DEFINITION ABSTRACT.
  PUBLIC SECTION.
    DATA: tab TYPE TABLE OF vbak,
          wa  TYPE vbak.
    INTERFACES sales ABSTRACT METHODS display.
ENDCLASS.

CLASS sales_a IMPLEMENTATION.
  METHOD sales~select.
    SELECT *
    FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE @tab
    WHERE vbeln >= @vbelnlow
    AND   vbeln <= @vbelnhigh.
  ENDMETHOD.
ENDCLASS.

CLASS sales_b DEFINITION INHERITING FROM sales_a.
  PUBLIC SECTION.
    METHODS: sales~display REDEFINITION.
ENDCLASS.

CLASS sales_b IMPLEMENTATION.
  METHOD: sales~display.
    LOOP AT tab INTO wa.
      WRITE: / wa-vbeln, wa-erdat, wa-erzet, wa-ernam.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  TABLES: vbak.

  SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.

  DATA: obj TYPE REF TO sales_b.

  CREATE OBJECT obj.

  obj->sales~select( EXPORTING vbelnlow = s_vbeln-low
                                vbelnhigh = s_vbeln-high ).

  obj->sales~display( ).
