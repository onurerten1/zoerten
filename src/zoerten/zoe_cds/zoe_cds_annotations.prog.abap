*&---------------------------------------------------------------------*
*& Report ZOE_CDS_ANNOTATIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_annotations.

DATA(gv_text_element) = cl_dd_ddl_annotation_service=>get_label_4_element(
                            entityname = 'ZOE_CDS26'
                            elementname = 'URL'
                            language = sy-langu ).

DATA(gv_text_entity) = cl_dd_ddl_annotation_service=>get_label_4_entity(
                          entityname = 'ZOE_CDS26'
                          language = sy-langu ).

DATA(gv_text_info) = cl_dd_ddl_annotation_service=>get_quickinfo_4_element(
                        entityname = 'ZOE_CDS26'
                        elementname = 'URL'
                        language = sy-langu ).

WRITE: / 'Element Text : ' , gv_text_element,
       /  ,
       / 'Entity Text : ' , gv_text_entity,
       /  ,
       / 'Quick Info Text : ' , gv_text_info.
