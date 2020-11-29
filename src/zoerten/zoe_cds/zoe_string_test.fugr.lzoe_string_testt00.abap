*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.09.2020 at 11:17:56
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_STRING_TEST.................................*
DATA:  BEGIN OF STATUS_ZOE_STRING_TEST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_STRING_TEST               .
CONTROLS: TCTRL_ZOE_STRING_TEST
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_STRING_TEST               .
TABLES: ZOE_STRING_TEST                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
