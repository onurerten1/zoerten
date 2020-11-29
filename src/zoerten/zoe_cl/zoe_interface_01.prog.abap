*&---------------------------------------------------------------------*
*& Report ZOE_INTERFACE_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_interface_01.
INTERFACE interface1.
  METHODS msg.
ENDINTERFACE.
CLASS num_counter DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface1.
    METHODS add_number.
  PRIVATE SECTION.
    DATA num TYPE i.
ENDCLASS.
CLASS num_counter IMPLEMENTATION.
  METHOD interface1~msg.
    WRITE: / 'The Number is ', num.
  ENDMETHOD.
  METHOD add_number.
    ADD 7 TO num.
  ENDMETHOD.
ENDCLASS.
CLASS drive1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES interface1.
    METHODS speed1.
  PRIVATE SECTION.
    DATA wheel1 TYPE i.
ENDCLASS.
CLASS drive1 IMPLEMENTATION.
  METHOD interface1~msg.
    WRITE: / 'Total number of wheels is ', wheel1.
  ENDMETHOD.
  METHOD speed1.
    ADD 4 TO wheel1.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA object1 TYPE REF TO num_counter.
  CREATE OBJECT object1.

  CALL METHOD object1->add_number.
  CALL METHOD object1->interface1~msg.

  DATA object2 TYPE REF TO drive1.
  CREATE OBJECT object2.

  CALL METHOD object2->speed1.
  CALL METHOD object2->interface1~msg.
