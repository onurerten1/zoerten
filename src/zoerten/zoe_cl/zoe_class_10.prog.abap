*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_10.
CLASS cl_main DEFINITION.
  PUBLIC SECTION.
    DATA: num1 TYPE i.
    METHODS: pro IMPORTING num2 TYPE i.
    EVENTS: cutoff.
ENDCLASS.
CLASS cl_eventhandler DEFINITION.
  PUBLIC SECTION.
    METHODS: handling_cutoff FOR EVENT cutoff OF cl_main.
ENDCLASS.
CLASS cl_main IMPLEMENTATION.
  METHOD pro.
    num1 = num2.
    IF num2 >= 2.
      RAISE EVENT cutoff.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS cl_eventhandler IMPLEMENTATION.
  METHOD handling_cutoff.
    WRITE: / 'Handling the Cutoff'.
    WRITE: / 'Event has been processed'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: main1 TYPE REF TO cl_main.
  DATA: eventhandler1 TYPE REF TO cl_eventhandler.

  CREATE OBJECT main1.
  CREATE OBJECT eventhandler1.

  SET HANDLER eventhandler1->handling_cutoff FOR main1.
  main1->pro( 4 ).
