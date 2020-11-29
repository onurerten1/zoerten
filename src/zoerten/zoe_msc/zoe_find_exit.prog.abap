*&---------------------------------------------------------------------*
*& Report ZOE_FIND_EXIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_find_exit..
TABLES : tstc,     "SAP® Transaction Codes

         tadir,    "Directory of Repository Objects

         modsapt,  "SAP® Enhancements - Short Texts

         modact,   "Modifications

         trdir,    "System table TRDIR

         tfdir,    "Function Module

         enlfdir,  "Additional Attributes for Function Modules

         tstct.    "Transaction Code Texts



*&---------------------------------------------------------------------*

*& Variables

*&---------------------------------------------------------------------*



DATA : jtab LIKE tadir OCCURS 0 WITH HEADER LINE.

DATA : field1(30).

DATA : v_devclass LIKE tadir-devclass.



*&---------------------------------------------------------------------*

*& Selection Screen Parameters

*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a01 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN SKIP.

PARAMETERS : p_tcode LIKE tstc-tcode OBLIGATORY.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK a01.



*&---------------------------------------------------------------------*

*& Start of main program

*&---------------------------------------------------------------------*



START-OF-SELECTION.



* Validate Transaction Code

  SELECT SINGLE * FROM tstc

    WHERE tcode EQ p_tcode.



* Find Repository Objects for transaction code

  IF sy-subrc EQ 0.

    SELECT SINGLE * FROM tadir

       WHERE pgmid    = 'R3TR'

         AND object   = 'PROG'

         AND obj_name = tstc-pgmna.



    MOVE : tadir-devclass TO v_devclass.



    IF sy-subrc NE 0.

      SELECT SINGLE * FROM trdir

         WHERE name = tstc-pgmna.



      IF trdir-subc EQ 'F'.



        SELECT SINGLE * FROM tfdir

          WHERE pname = tstc-pgmna.



        SELECT SINGLE * FROM enlfdir

          WHERE funcname = tfdir-funcname.



        SELECT SINGLE * FROM tadir

          WHERE pgmid    = 'R3TR'

            AND object   = 'FUGR'

            AND obj_name = enlfdir-area.



        MOVE : tadir-devclass TO v_devclass.

      ENDIF.

    ENDIF.



* Find SAP® Modifications

    SELECT * FROM tadir

      INTO TABLE jtab

      WHERE pgmid    = 'R3TR'

        AND object   = 'SMOD'

        AND devclass = v_devclass.



    SELECT SINGLE * FROM tstct

      WHERE sprsl EQ sy-langu

        AND tcode EQ p_tcode.



    FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.

    WRITE:/(19) 'Transaction Code - ',

    20(20) p_tcode,

    45(50) tstct-ttext.

    SKIP.

    IF NOT jtab[] IS INITIAL.

      WRITE:/(95) sy-uline.

      FORMAT COLOR COL_HEADING INTENSIFIED ON.

      WRITE:/1 sy-vline,

      2 'Exit Name',

      21 sy-vline ,

      22 'Description',

      95 sy-vline.

      WRITE:/(95) sy-uline.



      LOOP AT jtab.

        SELECT SINGLE * FROM modsapt

        WHERE sprsl = sy-langu AND

        name = jtab-obj_name.

        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

        WRITE:/1 sy-vline,

        2 jtab-obj_name HOTSPOT ON,

        21 sy-vline ,

        22 modsapt-modtext,

        95 sy-vline.

      ENDLOOP.



      WRITE:/(95) sy-uline.

      DESCRIBE TABLE jtab.

      SKIP.

      FORMAT COLOR COL_TOTAL INTENSIFIED ON.

      WRITE:/ 'No of Exits:' , sy-tfill.

    ELSE.

      FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.

      WRITE:/(95) 'No User Exit exists'.

    ENDIF.

  ELSE.

    FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.

    WRITE:/(95) 'Transaction Code Does Not Exist'.

  ENDIF.



* Take the user to SMOD for the Exit that was selected.

AT LINE-SELECTION.

  GET CURSOR FIELD field1.

  CHECK field1(4) EQ 'JTAB'.

  SET PARAMETER ID 'MON' FIELD sy-lisel+1(10).

  CALL TRANSACTION 'SMOD' AND SKIP FIRST SCREEN.
