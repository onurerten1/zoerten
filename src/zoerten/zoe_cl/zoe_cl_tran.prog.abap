*&---------------------------------------------------------------------*
*& Report ZOE_CL_TRAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cl_tran.

CLASS create_report DEFINITION.
  PUBLIC SECTION.
    METHODS: main.
  PRIVATE SECTION.
    DATA: i_data TYPE STANDARD TABLE OF sbook INITIAL SIZE 0.
    METHODS: fetch_data,
      display_data.
ENDCLASS.
CLASS create_report IMPLEMENTATION.
  METHOD fetch_data.

    SELECT *
      FROM sbook
      INTO TABLE @i_data
      UP TO 100 ROWS.

  ENDMETHOD.
  METHOD display_data.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK                 = ' '
*       I_BYPASSING_BUFFER                = ' '
*       I_BUFFER_ACTIVE  = ' '
*       I_CALLBACK_PROGRAM                = ' '
*       I_CALLBACK_PF_STATUS_SET          = ' '
*       I_CALLBACK_USER_COMMAND           = ' '
*       I_CALLBACK_TOP_OF_PAGE            = ' '
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
        i_structure_name = 'SBOOK'
*       I_BACKGROUND_ID  = ' '
*       I_GRID_TITLE     =
*       I_GRID_SETTINGS  =
*       IS_LAYOUT        =
*       IT_FIELDCAT      =
*       IT_EXCLUDING     =
*       IT_SPECIAL_GROUPS                 =
*       IT_SORT          =
*       IT_FILTER        =
*       IS_SEL_HIDE      =
*       I_DEFAULT        = 'X'
*       I_SAVE           = ' '
*       IS_VARIANT       =
*       IT_EVENTS        =
*       IT_EVENT_EXIT    =
*       IS_PRINT         =
*       IS_REPREP_ID     =
*       I_SCREEN_START_COLUMN             = 0
*       I_SCREEN_START_LINE               = 0
*       I_SCREEN_END_COLUMN               = 0
*       I_SCREEN_END_LINE                 = 0
*       I_HTML_HEIGHT_TOP                 = 0
*       I_HTML_HEIGHT_END                 = 0
*       IT_ALV_GRAPHICS  =
*       IT_HYPERLINK     =
*       IT_ADD_FIELDCAT  =
*       IT_EXCEPT_QINFO  =
*       IR_SALV_FULLSCREEN_ADAPTER        =
*       O_PREVIOUS_SRAL_HANDLER           =
*         IMPORTING
*       E_EXIT_CAUSED_BY_CALLER           =
*       ES_EXIT_CAUSED_BY_USER            =
      TABLES
        t_outtab         = i_data
      EXCEPTIONS
        program_error    = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDMETHOD.
  METHOD main.
    fetch_data( ).
    display_data( ).
  ENDMETHOD.
ENDCLASS.
