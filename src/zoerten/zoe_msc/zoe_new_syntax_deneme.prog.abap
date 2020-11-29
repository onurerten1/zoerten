*&---------------------------------------------------------------------*
*& Report ZOE_NEW_SYNTAX_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_new_syntax_deneme.


DATA(lv_text) = 'Declare Variable'.
DATA(lv_conut) = 1000.
*BREAK-POINT.
DATA lt_matnr TYPE STANDARD TABLE OF matnr.
lt_matnr = VALUE #( ( 'a' ) ( 'b' ) ( 'c' ) ( 'd' ) ( 'e' ) ).
*BREAK-POINT.
TYPES: t_matnr TYPE STANDARD TABLE OF matnr WITH DEFAULT KEY.
DATA(lt_data) = VALUE t_matnr( ( 'a' ) ( 'b' ) ( 'c' ) ( 'd' ) ( 'e' ) ).
*BREAK-POINT.
LOOP AT lt_matnr INTO DATA(ls_matnr).

ENDLOOP.
LOOP AT lt_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
  DATA(lv_matnr) = <fs_matnr>.
ENDLOOP.
READ TABLE lt_matnr ASSIGNING FIELD-SYMBOL(<ls_matnr>) INDEX 3.
IF sy-subrc EQ 0.

ENDIF.
TYPES: ty_tab TYPE RANGE OF mara-matnr.
DATA(gt_tab) = VALUE ty_tab( sign = 'I' option = 'BT' ( low = 1  high = 10 )
                                                      ( low = 21 high = 30 )
                                                      ( low = 41 high = 50 )
                                        option = 'GE' ( low = 61 ) ).
*BREAK-POINT.
DATA lt_bukrs TYPE RANGE OF bukrs.
lt_bukrs = VALUE #( sign = 'I' option = 'EQ'
                    ( low = '0001' )
                    ( low = '1000' )
                    ( low = '2000' ) ).
*BREAK-POINT.
DATA(ls_bukrs) = lt_bukrs[ low = '1000' ].

IF line_exists( lt_bukrs[ low = '3333' ] ).
  DATA(lv_text2) = 'NO'.
ENDIF.
*BREAK-POINT.
TYPES: BEGIN OF t_year,
         year TYPE numc4,
       END OF t_year,
       tt_year TYPE TABLE OF t_year WITH EMPTY KEY.

DATA(lt_years) = VALUE tt_year( FOR i = 2000 THEN i + 1 UNTIL i > 2020 ( year = i ) ).
LOOP AT lt_years  ASSIGNING FIELD-SYMBOL(<ls_year>).
*WRITE / <ls_year>-year.
ENDLOOP.

DATA(lv_status) = 'S'.
DATA(lv_status2) = 'C'.
DATA(lv_status_text) = COND string( WHEN lv_status = 'A' OR lv_status2 = 'C' THEN 'Aborted'
                                    WHEN lv_status = 'S' THEN 'Success'
                                    WHEN lv_status = 'F' THEN 'Failed'
                                    ELSE 'Status not found' ).
*BREAK-POINT.

DATA(lv_status_text2) = SWITCH string( lv_status WHEN 'A' THEN 'Aborted'
                                                 WHEN 'S' THEN 'Success'
                                                 WHEN 'F' THEN 'Failed'
                                                 ELSE 'Status not found' ).
*BREAK-POINT.

DATA(lv_time_string) = | Date: { sy-datum } / { sy-uzeit } Status: { lv_status_text } | && | test |.
*BREAK-POINT.

DATA: lv_ebeln TYPE ebeln VALUE '490001'.
DATA(lv_purc_no) = |{ lv_ebeln ALPHA = IN }|.
*BREAK-POINT.

LOOP AT lt_bukrs ASSIGNING FIELD-SYMBOL(<fs>).
  <fs>-low = 'asjşasf'.
ENDLOOP.

DATA: lv_decimal TYPE p DECIMALS 10 VALUE '123.456789'.
DATA(lv_money) = |{ lv_decimal DECIMALS = 2 }|.
*BREAK-POINT.

TYPES: BEGIN OF ty_line,
         col1 TYPE i,
         col2 TYPE i,
         col3 TYPE i,
       END OF ty_line,
       ty_tab2 TYPE STANDARD TABLE OF ty_line WITH EMPTY KEY.

DATA: gt_itab TYPE ty_tab2,
      j       TYPE i.
FIELD-SYMBOLS: <ls_tab> TYPE ty_line.
j = 1.
DO.
  j = j + 10.
  IF j > 40.
    EXIT.
  ENDIF.
  APPEND INITIAL LINE TO gt_itab ASSIGNING <ls_tab>.
  <ls_tab>-col1 = j.
  <ls_tab>-col2 = j + 1.
  <ls_tab>-col3 = j + 2.
ENDDO.

TYPES: BEGIN OF ty_employee,
         name TYPE char30,
         role TYPE char30,
         age  TYPE i,
       END OF ty_employee,
       ty_employee_t TYPE STANDARD TABLE OF ty_employee WITH KEY name.

DATA(gt_employee) = VALUE ty_employee_t(
( name = 'John'     role = 'ABAP Guru'       age = 34 )
( name = 'Alice'    role = 'FI Consultant'   age = 42 )
( name = 'Barry'    role = 'ABAP guru'       age = 54 )
( name = 'Mary'     role = 'FI Consultant'   age = 37 )
( name = 'Arthur'   role = 'ABAP guru'       age = 34 )
( name = 'Mandy'    role = 'SD Consultant'   age = 64 ) ).

DATA: gv_tot_age TYPE i,
      gv_avg_age TYPE decfloat34.

LOOP AT gt_employee INTO DATA(ls_employee)
GROUP BY ( role   = ls_employee-role
           size   = GROUP SIZE
           index  = GROUP INDEX )
ASCENDING
ASSIGNING FIELD-SYMBOL(<group>).
  CLEAR: gv_tot_age.
  WRITE:/ |Group: { <group>-index } Role: { <group>-role WIDTH = 15 }|
       && |   Number in this role: { <group>-size }|.

  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<ls_member>).
    gv_tot_age = gv_tot_age + <ls_member>-age.
    WRITE:/16 <ls_member>-name.
  ENDLOOP.
  gv_avg_age = gv_tot_age / <group>-size.
  WRITE:/ |Average age: { gv_avg_age }|.
  SKIP.
ENDLOOP.

TYPES: BEGIN OF ty_ship,
         tknum TYPE tknum,
         name  TYPE ernam,
         city  TYPE ort01,
         route TYPE route,
       END OF ty_ship.
TYPES: ty_ships  TYPE STANDARD TABLE OF ty_ship WITH EMPTY KEY,
       ty_cities TYPE STANDARD TABLE OF ort01 WITH EMPTY KEY.

DATA: gt_ships TYPE ty_ships.

DATA: gt_cities TYPE ty_cities,
      gs_ship   TYPE ty_ship,
      gs_city   TYPE ort01.

gt_ships = VALUE #(
                  ( tknum = 'deneme'  name = 'deneme2'   city = 'deneme3'  route = 'deneme4' )
                  ( tknum = 'deneme2' name = 'deneme2'  city = 'deneme3'  route = 'deneme4' )
                  ).

LOOP AT gt_ships INTO gs_ship.
  gs_city =  gs_ship-city.
  APPEND gs_city TO gt_cities.
ENDLOOP.

DATA(gt_cities1) = VALUE ty_cities( FOR ls_ship IN gt_ships ( ls_ship-city ) ).
*BREAK-POINT.

TYPES: BEGIN OF ty_line2,
         col1 TYPE i,
         col2 TYPE i,
         col3 TYPE i,
       END OF ty_line2,
       ty_tab3 TYPE STANDARD TABLE OF ty_line WITH EMPTY KEY.

DATA(gt_itab1) = VALUE ty_tab3( FOR a = 11 THEN a + 10 UNTIL a > 40
                              ( col1 = a col2 = a + 1 col3 = a + 2 ) ).
*BREAK-POINT.

TYPES: BEGIN OF ty_itab,
         col1(3),
         col2(3),
       END OF ty_itab,
       tt_itab TYPE STANDARD TABLE OF ty_itab WITH EMPTY KEY.

DATA(gt_itab2) = VALUE tt_itab( ( col1 = 'xyz' col2 = '10' )
                                ( col1 = 'xyz' col2 = '40' ) ).

DATA(lv_lines) = REDUCE i( INIT x = 0 FOR wa IN gt_itab2 WHERE ( col1 = 'xyz' ) NEXT x = x + wa-col2 ).
*BREAK-POINT.

DATA dref TYPE REF TO data.
dref = NEW i( 555 ).

DATA atab TYPE TABLE OF i.
atab = VALUE #( ( 1 ) ( 2 ) ( 3 ) ).
atab = VALUE #( ( 4 ) ( 5 ) ( 6 ) ).


TYPES:
  BEGIN OF ty_data,
    kunnr TYPE kunnr,
    name1 TYPE name1,
    ort01 TYPE ort01,
    land1 TYPE land1,
  END   OF ty_data.
TYPES: tt_data TYPE STANDARD TABLE OF ty_data
                                       WITH DEFAULT KEY.

DATA(itab_multi_comp) =
  VALUE tt_data( ( kunnr = '123' name1 = 'ABCD' ort01 = 'LV' land1 = 'NV' )
                 ( kunnr = '456' name1 = 'XYZ'  ort01 = 'LA' land1 = 'CA' )
              ).

DATA(ls_str) = itab_multi_comp[ kunnr = '123' ]-ort01.
WRITE: / ls_str.

itab_multi_comp[ kunnr = '456' ort01 = 'LA' ]-kunnr = '987'.

TYPES:
  BEGIN OF ty_alv_data,
    kunnr   TYPE kunnr,
    name1   TYPE name1,
    ort01   TYPE ort01,
    land1   TYPE land1,
    t_color TYPE lvc_t_scol,
  END   OF ty_alv_data.

TYPES: tt_alv_data TYPE STANDARD TABLE OF ty_alv_data
                                        WITH DEFAULT KEY.

DATA(itab_alv) =
  VALUE tt_alv_data(
                    "1.satır
                    ( kunnr = '123' name1 = 'ABCD'
                      ort01 = 'LV' land1 = 'NV'
                        " renk tablosu (deep table)
                        t_color = VALUE #(
                                          " renk tablosu satır 1
                                           ( fname = 'KUNNR'
                                             color-col = col_negative
                                             color-int = 0
                                             color-inv = 0
                                            )
                                          " renk tablosu satır 2
                                           ( fname = 'ORT01'
                                             color-col = col_total
                                             color-int = 1
                                             color-inv = 1
                                            )
                                          )
                    )
                    " 2. satır
                          ( kunnr = '123' name1 = 'test2'
                            ort01 = 'test2' land1 = 'test2'
                        " renk tablosu (deep table)
                        t_color = VALUE #(
                                          " renk tablosu satır 1
                                           ( fname = 'KUNNR'
                                             color-col = col_negative
                                             color-int = 0
                                             color-inv = 0
                                            )
                                          " renk tablosu satır 2
                                           ( fname = 'ORT01'
                                             color-col = col_total
                                             color-int = 1
                                             color-inv = 1
                                            )
                                          )
                    )
                 ).
"KUNNR =123 olan satırın renk tablosundaki fname = ort01 olan satırın
"color structureındaki col alanının güncellenmesi

* OLD
FIELD-SYMBOLS: <fs_data> LIKE LINE OF itab_alv,
               <fs_col>  LIKE LINE OF <fs_data>-t_color.
READ TABLE itab_alv ASSIGNING <fs_data> WITH KEY kunnr = '123'.
IF sy-subrc EQ 0.
  READ TABLE <fs_data>-t_color ASSIGNING <fs_col> WITH KEY fname = 'ORT01'.
  IF sy-subrc EQ 0.
    <fs_col>-color-col = col_group.
    <fs_col>-color-int = 0.
    <fs_col>-color-inv = 1.
  ENDIF.
ENDIF.

* NEW

itab_alv[ kunnr = '123' ]-t_color[ fname = 'ORT01' ]-color-col = col_background.


SELECT SINGLE ( but000~name_org1 && ' ' && but000~name_org2 && ' ' &&
                but000~name_org3 ) AS name,
        ( adrc~street        && ' ' &&
          adrc~str_suppl3    && ' ' &&
          adrc~location      && ' ' &&
          adrc~city2         && ' ' &&
          adrc~home_city     && ' ' &&
          adrc~post_code1 )  AS adres ,
          adrc~city1,
          adrc~langu,
          t005t~landx
        FROM likp
        LEFT JOIN but000 ON likp~kunnr EQ but000~partner
        LEFT JOIN but020 ON likp~kunnr EQ but020~partner
        LEFT JOIN adrc   ON but020~addrnumber EQ adrc~addrnumber
        LEFT JOIN t005t  ON adrc~country EQ t005t~land1
        INTO @DATA(ls_alan)
        WHERE likp~vbeln EQ '0080000025'
          AND t005t~spras EQ 'T'.



BREAK-POINT.
