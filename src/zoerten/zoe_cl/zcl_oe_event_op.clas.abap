class ZCL_OE_EVENT_OP definition
  public
  create public .

public section.

  events EVENT_METHOD
    exporting
      value(S_LIFNR_LOW) type LFA1-LIFNR optional
      value(S_LIFNR_HIGH) type LFA1-LIFNR optional
      value(IT_LFA1) type ZOE_TT_LFA1 optional .

  methods METHOD_EVENT
    for event EVENT_METHOD of ZCL_OE_EVENT_OP
    importing
      !S_LIFNR_LOW
      !S_LIFNR_HIGH
      !IT_LFA1 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_EVENT_OP IMPLEMENTATION.


  METHOD method_event.

    IF s_lifnr_low < 1000 AND s_lifnr_high > 2000.
      MESSAGE i000(0) WITH 'Enter Values Between 1000 and 2000'.
      RAISE EVENT event_method.
    ENDIF.

    SELECT *
      FROM lfa1
      INTO TABLE it_lfa1
      WHERE lifnr BETWEEN s_lifnr_low AND s_lifnr_high.

  ENDMETHOD.
ENDCLASS.
