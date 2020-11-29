*&---------------------------------------------------------------------*
*& Report ZOE_CLASS_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_class_08.
CLASS class_program DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: progtam_type ABSTRACT,
      approach1 ABSTRACT.
ENDCLASS.
CLASS class_procedural DEFINITION INHERITING FROM class_program.
  PUBLIC SECTION.
    METHODS: progtam_type REDEFINITION,
      approach1  REDEFINITION.
ENDCLASS.
CLASS class_procedural IMPLEMENTATION.
  METHOD progtam_type.
    WRITE: 'Procedural programming'.
  ENDMETHOD.
  METHOD approach1.
    WRITE: 'top-down approach'.
  ENDMETHOD.
ENDCLASS.
CLASS class_oo DEFINITION INHERITING FROM class_program.
  PUBLIC SECTION.
    METHODS: progtam_type REDEFINITION,
      approach1 REDEFINITION.
ENDCLASS.
CLASS class_oo IMPLEMENTATION.
  METHOD progtam_type.
    WRITE: 'Object Oriented Programming'.
  ENDMETHOD.
  METHOD approach1.
    WRITE: 'bottom-up approach'.
  ENDMETHOD.
ENDCLASS.
CLASS class_type_approach DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      start IMPORTING class1_program TYPE REF TO class_program.
ENDCLASS.
CLASS class_type_approach IMPLEMENTATION.
  METHOD start.
    CALL METHOD class1_program->progtam_type.
    WRITE: 'follows'.
    CALL METHOD class1_program->approach1.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: class_1 TYPE REF TO class_procedural,
        class_2 TYPE REF TO class_oo.

  CREATE OBJECT: class_1, class_2.
  CALL METHOD class_type_approach=>start
    EXPORTING
      class1_program = class_1.
  NEW-LINE.
  CALL METHOD class_type_approach=>start
    EXPORTING
      class1_program = class_2.
