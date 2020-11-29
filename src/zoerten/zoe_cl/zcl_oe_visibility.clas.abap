class ZCL_OE_VISIBILITY definition
  public
  create public

  global friends ZCL_OE_VIS_FR .

public section.

  methods PUBLIC .
  class-methods STATIC .
  PROTECTED SECTION.

    METHODS protected .
  PRIVATE SECTION.

    METHODS private .
ENDCLASS.



CLASS ZCL_OE_VISIBILITY IMPLEMENTATION.


  METHOD private.
  ENDMETHOD.


  METHOD protected.
  ENDMETHOD.


  METHOD public.
    WRITE : / 'Main Class Public Method'.

    CALL METHOD me->protected.
    CALL METHOD me->private.
  ENDMETHOD.


  METHOD static.
  ENDMETHOD.
ENDCLASS.
