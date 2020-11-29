*&---------------------------------------------------------------------*
*& Report ZOE_TEST_DOCUMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_test_documents MESSAGE-ID 0k.

* Declare Variables
DATA: t_signat LIKE bapisignat OCCURS 0 WITH HEADER LINE,
      t_compon LIKE bapicompon OCCURS 0 WITH HEADER LINE,
      v_doccnt TYPE char08, "bds_dcount,
      v_choice TYPE char300,
      v_answer TYPE c.

SELECTION-SCREEN BEGIN OF BLOCK bds_hlp WITH FRAME TITLE TEXT-a00.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN PUSHBUTTON /1(20) but1 USER-COMMAND call_help
                                        VISIBLE LENGTH 24.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK bds_hlp.

*--------------------------------------------------------------------*
* AT SELECTION SCREEN OUTPUT - PBO of Selection Screen
*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

* Set the BUTTON Text and Create ICON
  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = 'ICON_SYSTEM_HELP'
      text                  = 'HELP Files'
      add_stdinf            = 'X'
    IMPORTING
      result                = but1
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*--------------------------------------------------------------------*
* AT SELECTION SCREEN - PAI of Selection Screen
*--------------------------------------------------------------------*
AT SELECTION-SCREEN.

* If the push button is clicked call the HELP Files
  CASE sy-ucomm.

    WHEN 'CALL_HELP'.

* Clear and Refresh
      REFRESH: t_signat,
               t_compon.

      CLEAR: v_choice, v_answer, v_doccnt.

* Call the program to process HELP Files
* Read document details
      CALL FUNCTION 'BDS_BUSINESSDOCUMENT_GET_URL'
        EXPORTING
*         LOGICAL_SYSTEM  =
          classname       = 'PICTURES'
          classtype       = 'OT'
          client          = sy-mandt
          object_key      = 'ZOE_TEST_DOCUMENTS'
          url_lifetime    = 'T'
*         STANDARD_URL_ONLY                =
*         DATA_PROVIDER_URL_ONLY           =
*         WEB_APPLIC_SERVER_URL_ONLY       =
*         URL_USED_AT     =
*         SELECTED_INDEX  =
        TABLES
*         URIS            =
          signature       = t_signat
          components      = t_compon
        EXCEPTIONS
          nothing_found   = 1
          parameter_error = 2
          not_allowed     = 3
          error_kpro      = 4
          internal_error  = 5
          not_authorized  = 6
          OTHERS          = 7.
      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      IF sy-subrc = 0.

* Display the POP UP with all document information
        CALL FUNCTION 'POPUP_WITH_TABLE'
          EXPORTING
            endpos_col   = '80'
            endpos_row   = '10'
            startpos_col = '4'
            startpos_row = '5'
            titletext    = 'Double CLICK the HELP file to OPEN'
          IMPORTING
            choice       = v_choice
          TABLES
            valuetab     = t_compon
          EXCEPTIONS
            break_off    = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

          MESSAGE s000 WITH 'User CANCELLED Processing'.
          SUBMIT zoe_test_documents VIA SELECTION-SCREEN.
          " Necessary since on some cases after a BDS Call the program tends to hang

        ELSE.

          IF v_choice IS INITIAL.

            MESSAGE s000 WITH 'User CANCELLED Processing'.
            SUBMIT zoe_test_documents VIA SELECTION-SCREEN.
            " Necessary since on some cases after a BDS Call the program tends to hang

          ELSE.

            MESSAGE i000 WITH 'Opening SELECTED file' v_choice+16(255).

          ENDIF.

        ENDIF.

* Process data
        v_doccnt = v_choice.
        SORT t_signat BY doc_count.
        READ TABLE t_signat WITH KEY doc_count = v_doccnt.

* Open the selected document
        CALL FUNCTION 'BDS_DOCUMENT_DISPLAY'
          EXPORTING
            client          = sy-mandt
            doc_id          = t_signat-doc_id
*   TABLES
*           SIGNATURE       =
          EXCEPTIONS
            nothing_found   = 1
            parameter_error = 2
            not_allowed     = 3
            error_kpro      = 4
            internal_error  = 5
            not_authorized  = 6
            OTHERS          = 7.
        IF sy-subrc <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

* After HELP File is displayed, call back the program to prevent slowing down or hanging issues
        SUBMIT zoe_test_documents VIA SELECTION-SCREEN.
        " Necessary since on some cases after a BDS Call the program tends to hang

      ENDIF.

    WHEN OTHERS.

  ENDCASE.
