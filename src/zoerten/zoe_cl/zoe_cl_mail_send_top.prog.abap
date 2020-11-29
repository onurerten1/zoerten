*&---------------------------------------------------------------------*
*& Include          ZOE_CL_MAIL_SEND_TOP
*&---------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************


************************************************************************
* TYPE POOLS                                                           *
************************************************************************


************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************
CONSTANTS: gc_subject TYPE so_obj_des VALUE 'Mail Test',
           gc_raw     TYPE char03 VALUE 'RAW',
           gc_htm     TYPE char03 VALUE 'HTM'.
************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: gv_mlrec         TYPE so_obj_nam,
      gv_sent_to_all   TYPE os_boolean,
      gv_email         TYPE adr6-smtp_addr,
      gv_subject       TYPE so_obj_des,
      gv_text          TYPE bcsy_text,
      gr_send_request  TYPE REF TO cl_bcs,
      gr_bcs_exception TYPE REF TO cx_bcs,
      gr_recipient     TYPE REF TO if_recipient_bcs,
      gr_sender        TYPE REF TO cl_sapuser_bcs,
      gr_document      TYPE REF TO cl_document_bcs.
************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: gs_mail LIKE zoe_mail_list,
      gt_mail LIKE TABLE OF gs_mail.

************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_raw   RADIOBUTTON GROUP gr1 DEFAULT 'X',
            p_html  RADIOBUTTON GROUP gr1,
            p_attch RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK blk.

************************************************************************
*RANGES                                                                *
************************************************************************
