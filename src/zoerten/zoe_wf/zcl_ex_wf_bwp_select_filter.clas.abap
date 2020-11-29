class ZCL_EX_WF_BWP_SELECT_FILTER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WF_BWP_SELECT_FILTER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EX_WF_BWP_SELECT_FILTER IMPLEMENTATION.


  METHOD if_ex_wf_bwp_select_filter~apply_filter.

    re_worklist[] = im_worklist[].

  ENDMETHOD.
ENDCLASS.
