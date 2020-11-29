*&---------------------------------------------------------------------*
*& Report ZOE_GRAPH_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_graph_display.
DATA: BEGIN OF tab OCCURS 5,
        class(5) TYPE c,
        val1(2)  TYPE i,
        val2(2)  TYPE i,
        val3(2)  TYPE i,
      END OF tab.
DATA: BEGIN OF opttab OCCURS 1,
        c(20),
      END OF opttab.
MOVE: 'fan' TO tab-class,
      12 TO tab-val1, 8 TO tab-val2, 15 TO tab-val3.
APPEND tab.
CLEAR tab.
MOVE: 'cool' TO tab-class,
      15 TO tab-val1, 10 TO tab-val2, 18 TO tab-val3.
APPEND tab.
CLEAR tab.
MOVE: 'DA' TO tab-class,
      17 TO tab-val1, 11 TO tab-val2, 20 TO tab-val3.
APPEND tab.
CLEAR tab.
opttab = 'FIFRST = 3D'.     APPEND opttab.      "// Grafik-Typ
opttab = 'P3TYPE = TO'.     APPEND opttab.      "// Objektart
opttab = 'P3CTYP = RO'.     APPEND opttab.      "// Farben der Objekte
opttab = 'TISIZE = 2'.      APPEND opttab.      "// Haupttitelgröße
opttab = 'CLBACK = X'.      APPEND opttab.      "// Background Color
CALL FUNCTION 'GRAPH_MATRIX_3D'
  EXPORTING
    col1   = '1997'
    col2   = '1998'
    col3   = '1999'
    dim2   = 'Products'
    dim1   = 'Years'
    titl   = 'Sales In Rs. Crores'
  TABLES
    data   = tab
    opts   = opttab
  EXCEPTIONS
    OTHERS = 1.
LEAVE PROGRAM.
