*&---------------------------------------------------------------------*
*& Report ZOE_ALSMEX_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :
* Date              :
*-----------------------------------------------------------------------
*-*
  REPORT zoe_alsmex_deneme.
*----------------------------------------------------------------------*
  INCLUDE zoe_alsmex_deneme_top.
  INCLUDE zoe_alsmex_deneme_f01.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
  INITIALIZATION.
* PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
  AT SELECTION-SCREEN.

  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
    DATA : w_filename TYPE filetable,
           w_area     TYPE file_table,
           w_rc       TYPE i,
           w_ret      TYPE i.
    DATA: r_filename LIKE LINE OF w_filename.
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = 'Select file'
        default_extension       = '*.xls'
        default_filename        = '*.xls'
        file_filter             = '*.*'
      CHANGING
        file_table              = w_filename
        rc                      = w_rc
        user_action             = w_ret
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.

    READ TABLE w_filename INTO r_filename INDEX 1.

    IF sy-subrc = 0.
      p_file = r_filename.
    ENDIF.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
  AT SELECTION-SCREEN OUTPUT.

*----------------------------------------------------------------------*
*  START-OF-SELECTION.
*----------------------------------------------------------------------*
  START-OF-SELECTION.
  PERFORM get_data.

*----------------------------------------------------------------------*
*  END-OF-SELECTION.
*----------------------------------------------------------------------*
  END-OF-SELECTION.
*PERFORM list_data.
