class ZCL_OE_WF_TRG_MLT_LINE definition
  public
  final
  create public .

public section.

  interfaces BI_OBJECT .
  interfaces BI_PERSISTENT .
  interfaces IF_WORKFLOW .

  events TRIGGER
    exporting
      value(ENAME) type PA0001-ENAME
      value(DESCRIPTION) type SWFTVALUE .

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !IM_KEY type CHAR5 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_WF_TRG_MLT_LINE IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  endmethod.


  method CONSTRUCTOR.
  endmethod.
ENDCLASS.
