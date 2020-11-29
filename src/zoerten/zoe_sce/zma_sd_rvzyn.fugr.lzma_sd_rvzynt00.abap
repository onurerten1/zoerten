*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 24.10.2019 at 10:12:31
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZMA_SD_RVZYN....................................*
DATA:  BEGIN OF STATUS_ZMA_SD_RVZYN                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMA_SD_RVZYN                  .
CONTROLS: TCTRL_ZMA_SD_RVZYN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZMA_SD_RVZYN                  .
TABLES: ZMA_SD_RVZYN                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
