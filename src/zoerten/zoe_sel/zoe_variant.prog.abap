*&---------------------------------------------------------------------*
*& Report ZOE_VARIANT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_variant.

TABLES: vbap.

SELECT-OPTIONS: s_vbeln FOR vbap-vbeln,
                s_posnr FOR vbap-posnr,
                s_matnr FOR vbap-matnr.

AT SELECTION-SCREEN OUTPUT.

  DATA: lv_subrc   TYPE sy-subrc,
        lv_variant TYPE rsvar-variant.

  lv_variant = sy-uname.

  CALL FUNCTION 'RS_VARIANT_EXISTS'
    EXPORTING
      report              = sy-repid
      variant             = lv_variant
    IMPORTING
      r_c                 = lv_subrc
    EXCEPTIONS
      not_authorized      = 1
      no_report           = 2
      report_not_existent = 3
      report_not_supplied = 4
      OTHERS              = 5.
  IF lv_subrc = 0.

    CALL FUNCTION 'RS_SUPPORT_SELECTIONS'
      EXPORTING
        report               = sy-repid
        variant              = lv_variant
      EXCEPTIONS
        variant_not_existent = 1
        variant_obsolete     = 2
        OTHERS               = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.
