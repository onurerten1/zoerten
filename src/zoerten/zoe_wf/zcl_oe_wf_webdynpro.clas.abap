class ZCL_OE_WF_WEBDYNPRO definition
  public
  final
  create public .

public section.

  interfaces BI_OBJECT .
  interfaces BI_PERSISTENT .
  interfaces IF_WORKFLOW .

  events TRIGGER
    exporting
      value(I_KUNNR) type KUNNR .

  methods SET_CUSTOMER
    importing
      !I_KUNNR type KUNNR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_WF_WEBDYNPRO IMPLEMENTATION.


  METHOD set_customer.

* data declarations
    DATA: lv_class            TYPE sibftypeid,
          lv_event            TYPE sibfevent,
          lv_objkey           TYPE sibfinstid,
          lr_event_parameters TYPE REF TO if_swf_ifs_parameter_container,
          lv_param_name       TYPE swfdname,
          lv_id               TYPE char10.


    lv_class = 'ZCL_OE_WF_WEBDYNPRO'.
    lv_event   = 'TRIGGER'.

* Instantiate an empty event container
    CALL METHOD cl_swf_evt_event=>get_event_container
      EXPORTING
        im_objcateg  = cl_swf_evt_event=>mc_objcateg_cl
        im_objtype   = lv_class
        im_event     = lv_event
      RECEIVING
        re_reference = lr_event_parameters.

* Set up the name/value pair to be added to the container
    lv_param_name  = 'I_KUNNR'.  " parameter name of the event
    lv_id          =  i_kunnr.


    TRY.
        CALL METHOD lr_event_parameters->set
          EXPORTING
            name  = lv_param_name
            value = lv_id.

      CATCH cx_swf_cnt_cont_access_denied .
      CATCH cx_swf_cnt_elem_access_denied .
      CATCH cx_swf_cnt_elem_not_found .
      CATCH cx_swf_cnt_elem_type_conflict .
      CATCH cx_swf_cnt_unit_type_conflict .
      CATCH cx_swf_cnt_elem_def_invalid .
      CATCH cx_swf_cnt_container .
    ENDTRY.

* Raise the event passing the event container
    TRY.
        CALL METHOD cl_swf_evt_event=>raise
          EXPORTING
            im_objcateg        = cl_swf_evt_event=>mc_objcateg_cl
            im_objtype         = lv_class
            im_event           = lv_event
            im_objkey          = lv_objkey
            im_event_container = lr_event_parameters.
      CATCH cx_swf_evt_invalid_objtype .
      CATCH cx_swf_evt_invalid_event .
    ENDTRY.

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
