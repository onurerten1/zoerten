class ZCL_OE_WF_WORK_ITEM_EXIT definition
  public
  final
  create public .

public section.
  type-pools SWRCO .

  interfaces IF_SWF_IFS_WORKITEM_EXIT .
protected section.
private section.

  data WI_CONTEXT type ref to IF_WAPI_WORKITEM_CONTEXT .
  data PROCESS_STATUS type STRING .

  methods AFTER_WI_CREATION .
  methods AFTER_WI_EXECUTION .
ENDCLASS.



CLASS ZCL_OE_WF_WORK_ITEM_EXIT IMPLEMENTATION.


  METHOD after_wi_creation.

    DATA: lcl_v_wi_id   TYPE sww_wiid,  "Work Item ID
          lv_wid_text   TYPE char12,
          send_request  TYPE REF TO cl_bcs,
          text          TYPE bcsy_text,
          body_text     TYPE so_text255,
          document      TYPE REF TO cl_document_bcs,
          sender        TYPE REF TO cl_sapuser_bcs,
          recipient     TYPE REF TO if_recipient_bcs,
          bcs_exception TYPE REF TO cx_bcs,
          sent_to_all   TYPE os_boolean.

* For simplicity of the demo, we are only fetching the work item ID
* You can get the complete work item and workflow details as well
* Please refer class CL_SWF_RUN_WORKITEM_CONTEXT and interface IF_WAPI_WORKITEM_CONTEXT
* Get the Work Item ID
    CALL METHOD wi_context->get_workitem_id
      RECEIVING
        re_workitem = lcl_v_wi_id.

* Pass WID to text field
    CLEAR: lv_wid_text.
    lv_wid_text = lcl_v_wi_id.

*----------------------------------------------------------------------------------------*
* Send an e-mail to a dummy e-mail ID stating that the above Work Item has been created
*----------------------------------------------------------------------------------------*
    TRY.
*     -------- create persistent send request ------------------------
        send_request = cl_bcs=>create_persistent( ).

*     -------- create and set document -------------------------------
*     Build the e-mail Body
        CLEAR: body_text.
        CONCATENATE 'Work Item CREATED. WID:'
                    lv_wid_text INTO body_text SEPARATED BY space.

        APPEND body_text TO text.
        document = cl_document_bcs=>create_document(
                        i_type    = 'RAW'
                        i_text    = text
                        i_length  = '12'
                        i_subject = 'E-Mail sent AFTER Work Item CREATION' ).

*     Add document to send request
        CALL METHOD send_request->set_document( document ).

*     --------- set sender -------------------------------------------
*     note: this is necessary only if you want to set the sender
*           different from actual user (SY-UNAME). Otherwise sender is
*           set automatically with actual user.

        sender = cl_sapuser_bcs=>create( sy-uname ).
        CALL METHOD send_request->set_sender
          EXPORTING
            i_sender = sender.

*     --------- Add recipient (e-mail address) -----------------------
*     Create recipient - passing a dummy e-mail ID here
        recipient = cl_cam_address_bcs=>create_internet_address('onur.erten@mbis.com.tr' ).

*     Add recipient with its respective attributes to send request
        CALL METHOD send_request->add_recipient
          EXPORTING
            i_recipient = recipient
            i_express   = 'X'.

*     ---------- Send document ---------------------------------------
        CALL METHOD send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = sent_to_all ).

        COMMIT WORK.

* -----------------------------------------------------------
* *                     exception handling
* -----------------------------------------------------------
      CATCH cx_bcs INTO bcs_exception.
*  Write own code to catch exception
    ENDTRY.

  ENDMETHOD.


  METHOD after_wi_execution.

    DATA: lcl_v_wi_id   TYPE sww_wiid,  "Work Item ID
          lv_wid_text   TYPE char12,
          send_request  TYPE REF TO cl_bcs,
          text          TYPE bcsy_text,
          body_text     TYPE so_text255,
          document      TYPE REF TO cl_document_bcs,
          sender        TYPE REF TO cl_sapuser_bcs,
          recipient     TYPE REF TO if_recipient_bcs,
          bcs_exception TYPE REF TO cx_bcs,
          sent_to_all   TYPE os_boolean.

* For simplicity of the demo, we are only fetching the work item ID
* You can get the complete work item and workflow details as well
* Please refer class CL_SWF_RUN_WORKITEM_CONTEXT and interface IF_WAPI_WORKITEM_CONTEXT
* Get the Work Item ID
    CALL METHOD wi_context->get_workitem_id
      RECEIVING
        re_workitem = lcl_v_wi_id.

* Pass WID to text field
    CLEAR: lv_wid_text.
    lv_wid_text = lcl_v_wi_id.

*----------------------------------------------------------------------------------------*
* Send an e-mail to a dummy e-mail ID stating that the above Work Item has been created
*----------------------------------------------------------------------------------------*
    TRY.
*     -------- create persistent send request ------------------------
        send_request = cl_bcs=>create_persistent( ).

*     -------- create and set document -------------------------------
*     Build the e-mail Body
        CLEAR: body_text.
        CONCATENATE 'Work Item EXECUTED. WID:'
                    lv_wid_text INTO body_text SEPARATED BY space.

        APPEND body_text TO text.
        document = cl_document_bcs=>create_document(
                        i_type    = 'RAW'
                        i_text    = text
                        i_length  = '12'
                        i_subject = 'E-Mail sent AFTER Work Item EXECUTION' ).

*     Add document to send request
        CALL METHOD send_request->set_document( document ).

*     --------- set sender -------------------------------------------
*     note: this is necessary only if you want to set the sender
*           different from actual user (SY-UNAME). Otherwise sender is
*           set automatically with actual user.

        sender = cl_sapuser_bcs=>create( sy-uname ).
        CALL METHOD send_request->set_sender
          EXPORTING
            i_sender = sender.

*     --------- Add recipient (e-mail address) -----------------------
*     Create recipient - passing a dummy e-mail ID here
        recipient = cl_cam_address_bcs=>create_internet_address('onur.erten@mbis.com.tr' ).

*     Add recipient with its respective attributes to send request
        CALL METHOD send_request->add_recipient
          EXPORTING
            i_recipient = recipient
            i_express   = 'X'.

*     ---------- Send document ---------------------------------------
        CALL METHOD send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = sent_to_all ).

        COMMIT WORK.

* -----------------------------------------------------------
* *                     exception handling
* -----------------------------------------------------------
      CATCH cx_bcs INTO bcs_exception.
*  Write own code to catch exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_swf_ifs_workitem_exit~event_raised.


* Get the Work Item Context
    me->wi_context = im_workitem_context.

* Check if the Event after WI Creation is triggered
    IF im_event_name = swrco_event_after_creation.

* Call our method AFTER_WI_CREATION
      me->after_wi_creation( ).

* Check if the Event after WI Execution is triggered
    ELSEIF im_event_name = swrco_event_after_execution.

* Call our method AFTER_WI_EXECUTION
      me->after_wi_execution( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
