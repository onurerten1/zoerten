*&---------------------------------------------------------------------*
*& Report zoe_table_reference
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_table_reference.

CLASS animal DEFINITION ABSTRACT.
  PUBLIC SECTION.
    DATA: noise TYPE char10.
    METHODS make_noise.
ENDCLASS.

CLASS animal IMPLEMENTATION.
  METHOD make_noise.
  ENDMETHOD.
ENDCLASS.

CLASS dog DEFINITION INHERITING FROM animal.
  PUBLIC SECTION.
    DATA: play TYPE char10.
    METHODS make_noise REDEFINITION.
ENDCLASS.

CLASS dog IMPLEMENTATION.
  METHOD make_noise.
    noise = 'Bark'.
    play = 'Wag Tail'.
    WRITE : / noise, play.
    SKIP.
  ENDMETHOD.
ENDCLASS.

CLASS cat DEFINITION INHERITING FROM animal.
  PUBLIC SECTION.
    METHODS make_noise REDEFINITION.
ENDCLASS.

CLASS cat IMPLEMENTATION.
  METHOD make_noise.
    noise = 'Meow'.
    WRITE : / noise.
    SKIP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA : ref_animal TYPE TABLE OF REF TO animal,
         ref_dog    TYPE REF TO dog,
         ref_cat    TYPE REF TO cat.

  FIELD-SYMBOLS <fs_animal> LIKE LINE OF ref_animal.
  DATA wa_animal LIKE LINE OF ref_animal.

  CREATE OBJECT ref_dog.
  CREATE OBJECT ref_cat.

  wa_animal = ref_dog.
  APPEND wa_animal TO ref_animal.

  wa_animal = ref_cat.
  APPEND wa_animal TO ref_animal.

  wa_animal = ref_dog.
  APPEND wa_animal TO ref_animal.

  LOOP AT ref_animal
    ASSIGNING <fs_animal>.
    CALL METHOD <fs_animal>->make_noise.
  ENDLOOP.
