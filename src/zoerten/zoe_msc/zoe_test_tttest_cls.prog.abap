*&---------------------------------------------------------------------*
*& Include          ZOE_TEST_TTTEST_CLS
*&---------------------------------------------------------------------*
CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS: get_data.
ENDCLASS.
CLASS class1 IMPLEMENTATION.
  METHOD get_data.
    SELECT *
    UP TO 20 ROWS
    FROM mara
    INTO TABLE @DATA(lt_material).
  ENDMETHOD.
ENDCLASS.
