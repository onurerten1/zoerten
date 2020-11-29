*&---------------------------------------------------------------------*
*& Report zoe_cds_cl_annot
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_cl_annot.

DATA(gv_entity_name) = cl_dd_ddl_annotation_service=>get_label_4_entity(
                                            entityname = 'ZOE_CDS_10'
                                            language = sy-langu ).

DATA(gv_element_text) = cl_dd_ddl_annotation_service=>get_label_4_element(
                                            entityname = 'ZOE_CDS_10'
                                            elementname = 'ITEM_CNT'
                                            language = sy-langu ).

DATA(gv_element_info) = cl_dd_ddl_annotation_service=>get_quickinfo_4_element(
                                            entityname = 'ZOE_CDS_10'
                                            elementname = 'ITEM_CNT'
                                            language = sy-langu ).

WRITE: / 'Entity Name: ' , gv_entity_name,
       / ,
       / 'Element Text: ' , gv_element_text,
       / ,
       / 'Element Info: ' , gv_element_info.
