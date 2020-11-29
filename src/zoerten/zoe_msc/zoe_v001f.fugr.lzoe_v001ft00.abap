*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 10.04.2020 at 15:36:26
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_V001........................................*
TABLES: ZOE_V001, *ZOE_V001. "view work areas
CONTROLS: TCTRL_ZOE_V001
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZOE_V001. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOE_V001.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOE_V001_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOE_V001.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V001_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOE_V001_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOE_V001.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V001_TOTAL.

*...processing: ZOE_V002........................................*
TABLES: ZOE_V002, *ZOE_V002. "view work areas
CONTROLS: TCTRL_ZOE_V002
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZOE_V002. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOE_V002.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOE_V002_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOE_V002.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V002_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOE_V002_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOE_V002.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V002_TOTAL.

*.........table declarations:.................................*
TABLES: ZOE_T001                       .
TABLES: ZOE_T002                       .
