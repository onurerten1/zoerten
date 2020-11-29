*&---------------------------------------------------------------------*
*& Report ZOE_STATISTICAL_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_statistical_display.

*Structure Declarations
DATA: BEGIN OF graf_par,
        dmode          VALUE '1',
        einheittext(6),
        gridtype       VALUE '2',
        title          LIKE sy-title,
        ttext          LIKE strucr-kurztext,
        tunit          VALUE '6',
        utext          LIKE sy-title,
        valt(10),
        winpos(1)      TYPE n VALUE  5,
        winszx(2)      TYPE n VALUE 85,
        winszy(2)      TYPE n VALUE 75,
      END OF graf_par,

*Internal Table Declaration
      BEGIN OF grafdata OCCURS 0,
        f TYPE i,
      END OF grafdata,

      BEGIN OF grafopts OCCURS 0,
        t(40),
      END OF grafopts,

      BEGIN OF graftime OCCURS 0,
        tick TYPE d,
      END OF graftime.

*Start of selection*
START-OF-SELECTION.
* Append values to the Internal table for Title, Color, Text and Thickness
  graf_par-title = 'Statistical Report'.
  graf_par-ttext = 'Statistical Report'.
  REFRESH grafopts.
  grafopts-t = '$'.
  APPEND grafopts.
  grafopts-t = 'COLOR='.
  REPLACE space WITH '4' INTO  grafopts-t.
  APPEND grafopts.
  grafopts-t = 'THICK=3'.
  APPEND grafopts.
  grafopts-t = 'LTEXT='.
  REPLACE space WITH 'Actual Cost' INTO grafopts-t.
  APPEND grafopts.
  grafopts-t = 'C_ART=0'.
  APPEND grafopts.  "Stützstellen

  grafopts-t = '$'.
  APPEND grafopts.
  grafopts-t = 'COLOR='.
  REPLACE space WITH '5' INTO  grafopts-t.
  APPEND grafopts.
  grafopts-t = 'THICK=3'.
  APPEND grafopts.
  grafopts-t = 'LTEXT='.
  REPLACE space WITH 'Planned Cost' INTO grafopts-t.
  APPEND grafopts.
  grafopts-t = 'C_ART=0'.
  APPEND grafopts.

*Append Date Values to the GRAFTIME Internal Table for X-axis.
  graftime-tick = '20121201'.
  APPEND graftime.
  graftime-tick = '20130101'.
  APPEND graftime.
  graftime-tick = '20130201'.
  APPEND graftime.
  graftime-tick = '20130301'.
  APPEND graftime.
  graftime-tick = '20130401'.
  APPEND graftime.
  graftime-tick = '20130501'.
  APPEND graftime.
  graftime-tick = '20130601'.
  APPEND graftime.
  graftime-tick = '20130701'.
  APPEND graftime.
  graftime-tick = '20130801'.
  APPEND graftime.
  graftime-tick = '20130901'.
  APPEND graftime.
  graftime-tick = '20131001'.
  APPEND graftime.
  graftime-tick = '20131101'.
  APPEND graftime.
  graftime-tick = '20131201'.
  APPEND graftime.

* Append data to the GRAFDATA Internal table for Y-Axis
  grafdata-f = 0.
  APPEND grafdata.
  grafdata-f = 9.
  APPEND grafdata.
  grafdata-f = 18.
  APPEND grafdata.
  grafdata-f = 21.
  APPEND grafdata.
  grafdata-f = 24.
  APPEND grafdata.
  grafdata-f = 29.
  APPEND grafdata.
  grafdata-f = 38.
  APPEND grafdata.
  grafdata-f = 42.
  APPEND grafdata.
  grafdata-f = 29.
  APPEND grafdata.
  grafdata-f = 40.
  APPEND grafdata.
  grafdata-f = 39.
  APPEND grafdata.
  grafdata-f = 32.
  APPEND grafdata.
  grafdata-f = 38.
  APPEND grafdata.

  grafdata-f = 0.
  APPEND grafdata.
  grafdata-f = 5.
  APPEND grafdata.
  grafdata-f = 12.
  APPEND grafdata.
  grafdata-f = 15.
  APPEND grafdata.
  grafdata-f = 19.
  APPEND grafdata.
  grafdata-f = 25.
  APPEND grafdata.
  grafdata-f = 32.
  APPEND grafdata.
  grafdata-f = 36.
  APPEND grafdata.
  grafdata-f = 24.
  APPEND grafdata.
  grafdata-f = 40.
  APPEND grafdata.
  grafdata-f = 38.
  APPEND grafdata.
  grafdata-f = 30.
  APPEND grafdata.
  grafdata-f = 35.
  APPEND grafdata.

*Call STAT_GRAPH_REF FM for Statistical display
  CALL FUNCTION 'STAT_GRAPH_REF'
    EXPORTING
      dmode      = graf_par-dmode
      gridtype   = graf_par-gridtype
      mail_allow = 'X'
      title      = graf_par-title
      ttext      = graf_par-ttext
      tunit      = graf_par-tunit
      utext      = graf_par-utext
      valt       = graf_par-valt
      winpos     = graf_par-winpos
      winszx     = graf_par-winszx
      winszy     = graf_par-winszy
    TABLES
      data       = grafdata
      opts       = grafopts
      vals       = graftime.
