class ZCL_OE_WF_TEST definition
  public
  final
  create public .

public section.

  interfaces BI_OBJECT .
  interfaces BI_PERSISTENT .
  interfaces IF_WORKFLOW .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_WF_TEST IMPLEMENTATION.


  method BI_OBJECT~RELEASE.
  endmethod.


  method BI_PERSISTENT~FIND_BY_LPOR.
  endmethod.
ENDCLASS.
