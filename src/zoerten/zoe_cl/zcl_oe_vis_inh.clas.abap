CLASS zcl_oe_vis_inh DEFINITION
  PUBLIC
  INHERITING FROM zcl_oe_visibility
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS inh_pub .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_oe_vis_inh IMPLEMENTATION.


  METHOD inh_pub.
    WRITE:/ 'Public Method of Inherited Class'.
    CALL METHOD me->public.
    CALL METHOD me->protected.
  ENDMETHOD.
ENDCLASS.
