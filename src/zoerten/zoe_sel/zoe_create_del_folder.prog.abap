*&---------------------------------------------------------------------*
*& Report zoe_create_del_folder
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_create_del_folder.

* Selection Screen Declarations
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_cr   RADIOBUTTON GROUP rgb1 USER-COMMAND uco
                                    MODIF ID mod DEFAULT 'X',
            p_dr   RADIOBUTTON GROUP rgb1 MODIF ID mod,
            p_cdir TYPE string,
            p_ddir TYPE string.
SELECTION-SCREEN END OF BLOCK b1.

* Data declarations
DATA: result        TYPE char1,
      rc            TYPE i,
      stripped_name TYPE string,
      v_string      TYPE string.

************************************
* At Selection-Screen Output Event
************************************

AT SELECTION-SCREEN OUTPUT.

* Create Folder Checkbox Checked, Don’t display the “Path to Delete Folder” parameter
  IF p_cr = 'X'.
    LOOP AT SCREEN.
      IF screen-name = 'P_DDIR' OR
        screen-name = '%_P_DDIR_%_APP_%-TEXT'.
        screen-input = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.

* Delete Folder Checkbox Checked, Don’t display the “Path to Create Folder” parameter
    LOOP AT SCREEN.
      IF screen-name = 'P_CDIR' OR
        screen-name = '%_P_CDIR_%_APP_%-TEXT'.
        screen-input = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_cdir.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder = p_cdir.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ddir.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder = p_ddir.
************************************
* Start of Selection Event
************************************
START-OF-SELECTION.

  IF p_cr = 'X'. "Create folder radio button is checked.

*   Clear result variable
    CLEAR result.

*     Get the folder name
    CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
      EXPORTING
        full_name     = p_cdir
      IMPORTING
        stripped_name = stripped_name
      EXCEPTIONS
        x_error       = 1
        OTHERS        = 2.


*   Check if the folder name exists under the specified directory
*    which you want to create
    CALL METHOD cl_gui_frontend_services=>directory_exist
      EXPORTING
        directory            = p_cdir
      RECEIVING
        result               = result
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        wrong_parameter      = 3
        not_supported_by_gui = 4
        OTHERS               = 5.

*    If the folder name already exists then display a message.
    IF result = 'X'.

      CLEAR v_string.
      CONCATENATE 'ALREADY CONTAINS A FOLDER NAMED'
                  stripped_name
                  INTO v_string SEPARATED BY space.

      MESSAGE v_string TYPE 'I'.
      LEAVE LIST-PROCESSING.

*   If the folder name is not exist in the specified directory
    ELSE.

*     Clear return code
      CLEAR rc.

*      Create a new folder under the specified directory
      CALL METHOD cl_gui_frontend_services=>directory_create
        EXPORTING
          directory                = p_cdir
        CHANGING
          rc                       = rc
        EXCEPTIONS
          directory_create_failed  = 1
          cntl_error               = 2
          error_no_gui             = 3
          directory_access_denied  = 4
          directory_already_exists = 5
          path_not_found           = 6
          unknown_error            = 7
          not_supported_by_gui     = 8
          wrong_parameter          = 9
          OTHERS                   = 10.

      IF rc = 0.

        CLEAR v_string.
        CONCATENATE 'CREATED FOLDER NAMED'
                    stripped_name
                    INTO v_string SEPARATED BY space.

        MESSAGE v_string TYPE 'I'.
      ENDIF.

    ENDIF.

  ELSE.  "Delete folder radio button is checked.

*   Clear result variable
    CLEAR result.

*     Get the folder name
    CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
      EXPORTING
        full_name     = p_ddir
      IMPORTING
        stripped_name = stripped_name
      EXCEPTIONS
        x_error       = 1
        OTHERS        = 2.

*   Check if the folder name exists under the specified directory
*    which you want to create
    CALL METHOD cl_gui_frontend_services=>directory_exist
      EXPORTING
        directory            = p_ddir
      RECEIVING
        result               = result
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        wrong_parameter      = 3
        not_supported_by_gui = 4
        OTHERS               = 5.

    IF result <> 'X'.

      CLEAR v_string.

      CONCATENATE 'THERE IS NO FOLDER NAMED'
                  stripped_name
                  INTO v_string SEPARATED BY space.

      MESSAGE v_string TYPE 'I'.
      LEAVE LIST-PROCESSING.

*    If the folder name exist, delete that folder from the
*     specified directory
    ELSE.

*     Clear return code
      CLEAR rc.

*      Delete folder from the specified directory
      CALL METHOD cl_gui_frontend_services=>directory_delete
        EXPORTING
          directory               = p_ddir
        CHANGING
          rc                      = rc
        EXCEPTIONS
          directory_delete_failed = 1
          cntl_error              = 2
          error_no_gui            = 3
          path_not_found          = 4
          directory_access_denied = 5
          unknown_error           = 6
          not_supported_by_gui    = 7
          wrong_parameter         = 8
          OTHERS                  = 9.
      IF rc = 0.
        CLEAR v_string.

        CONCATENATE 'DELETED FOLDER NAMED'
                    stripped_name
                    INTO v_string SEPARATED BY space.

        MESSAGE v_string TYPE 'I'.
        LEAVE LIST-PROCESSING.

      ENDIF.
    ENDIF.
  ENDIF.
