*&---------------------------------------------------------------------*
*& Report ZOE_F4HELP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_f4help.

PARAMETERS: p_bukrs TYPE tvko-bukrs,
            p_vkorg TYPE tvko-vkorg.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vkorg.

  DATA: lt_dynpfields TYPE STANDARD TABLE OF dynpread,
        ls_dynpfields TYPE dynpread.

  ls_dynpfields-fieldname = 'P_BUKRS'.
  APPEND ls_dynpfields TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
*     TRANSLATE_TO_UPPER   = ' '
*     REQUEST              = ' '
*     PERFORM_CONVERSION_EXITS             = ' '
*     PERFORM_INPUT_CONVERSION             = ' '
*     DETERMINE_LOOP_INDEX = ' '
*     START_SEARCH_IN_CURRENT_SCREEN       = ' '
*     START_SEARCH_IN_MAIN_SCREEN          = ' '
*     START_SEARCH_IN_STACKED_SCREEN       = ' '
*     START_SEARCH_ON_SCR_STACKPOS         = ' '
*     SEARCH_OWN_SUBSCREENS_FIRST          = ' '
*     SEARCHPATH_OF_SUBSCREEN_AREAS        = ' '
    TABLES
      dynpfields           = lt_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR: ls_dynpfields.
  READ TABLE lt_dynpfields INTO ls_dynpfields WITH KEY fieldname = 'P_BUKRS'.
  IF sy-subrc = 0.
    p_bukrs = ls_dynpfields-fieldvalue.
  ENDIF.


  SELECT t~vkorg,
         x~vtext
    FROM tvko AS t
    LEFT OUTER JOIN tvkot AS x
    ON t~vkorg EQ x~vkorg
    WHERE t~bukrs EQ @p_bukrs
    AND   x~spras EQ @sy-langu
    INTO TABLE @DATA(lt_vkorg).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'P_VKORG'
*     PVALKEY         = ' '
*     DYNPPROG        = ' '
*     DYNPNR          = ' '
*     DYNPROFIELD     = ' '
*     STEPL           = 0
*     WINDOW_TITLE    =
*     VALUE           = ' '
      value_org       = 'S'
*     MULTIPLE_CHOICE = ' '
*     DISPLAY         = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM   = ' '
*     CALLBACK_METHOD =
*     MARK_TAB        =
*     IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = lt_vkorg
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
