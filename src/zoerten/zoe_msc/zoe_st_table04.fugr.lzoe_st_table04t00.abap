*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 09.12.2019 at 16:44:47
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_ST_TABLE04..................................*
DATA:  BEGIN OF STATUS_ZOE_ST_TABLE04                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_ST_TABLE04                .
CONTROLS: TCTRL_ZOE_ST_TABLE04
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_ST_TABLE04                .
TABLES: ZOE_ST_TABLE04                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
