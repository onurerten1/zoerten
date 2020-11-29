*&---------------------------------------------------------------------*
*& Include          ZOE_ADD_FAV_TCODE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_TCODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_tcode .

  DATA : it_return LIKE ddshretval OCCURS 0 WITH HEADER LINE.

  SELECT ttext,
         tcode
        FROM tstct
        WHERE sprsl EQ @sy-langu AND
              tcode LIKE 'Z%'
        INTO TABLE @DATA(lt_tcode).

  SORT lt_tcode BY tcode ASCENDING.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'P_TCODE'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tcode
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  p_tcode = it_return-fieldval.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_HELP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_help .

  CALL FUNCTION 'DSYS_SHOW_FOR_F1HELP'
    EXPORTING
*     APPLICATION      = 'SO70'
      dokclass         = 'TX'
      doklangu         = sy-langu
      dokname          = 'ZOE_DEMO_TEXT'
*     DOKTITLE         = ' '
*     HOMETEXT         = ' '
*     OUTLINE          = ' '
*     VIEWNAME         = 'STANDARD'
*     Z_ORIGINAL_OUTLINE       = ' '
*     CALLED_FROM_SO70 = ' '
*     SHORT_TEXT       = ' '
*     APPENDIX         = ' '
*   IMPORTING
*     APPL             =
*     PF03             =
*     PF15             =
*     PF12             =
    EXCEPTIONS
      class_unknown    = 1
      object_not_found = 2
      OTHERS           = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
