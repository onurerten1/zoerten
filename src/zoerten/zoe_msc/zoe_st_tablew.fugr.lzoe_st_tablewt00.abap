*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 09.12.2019 at 15:53:43
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_ST_TABLE....................................*
DATA:  BEGIN OF STATUS_ZOE_ST_TABLE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_ST_TABLE                  .
CONTROLS: TCTRL_ZOE_ST_TABLE
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZOE_ST_TABLE                  .
TABLES: ZOE_ST_TABLE                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
