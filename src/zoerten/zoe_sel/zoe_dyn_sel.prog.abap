*&---------------------------------------------------------------------*
*& Report ZOE_DYN_SEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_dyn_sel.
*TYPE POOLS DECLARATIONS FOR VALUE REQUEST MANAGER AND ICONS
TYPE-POOLS : vrm,
             icon.
*SELECTION SCREEN FIELDS
TABLES : sscrfields.
*GLOBAL DECLARATIONS
DATA : flag          TYPE c,
       tablename(10),
       mmtable       LIKE dd02l-tabname,
       sdtable       LIKE dd02l-tabname,
       hrtable       LIKE dd02l-tabname.
*DECLARATIONS FOR SELECTION SCREEN STATUS
DATA it_ucomm TYPE TABLE OF sy-ucomm.
***********SELECTION-SCREENS**********************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME.
*FOR DYNAMIC DISPLAY OF MODULES
PARAMETERS : pa RADIOBUTTON GROUP rad USER-COMMAND com MODIF ID mod,
             pb RADIOBUTTON GROUP rad MODIF ID rad,
             pc RADIOBUTTON GROUP rad MODIF ID cad.
SELECTION-SCREEN SKIP.
**TO INCLUDE DYNAMIC ICONS
SELECTION-SCREEN COMMENT 2(6) text_001.
*DYNAMIC LIST BOX BASED ON USER SELECTIONS
PARAMETERS one AS LISTBOX VISIBLE LENGTH 20  MODIF ID mod.
PARAMETERS two AS LISTBOX VISIBLE LENGTH 20   MODIF ID rad.
PARAMETERS three AS LISTBOX VISIBLE LENGTH 20 MODIF ID cad.
SELECTION-SCREEN END OF BLOCK blk1.
*DISPLAY DYNAMIC PUSHBUTTON ON APP TOOLBAR ON USER CLICKS
SELECTION-SCREEN: FUNCTION KEY 1,
                  FUNCTION KEY 2,
                  FUNCTION KEY 3.
**EVENT ON SELECTION SCREEN FOR OUTPUT DISPLAY
AT SELECTION-SCREEN OUTPUT.
*CLICK OF FIRST RADIO BUTTON
  IF pa = 'X'.
    sscrfields-functxt_01 = 'Materials Management'.
    WRITE icon_plant AS ICON TO text_001.
*CODE TO GET DYNAMICS BASED ON THE SELECTED RADIO
    LOOP AT SCREEN.
      IF screen-group1 = 'MOD'.
        screen-intensified = '1'.
        screen-active = 1.
        screen-display_3d = '1'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'RAD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'CAD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
*CLICK OF SECOND RADIO
  IF pb = 'X'.
    sscrfields-functxt_02 = 'Sales And Distribution'.
    WRITE icon_ws_ship AS ICON TO text_001.
    LOOP AT SCREEN.
      IF screen-group1 = 'RAD'.
        screen-intensified = '1'.
        screen-active = 1.
        screen-display_3d = '1'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'MOD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'CAD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
*CLICK OF THIRD RADIO
  IF pc = 'X'.
    sscrfields-functxt_03 = 'Human Resources'.
    WRITE icon_new_employee AS ICON TO text_001.
    LOOP AT SCREEN.
      IF screen-group1 = 'RAD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'MOD'.
        screen-intensified = '0'.
        screen-active = 0.
        screen-display_3d = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 = 'CAD'.
        screen-intensified = '1'.
        screen-active = 1.
        screen-display_3d = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
*CUSTOMISING THE TOOLBARS OF THE SELECTION SCREEN
*WITH F8 BUTTON DISABLED
  APPEND :  'PRIN' TO it_ucomm,
            'SPOS' TO it_ucomm,
            'ONLI' TO it_ucomm.
  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = sy-pfkey
    TABLES
      p_exclude = it_ucomm.
**EVENT ON THE SELECTION
AT SELECTION-SCREEN.
* LIST BOX ONE VALUES
  CASE one.
    WHEN '1'.
      mmtable = 'MARC'.
    WHEN '2'.
      mmtable = 'MARA'.
    WHEN '3'.
      mmtable = 'MARD'.
    WHEN '4'.
      mmtable = 'MARM'.
  ENDCASE.
* LIST BOX TWO VALUES
  CASE two.
    WHEN '1'.
      sdtable = 'VBAK'.
    WHEN '2'.
      sdtable = 'VBAP'.
    WHEN '3'.
      sdtable = 'VBUK'.
    WHEN '4'.
      sdtable = 'VBUP'.
  ENDCASE.
* LIST BOX THREE VALUES
  CASE three.
    WHEN '1'.
      hrtable = 'PA0001'.
    WHEN '2'.
      hrtable = 'PA0006'.
    WHEN '3'.
      hrtable = 'PA0022'.
    WHEN '4'.
      hrtable = 'PA0008'.
  ENDCASE.
*VALUES FOR CLICK OF THE PUSHBUTTON ON APP TOOLBAR
*AND ENABLING THE BUTTONS TO PERFORM F8
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      tablename = mmtable.
      sscrfields-ucomm = 'ONLI'.
    WHEN 'FC02'.
      tablename = sdtable.
      sscrfields-ucomm = 'ONLI'.
    WHEN 'FC03'.
      tablename = hrtable.
      sscrfields-ucomm = 'ONLI'.
  ENDCASE.
*INITIALIZATION EVENT
INITIALIZATION.
*VALUES ASSIGNED TO DROPDOWNLISTS IN THE SUBROUTINES
  PERFORM f4_value_request_pa.
  PERFORM f4_value_request_pb.
  PERFORM f4_value_request_pc.
*START OF SELECTION EVENT
START-OF-SELECTION.
*SUBROUTINE FOR OUTPUT
  PERFORM output.
*&----------------------------------------------------------------*
*&      Form  f4_value_request_PA
*&----------------------------------------------------------------*
*       text
*-----------------------------------------------------------------*
*SUBROUTINE TO PROVIDE DROPDOWN VALUES TO LIST1
FORM f4_value_request_pa.
  DATA: l_name  TYPE vrm_id,
        li_list TYPE vrm_values,
        l_value LIKE LINE OF li_list.
  l_value-key = '1'.
  l_value-text = 'Plant Data for Material'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '2'.
  l_value-text = 'General Material Data'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '3'.
  l_value-text = 'Storage Location Data for Material'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '4'.
  l_value-text = 'Units of Measure for Material'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_name = 'ONE'.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = l_name
      values          = li_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " f4_value_request_tabname
*&----------------------------------------------------------------*
*&      Form  f4_value_request_PB
*&----------------------------------------------------------------*
*       text
*-----------------------------------------------------------------*
*SUBROUTINE TO PROVIDE DROPDOWN VALUES TO LIST2
FORM f4_value_request_pb.
  DATA: l_name  TYPE vrm_id,
        li_list TYPE vrm_values,
        l_value LIKE LINE OF li_list.
  l_value-key = '1'.
  l_value-text = 'Sales Document: Header Data'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '2'.
  l_value-text = 'Sales Document: Item Data'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '3'.
  l_value-text = 'Sales Document:Header Status'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '4'.
  l_value-text = 'Sales Document: Item Status'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_name = 'TWO'.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = l_name
      values          = li_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " f4_value_request_PB
*&----------------------------------------------------------------*
*&      Form  f4_value_request_PC
*&----------------------------------------------------------------*
*       text
*-----------------------------------------------------------------*
*SUBROUTINE TO PROVIDE DROPDOWN VALUES TO LIST3
FORM f4_value_request_pc.
  DATA: l_name  TYPE vrm_id,
        li_list TYPE vrm_values,
        l_value LIKE LINE OF li_list.
  l_value-key = '1'.
  l_value-text = 'HR Master :Infotype 0001 (Org. Assignment)'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '2'.
  l_value-text = 'Address Infotype 0006'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '3'.
  l_value-text = 'Education Infotype 0022'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_value-key = '4'.
  l_value-text = 'Basic Pay Infotype 0008'.
  APPEND l_value TO li_list.
  CLEAR l_value.
  l_name = 'THREE'.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = l_name
      values          = li_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " f4_value_request_PC
*&----------------------------------------------------------------*
*&      Form  OUTPUT
*&----------------------------------------------------------------*
*       text
*-----------------------------------------------------------------*
*      -->P_TABLENAME  text
*-----------------------------------------------------------------*
*fINAL OUTPUT
FORM output.
  DATA p_table(10).
  p_table = tablename.
*popup to display teh selected table and
*Continue button is clicked
  CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
    EXPORTING
      titel        = 'User Selections '
      textline1    = p_table
      textline2    = 'is the Selected table'
      start_column = 25
      start_row    = 6.
*assigning the table value in p_table to the
* Table in SE16 transaction by explicitly calling
  SET PARAMETER ID 'DTB' FIELD p_table.
  CALL TRANSACTION 'SE16'.
ENDFORM.                    "OUTPUT
