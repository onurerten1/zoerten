*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 10.04.2020 at 15:41:41
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_V003........................................*
TABLES: ZOE_V003, *ZOE_V003. "view work areas
CONTROLS: TCTRL_ZOE_V003
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZOE_V003. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZOE_V003.
* Table for entries selected to show on screen
DATA: BEGIN OF ZOE_V003_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZOE_V003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V003_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZOE_V003_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZOE_V003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZOE_V003_TOTAL.

*.........table declarations:.................................*
TABLES: ZOE_T003                       .
