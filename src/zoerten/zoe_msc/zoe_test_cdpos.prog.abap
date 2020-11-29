*&---------------------------------------------------------------------*
*& Report ZOE_TEST_CDPOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_test_cdpos.

TABLES: cdpos, cdhdr.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME.
SELECT-OPTIONS: s_fname FOR cdpos-fname,
                s_objid FOR cdpos-objectid,
                s_udate FOR cdhdr-udate,
                s_uname FOR cdhdr-username.
SELECTION-SCREEN END OF BLOCK blk1.

START-OF-SELECTION.

*  SELECT p~changedocobject AS objectid,
*         p~changedocobjectclass AS objectclas,
*         p~changedocument AS changenr,
*         p~databasetable AS tabname,
*         p~changedocdatabasetablefield AS fname,
**         h~createdbyuser AS username,
**         h~creationdate AS udate,
*         p~changedocnewfieldvalue AS value_new,
*         p~changedocpreviousfieldvalue AS value_old
*    FROM ichangedocitem AS p
**    INNER JOIN ichangedoc AS h ON p~changedocobject      = h~changedocobject
**    AND                           p~changedocobjectclass = h~changedocobjectclass
**    AND                           p~changedocument       = h~changedocument
*    WHERE p~changedocobject IN @s_objid
*    AND   p~changedocobjectclass = `KRED`
*    AND   p~databasetable IN ( `LFA1`, `LFB1`, `LFM1` )
**    AND   p~changedocdatabasetablefield IN @s_fname
*      AND   p~changedocdatabasetablefield = '0000010416'
**    AND   h~createdbyuser IN @s_uname
**    AND   h~creationdate IN @s_udate
*    INTO TABLE @DATA(lt_data).

  SELECT p~objectid,
             p~objectclas,
             p~changenr,
             p~tabname,
             p~fname,
             h~username,
             h~udate,
             p~value_new,
             p~value_old
        FROM cdpos AS p
        INNER JOIN cdhdr AS h ON p~objectid   = h~objectid
        AND                      p~objectclas = h~objectclas
        AND                      p~changenr   = h~changenr
        WHERE h~objectid IN @s_objid
        AND   h~objectclas = `KRED`
        AND   p~tabname IN ( `LFA1`, `LFB1`, `LFM1` )
        AND   p~fname IN @s_fname
        AND   h~username IN @s_uname
        AND   h~udate IN @s_udate
    INTO TABLE @DATA(lt_data).

  BREAK-POINT.
