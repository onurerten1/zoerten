*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.11.2019 at 17:27:29
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_COLOR.......................................*
DATA:  BEGIN OF STATUS_ZOE_COLOR                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_COLOR                     .
CONTROLS: TCTRL_ZOE_COLOR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_COLOR                     .
TABLES: ZOE_COLOR                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
