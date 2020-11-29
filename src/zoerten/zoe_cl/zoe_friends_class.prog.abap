*&---------------------------------------------------------------------*
*& Report zoe_friends_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_friends_class.

CLASS abc_employs DEFINITION DEFERRED.

CLASS abc_org DEFINITION FRIENDS abc_employs.
  PUBLIC SECTION.
    DATA: stock_price TYPE char10 VALUE 100.
    METHODS: display_stock_price.
  PRIVATE SECTION.
    DATA: avg_ctc TYPE char10 VALUE 200.
    METHODS: display_avg_ctc.
ENDCLASS.

CLASS abc_org IMPLEMENTATION.
  METHOD display_stock_price.
    WRITE: / stock_price.
  ENDMETHOD.
  METHOD display_avg_ctc.
    WRITE : / avg_ctc.
  ENDMETHOD.
ENDCLASS.

CLASS abc_employs DEFINITION INHERITING FROM abc_org.
  PUBLIC SECTION.
    METHODS: display_emp.
ENDCLASS.

CLASS abc_employs IMPLEMENTATION.
  METHOD display_emp.
    DATA: ref_empl TYPE REF TO abc_org.

    CREATE OBJECT ref_empl.

    CALL METHOD ref_empl->display_stock_price.
    CALL METHOD ref_empl->display_avg_ctc.
  ENDMETHOD.
ENDCLASS.

CLASS abc_shareholder DEFINITION INHERITING FROM abc_org.
  PUBLIC SECTION.
    METHODS: display_shr.
ENDCLASS.

CLASS abc_shareholder IMPLEMENTATION.
  METHOD display_shr.
    DATA: ref_shr TYPE REF TO abc_org.

    CREATE OBJECT ref_shr.

    CALL METHOD ref_shr->display_stock_price.
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.

  DATA: ref_emp TYPE REF TO abc_employs,
        ref_shr TYPE REF TO abc_shareholder.

  CREATE OBJECT ref_emp.
  CREATE OBJECT ref_shr.

  CALL METHOD ref_emp->display_emp.

  CALL METHOD ref_shr->display_shr.
