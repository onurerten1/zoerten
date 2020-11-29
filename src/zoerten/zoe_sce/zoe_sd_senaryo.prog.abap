* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :
* Date              :
*-----------------------------------------------------------------------
*-*
  REPORT zoe_sd_senaryo.
*----------------------------------------------------------------------*
INCLUDE ZOE_SD_SENARYO_TOP.
*  INCLUDE zss_sd_senaryo_oe_top.
INCLUDE ZOE_SD_SENARYO_F01.
*  INCLUDE zss_sd_senaryo_oe_f01.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
  INITIALIZATION.
    PERFORM init.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
  AT SELECTION-SCREEN ON p_list.
    CLEAR: gwa_values, gt_values.
    REFRESH gt_values.
    gwa_values-fieldname = 'P_LIST'.
    APPEND gwa_values TO gt_values.
    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        dyname             = sy-cprog
        dynumb             = sy-dynnr
        translate_to_upper = 'X'
*       REQUEST            = ' '
*       PERFORM_CONVERSION_EXITS             = ' '
*       PERFORM_INPUT_CONVERSION             = ' '
*       DETERMINE_LOOP_INDEX                 = ' '
*       START_SEARCH_IN_CURRENT_SCREEN       = ' '
*       START_SEARCH_IN_MAIN_SCREEN          = ' '
*       START_SEARCH_IN_STACKED_SCREEN       = ' '
*       START_SEARCH_ON_SCR_STACKPOS         = ' '
*       SEARCH_OWN_SUBSCREENS_FIRST          = ' '
*       SEARCHPATH_OF_SUBSCREEN_AREAS        = ' '
      TABLES
        dynpfields         = gt_values.
*     EXCEPTIONS
*       INVALID_ABAPWORKAREA                 = 1
*       INVALID_DYNPROFIELD                  = 2
*       INVALID_DYNPRONAME                   = 3
*       INVALID_DYNPRONUMMER                 = 4
*       INVALID_REQUEST                      = 5
*       NO_FIELDDESCRIPTION                  = 6
*       INVALID_PARAMETER                    = 7
*       UNDEFIND_ERROR                       = 8
*       DOUBLE_CONVERSION                    = 9
*       STEPL_NOT_FOUND                      = 10
*       OTHERS                               = 11
    READ TABLE gt_values INDEX 1 INTO gwa_values.
    IF sy-subrc = 0 AND gwa_values-fieldname IS NOT INITIAL.
      READ TABLE gt_list INTO gwa_list WITH KEY
                              key = gwa_values-fieldvalue.
*      IF sy-subrc = 0.
*        gv_selected_value = gwa_list-key.
*      ENDIF.
    ENDIF.


  AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_file.

    DATA : w_filename TYPE filetable,
           w_area     TYPE file_table,
           w_rc       TYPE i,
           w_ret      TYPE i.
    DATA: r_filename LIKE LINE OF w_filename.

*    CALL FUNCTION 'F4_FILENAME'
*      IMPORTING
*        file_name = pa_file.

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
      pa_file = r_filename.
    ENDIF.


*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
  AT SELECTION-SCREEN OUTPUT.
    PERFORM screen_loop.

*----------------------------------------------------------------------*
*  START-OF-SELECTION.
*----------------------------------------------------------------------*
  START-OF-SELECTION.
  PERFORM get_data.

*----------------------------------------------------------------------*
*  END-OF-SELECTION.
*----------------------------------------------------------------------*
  END-OF-SELECTION.
PERFORM list_data.
