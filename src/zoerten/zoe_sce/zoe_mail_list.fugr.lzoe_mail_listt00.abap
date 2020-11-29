*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.04.2020 at 12:56:38
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_MAIL_LIST...................................*
DATA:  BEGIN OF STATUS_ZOE_MAIL_LIST                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOE_MAIL_LIST                 .
CONTROLS: TCTRL_ZOE_MAIL_LIST
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOE_MAIL_LIST                 .
TABLES: ZOE_MAIL_LIST                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
