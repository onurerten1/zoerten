*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 14.04.2020 at 12:05:00
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_SEN_MAIL_BKM................................*
DATA:  BEGIN OF STATUS_ZOE_SEN_MAIL_BKM              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_SEN_MAIL_BKM              .
CONTROLS: TCTRL_ZOE_SEN_MAIL_BKM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_SEN_MAIL_BKM              .
TABLES: ZOE_SEN_MAIL_BKM               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
