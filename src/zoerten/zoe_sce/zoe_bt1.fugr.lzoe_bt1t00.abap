*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 12.09.2019 at 17:26:07
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_BT1.........................................*
DATA:  BEGIN OF STATUS_ZOE_BT1                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_BT1                       .
CONTROLS: TCTRL_ZOE_BT1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_BT1                       .
TABLES: ZOE_BT1                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
