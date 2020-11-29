*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.09.2019 at 16:58:11
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_SD_MT.......................................*
DATA:  BEGIN OF STATUS_ZOE_SD_MT                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_SD_MT                     .
CONTROLS: TCTRL_ZOE_SD_MT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_SD_MT                     .
TABLES: ZOE_SD_MT                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
