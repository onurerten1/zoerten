*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.03.2020 at 13:28:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_T001........................................*
DATA:  BEGIN OF STATUS_ZOE_T001                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_T001                      .
CONTROLS: TCTRL_ZOE_T001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_T001                      .
TABLES: ZOE_T001                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
