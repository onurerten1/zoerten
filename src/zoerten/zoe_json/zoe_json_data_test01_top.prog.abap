*&---------------------------------------------------------------------*
*& Include          ZOE_JSON_DATA_TEST01_TOP
*&---------------------------------------------------------------------*
************************************************************************
*CLASSES                                                               *
************************************************************************
CLASS lcl_handle_events DEFINITION DEFERRED.

************************************************************************
*TABLES                                                                *
************************************************************************


************************************************************************
* TYPE POOLS                                                           *
************************************************************************
TYPE-POOLS: icon, abap.

************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.

************************************************************************
*CONSTANTS                                                             *
************************************************************************
CONSTANTS: gc_icon_table TYPE icon_d VALUE icon_view_table,
           gc_icon_url   TYPE icon_d VALUE icon_url,
           gc_icon_jpg   TYPE icon_d VALUE icon_jpg,
           gc_unit_cm(2) VALUE `CM`,
           gc_unit_g     VALUE `G`.

CONSTANTS: gc_gen1 TYPE int4 VALUE 151,
           gc_gen2 TYPE int4 VALUE 100,
           gc_gen3 TYPE int4 VALUE 135,
           gc_gen4 TYPE int4 VALUE 107,
           gc_gen5 TYPE int4 VALUE 156,
           gc_gen6 TYPE int4 VALUE 72,
           gc_gen7 TYPE int4 VALUE 88,
           gc_alt  TYPE int4 VALUE 157.

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************

************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: go_table_top    TYPE REF TO cl_salv_table,
      go_table_left   TYPE REF TO cl_salv_table,
      go_table_middle TYPE REF TO cl_salv_table.

DATA: go_splitter         TYPE REF TO cl_gui_splitter_container.

DATA: go_container_top    TYPE REF TO cl_gui_custom_container,
      go_container_bottom TYPE REF TO cl_gui_custom_container.

DATA: go_container_left   TYPE REF TO cl_gui_container,
      go_container_middle TYPE REF TO cl_gui_container,
      go_container_right  TYPE REF TO cl_gui_container.

DATA: go_picture_viewer TYPE REF TO cl_gui_picture.

DATA: go_events_top    TYPE REF TO lcl_handle_events,
      go_events_left   TYPE REF TO lcl_handle_events,
      go_events_middle TYPE REF TO lcl_handle_events.

DATA: gv_position TYPE string VALUE `_TOP`,
      gv_table    TYPE string VALUE ``.

DATA: gv_held_item_row  TYPE salv_de_row,
      gv_game_index_row TYPE salv_de_row,
      gv_moves_row      TYPE salv_de_row.

DATA: gv_name          TYPE string.

DATA: gv_any_model_response TYPE string.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************
DATA: gs_tab    TYPE zoe_json_st_poke,
      gt_tab    LIKE TABLE OF gs_tab,
      gt_return TYPE  bapiret2_t.

DATA: BEGIN OF gs_data,
        id                       TYPE int4,
        name                     TYPE text40,
        base_experience          TYPE int4,
        height                   TYPE int4,
        meins_height             TYPE meins,
        is_default               TYPE xfeld,
        order                    TYPE int4,
        weight                   TYPE int4,
        meins_weight             TYPE meins,
        abilities	               TYPE	icon_d,
        forms	                   TYPE	icon_d,
        game_indices             TYPE icon_d,
        held_items               TYPE icon_d,
        location_area_encounters TYPE ad_uriscr,
        moves	                   TYPE	icon_d,
        species	                 TYPE	zoe_poke_st_species,
        sprites	                 TYPE	zoe_poke_st_sprites,
        stats                    TYPE icon_d,
        types                    TYPE icon_d,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.

DATA: BEGIN OF gs_data_abilities,
        url2      TYPE url,
        ability   TYPE zoe_poke_st_ability,
        is_hidden TYPE xfeld,
        slot      TYPE int4,
      END OF gs_data_abilities,
      gt_data_abilities LIKE TABLE OF gs_data_abilities.

DATA: BEGIN OF gs_data_forms,
        url2  TYPE url.
        INCLUDE STRUCTURE zoe_poke_st_forms.
        DATA dummy TYPE i.
DATA: END OF gs_data_forms,
gt_data_forms LIKE TABLE OF gs_data_forms.

DATA: BEGIN OF gs_data_game_indices,
        game_index TYPE i,
        version_g  TYPE zoe_poke_st_version,
        url2       TYPE url,
      END OF gs_data_game_indices,
      gt_data_game_indices LIKE TABLE OF gs_data_game_indices.

DATA: BEGIN OF gs_data_held_items,
        url2            TYPE url,
        item            TYPE zoe_poke_st_item,
        version_details TYPE icon_d,
      END OF gs_data_held_items,
      gt_data_held_items LIKE TABLE OF gs_data_held_items,
      BEGIN OF gs_data_version_details,
        rarity    TYPE int4,
        version_h TYPE zoe_poke_st_version,
        url2      TYPE url,
      END OF gs_data_version_details,
      gt_data_version_details LIKE TABLE OF gs_data_version_details.

DATA: BEGIN OF gs_data_moves,
        url2                  TYPE url,
        move                  TYPE zoe_poke_st_move,
        version_group_details TYPE icon_d,
      END OF gs_data_moves,
      gt_data_moves LIKE TABLE OF gs_data_moves,
      BEGIN OF gs_data_version_group_details,
        level_learned_at  TYPE int4,
        move_learn_method TYPE zoe_poke_st_mlm,
        version_group     TYPE zoe_poke_st_vg,
        url2              TYPE url,
        url3              TYPE url,
      END OF gs_data_version_group_details,
      gt_data_version_group_details LIKE TABLE OF gs_data_version_group_details.

DATA: BEGIN OF gs_data_stats,
        base_stat TYPE int4,
        effort    TYPE int4,
        stat      TYPE zoe_poke_st_stat,
        url2      TYPE url,
      END OF gs_data_stats,
      gt_data_stats LIKE TABLE OF gs_data_stats.

DATA: BEGIN OF gs_data_types,
        slot TYPE int4,
        type TYPE zoe_poke_st_type,
        url2 TYPE url,
      END OF gs_data_types,
      gt_data_types LIKE TABLE OF gs_data_types.

************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME.
PARAMETERS: p_single RADIOBUTTON GROUP rbg1 DEFAULT 'X',
            p_string TYPE text20 DEFAULT `6`.
SELECTION-SCREEN SKIP.
PARAMETERS: p_multi RADIOBUTTON GROUP rbg1.
SELECT-OPTIONS: s_text FOR p_string NO INTERVALS.
SELECTION-SCREEN SKIP.
PARAMETERS: p_gen1 RADIOBUTTON GROUP rbg1,
            p_gen2 RADIOBUTTON GROUP rbg1,
            p_gen3 RADIOBUTTON GROUP rbg1,
            p_gen4 RADIOBUTTON GROUP rbg1,
            p_gen5 RADIOBUTTON GROUP rbg1,
            p_gen6 RADIOBUTTON GROUP rbg1,
            p_gen7 RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN SKIP.
PARAMETERS: p_alt RADIOBUTTON GROUP rbg1.
SELECTION-SCREEN END OF BLOCK blk1.

************************************************************************
*RANGES                                                                *
************************************************************************
