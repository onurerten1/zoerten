*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
REPORT  zoesaplink_installer.

CLASS zcx_saplink DEFINITION
  INHERITING FROM cx_static_check
  CREATE PUBLIC
  .
  PUBLIC SECTION.

    CONSTANTS error_message TYPE sotr_conc VALUE '005056C000081ED696E10D9EF345B892'. "#EC NOTEXT
    CONSTANTS existing TYPE sotr_conc VALUE '005056C000081ED696E10D9EF345D892'. "#EC NOTEXT
    CONSTANTS incorrect_file_format TYPE sotr_conc VALUE '005056C000081ED696E10D9EF345F892'. "#EC NOTEXT
    CONSTANTS locked TYPE sotr_conc VALUE '005056C000081ED696E10D9EF3461892'. "#EC NOTEXT
    DATA msg TYPE string VALUE '44F7518323DB08BC02000000A7E42BB6'. "#EC NOTEXT
    CONSTANTS not_authorized TYPE sotr_conc VALUE '005056C000081ED696E10D9EF3463892'. "#EC NOTEXT
    CONSTANTS not_found TYPE sotr_conc VALUE '005056C000081ED696E10D9EF3465892'. "#EC NOTEXT
    CONSTANTS no_plugin TYPE sotr_conc VALUE '005056C000081ED696E10D9EF3467892'. "#EC NOTEXT
    CONSTANTS system_error TYPE sotr_conc VALUE '005056C000081ED696E10D9EF3469892'. "#EC NOTEXT
    CONSTANTS zcx_saplink TYPE sotr_conc VALUE '005056C000081ED696E10D9EF346B892'. "#EC NOTEXT
    DATA object TYPE string .

    METHODS constructor
      IMPORTING
        !textid   LIKE textid OPTIONAL
        !previous LIKE previous OPTIONAL
        !msg      TYPE string DEFAULT '44F7518323DB08BC02000000A7E42BB6'
        !object   TYPE string OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zsaplink DEFINITION
  CREATE PUBLIC
  ABSTRACT
  .
  PUBLIC SECTION.

    TYPES:
      BEGIN OF  gts_version_info,
*     Change this if import or export is incompatible to older major versions or if enhancements are so important to force the new version of the plugin
*     Please comment changes in major version in class documentation
        zsaplink_plugin_major_version TYPE i,
*     Change this if bugfixes are being done but the basic structure and im- and exportbehaviour don't change.  Reset to 0 when incrementing major version
*     Please comment changes in minor version in class documentation
        zsaplink_plugin_minor_version TYPE i,
*     Change this if cosmetic changes are being done or if internal handling changed but no change to import- or exportbehaviour
*    ( i.e. speeding up the plugin will fall into this ).  Reset to 0 when incrementeing major or minor version
        zsaplink_plugin_build_version TYPE i,
*
        zsaplink_plugin_info1         TYPE string,  " Plugin info - part 1    -  See demoimplementation how this may be used
        zsaplink_plugin_info2         TYPE string,  " Plugin info - part 2
        zsaplink_plugin_info3         TYPE string,  " Plugin info - part 3
        zsaplink_plugin_info4         TYPE string,  " Plugin info - part 4
        zsaplink_plugin_info5         TYPE string,  " Plugin info - part 5
      END OF gts_version_info .

    DATA nugget_level TYPE int4 READ-ONLY VALUE 0.          "#EC NOTEXT

    CLASS-METHODS getobjectinfofromixmldoc
      IMPORTING
        !ixmldocument TYPE REF TO if_ixml_document
      EXPORTING
        !objtypename  TYPE string
        !objname      TYPE string
      RAISING
        zcx_saplink .
    CLASS-METHODS convertstringtoixmldoc
      IMPORTING
        VALUE(xmlstring)    TYPE string
      RETURNING
        VALUE(ixmldocument) TYPE REF TO if_ixml_document .
    CLASS-METHODS convertixmldoctostring
      IMPORTING
        !ixmldocument    TYPE REF TO if_ixml_document
      RETURNING
        VALUE(xmlstring) TYPE string .
    CLASS-METHODS get_version_info_static
      IMPORTING
        !iv_classname          TYPE clike
      RETURNING
        VALUE(rs_version_info) TYPE gts_version_info .
    METHODS createobjectfromixmldoc
          ABSTRACT
      IMPORTING
        !ixmldocument TYPE REF TO if_ixml_document
        !devclass     TYPE devclass DEFAULT '$TMP'
        !overwrite    TYPE flag OPTIONAL
      RETURNING
        VALUE(name)   TYPE string
      RAISING
        zcx_saplink .
    METHODS createixmldocfromobject
          ABSTRACT
      RETURNING
        VALUE(ixmldocument) TYPE REF TO if_ixml_document
      RAISING
        zcx_saplink .
    METHODS createstringfromobject
      RETURNING
        VALUE(string) TYPE string
      RAISING
        zcx_saplink .
    METHODS constructor
      IMPORTING
        !name TYPE string .
    METHODS uploadxml
          FINAL
      IMPORTING
        !xmldata TYPE string .
    CLASS-METHODS getplugins
      CHANGING
        VALUE(objecttable) TYPE table .
    METHODS checkexists
          ABSTRACT
      RETURNING
        VALUE(exists) TYPE flag .
    METHODS valuehelp
      IMPORTING
        !i_objtype       TYPE string
      RETURNING
        VALUE(e_objname) TYPE string .
    CLASS-METHODS checkobject
      IMPORTING
        !i_ixmldocument TYPE REF TO if_ixml_document
      EXPORTING
        !e_objtype      TYPE string
        !e_objname      TYPE string
        !e_pluginexists TYPE flag
        !e_objectexists TYPE flag
        !e_targetobject TYPE REF TO zsaplink .
    METHODS get_version_info
      RETURNING
        VALUE(rs_version_info) TYPE gts_version_info .
  PROTECTED SECTION.

    DATA objname TYPE string .
    DATA ixml TYPE REF TO if_ixml .
    DATA xmldoc TYPE REF TO if_ixml_document .

    METHODS deleteobject
          ABSTRACT
      RAISING
        zcx_saplink .
    CLASS-METHODS setattributesfromstructure
      IMPORTING
        !node      TYPE REF TO if_ixml_element
        !structure TYPE data .
    CLASS-METHODS getstructurefromattributes
      IMPORTING
        !node            TYPE REF TO if_ixml_element
        !preserveversion TYPE flag OPTIONAL
      CHANGING
        !structure       TYPE data .
    METHODS createxmlstring
          FINAL
      RETURNING
        VALUE(xml) TYPE string .
    CLASS-METHODS buildtablefromstring
      IMPORTING
        !source            TYPE string
      RETURNING
        VALUE(sourcetable) TYPE table_of_strings .
    CLASS-METHODS buildsourcestring
      IMPORTING
        !sourcetable        TYPE rswsourcet OPTIONAL
        !pagetable          TYPE o2pageline_table OPTIONAL
      RETURNING
        VALUE(sourcestring) TYPE string .
    METHODS getobjecttype
          ABSTRACT
      RETURNING
        VALUE(objecttype) TYPE string .
    METHODS createotrfromnode
      IMPORTING
        VALUE(node) TYPE REF TO if_ixml_element
        !devclass   TYPE devclass DEFAULT '$TMP'
      EXPORTING
        !concept    TYPE sotr_text-concept
      RAISING
        zcx_saplink .
    METHODS createnodefromotr
      IMPORTING
        !otrguid    TYPE sotr_conc
      RETURNING
        VALUE(node) TYPE REF TO if_ixml_element .
  PRIVATE SECTION.

    TYPES:
      BEGIN OF t_objecttable,
        classname TYPE string,
        object    TYPE ko100-object,
        text      TYPE ko100-text,
      END OF t_objecttable .

    DATA streamfactory TYPE REF TO if_ixml_stream_factory .
    DATA xmldata TYPE string .
    DATA:
      objecttable TYPE TABLE OF t_objecttable .
ENDCLASS.
CLASS zsaplink_oo DEFINITION
  INHERITING FROM zsaplink
  CREATE PUBLIC
  ABSTRACT
  .
  PUBLIC SECTION.
    TYPE-POOLS abap .
    TYPE-POOLS seop .
    TYPE-POOLS seor .
    TYPE-POOLS seos .
    TYPE-POOLS seot .
    TYPE-POOLS seox .

    CONSTANTS c_xml_key_friends TYPE string VALUE 'friends'. "#EC NOTEXT
    CONSTANTS c_xml_key_inheritance TYPE string VALUE 'inheritance'. "#EC NOTEXT
    CONSTANTS c_xml_key_sotr TYPE string VALUE 'sotr'.      "#EC NOTEXT
    CONSTANTS c_xml_key_sotrtext TYPE string VALUE 'sotrText'. "#EC NOTEXT
  PROTECTED SECTION.

    CONSTANTS c_xml_key_alias_method TYPE string VALUE 'aliasMethod'. "#EC NOTEXT
    CONSTANTS c_xml_key_clsdeferrd TYPE string VALUE 'typeClasDef'. "#EC NOTEXT
    CONSTANTS c_xml_key_forwarddeclaration TYPE string VALUE 'forwardDeclaration'. "#EC NOTEXT
    CONSTANTS c_xml_key_intdeferrd TYPE string VALUE 'typeIntfDef'. "#EC NOTEXT
    CONSTANTS c_xml_key_typepusage TYPE string VALUE 'typeUsage'. "#EC NOTEXT

    METHODS create_alias_method
      CHANGING
        !xt_aliases_method TYPE seoo_aliases_r .
    METHODS create_clsdeferrd
      CHANGING
        !xt_clsdeferrds TYPE seot_clsdeferrds_r .
    METHODS create_intdeferrd
      CHANGING
        !xt_intdeferrds TYPE seot_intdeferrds_r .
    METHODS create_otr
      IMPORTING
        VALUE(node) TYPE REF TO if_ixml_element
        !devclass   TYPE devclass DEFAULT '$TMP'
      EXPORTING
        !concept    TYPE sotr_text-concept
      RAISING
        zcx_saplink .
    METHODS create_typepusage
      CHANGING
        !xt_typepusages TYPE seot_typepusages_r .
    METHODS get_alias_method
      IMPORTING
        !it_methods  TYPE abap_methdescr_tab
      CHANGING
        !xo_rootnode TYPE REF TO if_ixml_element .
    METHODS get_clsdeferrd
      CHANGING
        !xo_rootnode TYPE REF TO if_ixml_element .
    METHODS get_intdeferrd
      CHANGING
        !xo_rootnode TYPE REF TO if_ixml_element .
    METHODS get_otr
      IMPORTING
        !otrguid    TYPE sotr_conc
      RETURNING
        VALUE(node) TYPE REF TO if_ixml_element .
    METHODS get_typepusage
      CHANGING
        !xo_rootnode TYPE REF TO if_ixml_element .
  PRIVATE SECTION.
ENDCLASS.
CLASS zsaplink_class DEFINITION
  INHERITING FROM zsaplink_oo
  CREATE PUBLIC
  .
  PUBLIC SECTION.

    TYPE-POOLS abap .
    DATA mv_steamroller TYPE abap_bool VALUE abap_false.    "#EC NOTEXT

    METHODS checkexists
        REDEFINITION .
    METHODS createixmldocfromobject
        REDEFINITION .
    METHODS createobjectfromixmldoc
        REDEFINITION .
    METHODS get_version_info
        REDEFINITION .
  PROTECTED SECTION.

    CONSTANTS c_xml_key_method_documentation TYPE string VALUE 'methodDocumentation'. "#EC NOTEXT
    CONSTANTS c_xml_key_textelement TYPE string VALUE 'textElement'. "#EC NOTEXT
    CONSTANTS c_xml_key_textpool TYPE string VALUE 'textPool'. "#EC NOTEXT
    CONSTANTS c_xml_key_class_documentation TYPE string VALUE 'classDocumentation'. "#EC NOTEXT
    CONSTANTS c_xml_key_language TYPE string VALUE 'language'. "#EC NOTEXT
    CONSTANTS c_xml_key_object TYPE string VALUE 'OBJECT'.  "#EC NOTEXT
    CONSTANTS c_xml_key_spras TYPE string VALUE 'SPRAS'.    "#EC NOTEXT
    CONSTANTS c_xml_key_textline TYPE string VALUE 'textLine'. "#EC NOTEXT

    METHODS create_documentation .
    METHODS create_method_documentation
      IMPORTING
        !node TYPE REF TO if_ixml_element .
    METHODS create_sections .
    METHODS create_textpool .
    METHODS findimplementingclass
      IMPORTING
        !methodname      TYPE string
        !startclass      TYPE string OPTIONAL
      RETURNING
        VALUE(classname) TYPE string .
    METHODS get_documentation
      CHANGING
        !rootnode TYPE REF TO if_ixml_element .
    METHODS get_method_documentation
      IMPORTING
        !method_key TYPE seocpdkey
      CHANGING
        !rootnode   TYPE REF TO if_ixml_element .
    METHODS get_sections
      CHANGING
        !rootnode TYPE REF TO if_ixml_element .
    METHODS get_textpool
      CHANGING
        !rootnode TYPE REF TO if_ixml_element .

    METHODS deleteobject
        REDEFINITION .
    METHODS getobjecttype
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.
CLASS zsaplink_program DEFINITION
  INHERITING FROM zsaplink
  FINAL
  CREATE PUBLIC
  .
  PUBLIC SECTION.

    METHODS checkexists
        REDEFINITION .
    METHODS createixmldocfromobject
        REDEFINITION .
    METHODS createobjectfromixmldoc
        REDEFINITION .
    METHODS createstringfromobject
        REDEFINITION .
  PROTECTED SECTION.

    METHODS deleteobject
        REDEFINITION .
    METHODS getobjecttype
        REDEFINITION .
  PRIVATE SECTION.

    METHODS get_source
      RETURNING
        VALUE(progsource) TYPE rswsourcet .
    METHODS update_wb_tree .
    METHODS create_textpool
      IMPORTING
        !textpoolnode TYPE REF TO if_ixml_element .
    METHODS dequeue_abap
      RAISING
        zcx_saplink .
    METHODS get_textpool
      RETURNING
        VALUE(textnode) TYPE REF TO if_ixml_element .
    METHODS create_documentation
      IMPORTING
        !docnode TYPE REF TO if_ixml_element .
    METHODS create_source
      IMPORTING
        !source  TYPE table_of_strings
        !attribs TYPE trdir .
    METHODS enqueue_abap
      RAISING
        zcx_saplink .
    METHODS get_documentation
      RETURNING
        VALUE(docnode) TYPE REF TO if_ixml_element .
    METHODS transport_copy
      IMPORTING
        !author   TYPE syuname
        !devclass TYPE devclass
      RAISING
        zcx_saplink .
    METHODS get_dynpro
      RETURNING
        VALUE(dynp_node) TYPE REF TO if_ixml_element .
    METHODS create_dynpro
      IMPORTING
        !dynp_node TYPE REF TO if_ixml_element .
    METHODS get_pfstatus
      RETURNING
        VALUE(pfstat_node) TYPE REF TO if_ixml_element .
    METHODS create_pfstatus
      IMPORTING
        !pfstat_node TYPE REF TO if_ixml_element .
ENDCLASS.
CLASS zcx_saplink IMPLEMENTATION.
  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous.
    IF textid IS INITIAL.
      me->textid = zcx_saplink .
    ENDIF.
    me->msg = msg .
    me->object = object .
  ENDMETHOD.
ENDCLASS.
CLASS zsaplink IMPLEMENTATION.
  METHOD buildsourcestring.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA stemp TYPE string.
    DATA pageline TYPE o2pageline.

    IF sourcetable IS NOT INITIAL.
      LOOP AT sourcetable INTO stemp.
        CONCATENATE sourcestring stemp cl_abap_char_utilities=>newline
          INTO sourcestring.
      ENDLOOP.
    ELSEIF pagetable IS NOT INITIAL.
      LOOP AT pagetable INTO pageline.
        CONCATENATE sourcestring pageline-line
          cl_abap_char_utilities=>newline
          INTO sourcestring.
      ENDLOOP.
    ENDIF.

* remove extra newline characters for conversion comparison consistency
    SHIFT sourcestring LEFT DELETING LEADING
      cl_abap_char_utilities=>newline.
    SHIFT sourcestring RIGHT DELETING TRAILING
      cl_abap_char_utilities=>newline.
    SHIFT sourcestring LEFT DELETING LEADING space.
  ENDMETHOD.
  METHOD buildtablefromstring.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    SPLIT source AT cl_abap_char_utilities=>newline
      INTO TABLE sourcetable.
  ENDMETHOD.
  METHOD checkobject.
    DATA l_objtable LIKE objecttable.
    DATA l_objline  LIKE LINE OF objecttable.

    CLEAR: e_objtype, e_objname, e_pluginexists, e_objectexists.
    TRY.
        CALL METHOD zsaplink=>getobjectinfofromixmldoc
          EXPORTING
            ixmldocument = i_ixmldocument
          IMPORTING
            objtypename  = e_objtype
            objname      = e_objname.
      CATCH zcx_saplink.
    ENDTRY.

    CALL METHOD zsaplink=>getplugins( CHANGING objecttable = l_objtable ).

    READ TABLE l_objtable INTO l_objline WITH KEY object = e_objtype.

    IF sy-subrc = 0.
      e_pluginexists = 'X'.
      CREATE OBJECT e_targetobject
        TYPE
          (l_objline-classname)
        EXPORTING
          name                  = e_objname.

      e_objectexists = e_targetobject->checkexists( ).
    ENDIF.

  ENDMETHOD.
  METHOD constructor.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/

*  data meTypeDescr type ref to CL_ABAP_TYPEDESCR.
*  clear className.
*
*  objName = name.
*  meTypeDescr = CL_ABAP_TYPEDESCR=>DESCRIBE_BY_OBJECT_REF( me ).
*  className = meTypeDescr->get_relative_name( ).

    objname = name.
    TRANSLATE objname TO UPPER CASE.

    ixml = cl_ixml=>create( ).
    xmldoc = ixml->create_document( ).
    streamfactory = ixml->create_stream_factory( ).
  ENDMETHOD.
  METHOD convertixmldoctostring.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA _ixml TYPE REF TO if_ixml.
    DATA _encoding   TYPE REF TO if_ixml_encoding.
    DATA _streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA _outputstream TYPE REF TO if_ixml_ostream.
    DATA _renderer TYPE REF TO if_ixml_renderer.
    DATA _tempstring  TYPE string.
    DATA _tempstringx TYPE xstring.
    DATA _printxmldoc TYPE REF TO cl_xml_document.
    DATA _rc TYPE sysubrc.

    _ixml = cl_ixml=>create( ).
    _encoding = _ixml->create_encoding(
        byte_order    = if_ixml_encoding=>co_none
        character_set = 'utf-8' ).
    _streamfactory = _ixml->create_stream_factory( ).
    _outputstream = _streamfactory->create_ostream_xstring( _tempstringx ).
    _outputstream->set_encoding( encoding = _encoding ).
    _renderer = _ixml->create_renderer(
                  document = ixmldocument
                  ostream  = _outputstream
                ).
    _renderer->set_normalizing( ).
    _rc = _renderer->render( ).
    CREATE OBJECT _printxmldoc.
    _rc = _printxmldoc->parse_string( _tempstring ).

    CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
      EXPORTING
        im_xstring  = _tempstringx
        im_encoding = 'UTF-8'
      IMPORTING
        ex_string   = _tempstring.

    xmlstring = _tempstring.
  ENDMETHOD.
  METHOD convertstringtoixmldoc.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA ixml TYPE REF TO if_ixml.
    DATA streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA istream TYPE REF TO if_ixml_istream.
    DATA ixmlparser TYPE REF TO if_ixml_parser.
    DATA xmldoc TYPE REF TO if_ixml_document.

    " Make sure to convert Windows Line Break to Unix as
    " this linebreak is used to get a correct import
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf
      IN xmlstring WITH cl_abap_char_utilities=>newline.

    ixml = cl_ixml=>create( ).
    xmldoc = ixml->create_document( ).
    streamfactory = ixml->create_stream_factory( ).
    istream = streamfactory->create_istream_string( xmlstring ).
    ixmlparser = ixml->create_parser(  stream_factory = streamfactory
                                       istream        = istream
                                       document       = xmldoc ).
    ixmlparser->parse( ).
    ixmldocument = xmldoc.
  ENDMETHOD.
  METHOD createnodefromotr.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA txtnode TYPE REF TO if_ixml_element.
    DATA rc TYPE sysubrc.

    DATA sotrheader TYPE sotr_head.
    DATA sotrtextline TYPE sotr_text.
    DATA sotrtexttable TYPE TABLE OF sotr_text.

    DATA _ixml TYPE REF TO if_ixml.
    DATA _xmldoc TYPE REF TO if_ixml_document.

    CALL FUNCTION 'SOTR_GET_CONCEPT'
      EXPORTING
        concept        = otrguid
      IMPORTING
        header         = sotrheader
      TABLES
        entries        = sotrtexttable
      EXCEPTIONS
        no_entry_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    sotrheader-paket = '$TMP'. "change devclass to $TMP for exports

* Create xml doc
*  _ixml = cl_ixml=>create( ).
*  _xmldoc = _ixml->create_document( ).
*  streamfactory = _ixml->create_stream_factory( ).

* Create parent node
    rootnode = xmldoc->create_element( zsaplink_oo=>c_xml_key_sotr ). "OTR object type
    CLEAR sotrheader-concept.                                 "ewH:33
    setattributesfromstructure( node = rootnode structure = sotrheader ).

* Create nodes for texts
    LOOP AT sotrtexttable INTO sotrtextline.
      txtnode = xmldoc->create_element( zsaplink_oo=>c_xml_key_sotrtext ).
      CLEAR: sotrtextline-concept, sotrtextline-object.       "ewH:33
      setattributesfromstructure(
        node = txtnode structure = sotrtextline ).
      rc = rootnode->append_child( txtnode ).
    ENDLOOP.

    node = rootnode.

  ENDMETHOD.
  METHOD createotrfromnode.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA txtnode TYPE REF TO if_ixml_element.
    DATA filter TYPE REF TO if_ixml_node_filter.
    DATA iterator TYPE REF TO if_ixml_node_iterator.

    DATA sotrheader TYPE sotr_head.
    DATA sotrtextline TYPE sotr_text.
    DATA sotrtexttable TYPE TABLE OF sotr_text.
    DATA sotrpaket TYPE sotr_pack.

* get OTR header info
    CALL METHOD getstructurefromattributes
      EXPORTING
        node      = node
      CHANGING
        structure = sotrheader.

* get OTR text info
    filter = node->create_filter_name( zsaplink_oo=>c_xml_key_sotrtext ).
    iterator = node->create_iterator_filtered( filter ).
    txtnode ?= iterator->get_next( ).

    WHILE txtnode IS NOT INITIAL.
      CLEAR sotrtextline.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = txtnode
        CHANGING
          structure = sotrtextline.
      CLEAR: sotrtextline-concept, sotrtextline-object.       "ewH:33
      APPEND sotrtextline TO sotrtexttable.
      txtnode ?= iterator->get_next( ).
    ENDWHILE.

* ewH:issue 33--> in 6.40 and above, you cannot pass a default concept
*  (otr) guid, so we will always create new
*  CALL FUNCTION 'SOTR_GET_CONCEPT'
*    EXPORTING
*      concept              = sotrHeader-concept
**   IMPORTING
**     HEADER               =
**   TABLES
**     ENTRIES              =
*   EXCEPTIONS
*     NO_ENTRY_FOUND       = 1
*     OTHERS               = 2
*            .
*  IF sy-subrc <> 1.
**   delete OTR if exists already
*    CALL FUNCTION 'SOTR_DELETE_CONCEPT'
*      EXPORTING
*        concept                     = sotrHeader-concept
*     EXCEPTIONS
*       NO_AUTHORIZATION            = 1
*       NO_ENTRY_FOUND              = 2. "who cares
**       CONCEPT_USED                = 3
**       NO_MASTER_LANGUAGE          = 4
**       NO_SOURCE_SYSTEM            = 5
**       NO_TADIR_ENTRY              = 6
**       ERROR_IN_CORRECTION         = 7
**       USER_CANCELLED              = 8
**       OTHERS                      = 9
**              .
*    if sy-subrc = 1.
*      raise exception type zcx_saplink
*        exporting textid = zcx_saplink=>not_authorized.
*    endif.
*  ENDIF.


    DATA objecttable TYPE sotr_objects.
    DATA objecttype TYPE LINE OF sotr_objects.
* Retrieve object type of OTR
    CALL FUNCTION 'SOTR_OBJECT_GET_OBJECTS'
      EXPORTING
        object_vector    = sotrheader-objid_vec
      IMPORTING
        objects          = objecttable
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    READ TABLE objecttable INTO objecttype INDEX 1.

* create OTR
    sotrpaket-paket = devclass.
    CALL FUNCTION 'SOTR_CREATE_CONCEPT'
      EXPORTING
        paket                         = sotrpaket
        crea_lan                      = sotrheader-crea_lan
        alias_name                    = sotrheader-alias_name
*       CATEGORY                      =
        object                        = objecttype
        entries                       = sotrtexttable
*       FLAG_CORRECTION_ENTRY         =
*       IN_UPDATE_TASK                =
*       CONCEPT_DEFAULT               = sotrHeader-concept "ewH:33
      IMPORTING
        concept                       = concept         "ewH:33
      EXCEPTIONS
        package_missing               = 1
        crea_lan_missing              = 2
        object_missing                = 3
        paket_does_not_exist          = 4
        alias_already_exist           = 5
        object_type_not_found         = 6
        langu_missing                 = 7
        identical_context_not_allowed = 8
        text_too_long                 = 9
        error_in_update               = 10
        no_master_langu               = 11
        error_in_concept_id           = 12
        alias_not_allowed             = 13
        tadir_entry_creation_failed   = 14
        internal_error                = 15
        error_in_correction           = 16
        user_cancelled                = 17
        no_entry_found                = 18
        OTHERS                        = 19.
    IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDMETHOD.
  METHOD createstringfromobject.
  ENDMETHOD.
  METHOD createxmlstring.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA outputstream TYPE REF TO if_ixml_ostream.
    DATA renderer TYPE REF TO if_ixml_renderer.
    DATA tempstring TYPE string.
    DATA printxmldoc TYPE REF TO cl_xml_document.
    DATA rc TYPE sysubrc.

    streamfactory = ixml->create_stream_factory( ).
    outputstream = streamfactory->create_ostream_cstring( tempstring ).
    renderer = ixml->create_renderer(
      document = xmldoc ostream = outputstream ).
    rc = renderer->render( ).
    CREATE OBJECT printxmldoc.
    rc = printxmldoc->parse_string( tempstring ).
    xml = tempstring.
  ENDMETHOD.
  METHOD getobjectinfofromixmldoc.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_node.
    DATA rootattr TYPE REF TO if_ixml_named_node_map.
    DATA attrnode TYPE REF TO if_ixml_node.
    DATA nodename TYPE string.

    rootnode ?= ixmldocument->get_root_element( ).
* Check whether got a valid ixmldocument
    IF rootnode IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_saplink
        EXPORTING
          textid = zcx_saplink=>incorrect_file_format.
    ENDIF.

* get object type
    objtypename = rootnode->get_name( ).
    TRANSLATE objtypename TO UPPER CASE.

* get object name
    rootattr = rootnode->get_attributes( ).
    attrnode = rootattr->get_item( 0 ).
    objname = attrnode->get_value( ).
  ENDMETHOD.
  METHOD getplugins.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA classlist TYPE seo_inheritances.
    DATA classline TYPE vseoextend.
    DATA classobject TYPE REF TO zsaplink.
    DATA objectline TYPE t_objecttable.
    DATA tabletypeline TYPE ko105.
    DATA tabletypesin TYPE TABLE OF ko105.
    DATA tabletypesout TYPE tr_object_texts.
    DATA tabletypeoutline TYPE ko100.
    DATA clsname TYPE string.
    DATA objtype TYPE trobjtype.

    REFRESH objecttable.

    SELECT * FROM vseoextend INTO TABLE classlist
      WHERE refclsname LIKE 'ZSAPLINK%'
      AND version = '1'.

    LOOP AT classlist INTO classline.
      clsname = classline-clsname.
      TRY.
          CREATE OBJECT classobject
            TYPE
              (clsname)
            EXPORTING
              name      = 'foo'.
          objtype = classobject->getobjecttype( ).
        CATCH cx_root.
          CONTINUE.
      ENDTRY.
      CLEAR tabletypeline.
      REFRESH tabletypesin.

      tabletypeline-object = objtype.
      APPEND tabletypeline TO tabletypesin.

      CALL FUNCTION 'TRINT_OBJECT_TABLE'
        TABLES
          tt_types_in  = tabletypesin
          tt_types_out = tabletypesout.

      LOOP AT tabletypesout INTO tabletypeoutline.
        objectline-classname = clsname.
        MOVE-CORRESPONDING tabletypeoutline TO objectline.
        APPEND objectline TO objecttable.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD getstructurefromattributes.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA attributelist TYPE REF TO if_ixml_named_node_map.
    DATA nodeiterator TYPE REF TO if_ixml_node_iterator.
    DATA attributenode TYPE REF TO if_ixml_node.
    DATA value TYPE string.
    DATA name TYPE string.
    FIELD-SYMBOLS <value> TYPE any.

    CLEAR structure.
    attributelist = node->get_attributes( ).
    nodeiterator = attributelist->create_iterator( ).
    attributenode = nodeiterator->get_next( ).
    WHILE attributenode IS NOT INITIAL.
      name = attributenode->get_name( ).
      IF name = 'VERSION' AND preserveversion IS INITIAL. "ewh:issue 45
*    if name = 'VERSION'.
        value = '0'.
      ELSE.
        value = attributenode->get_value( ).
      ENDIF.
      ASSIGN COMPONENT name OF STRUCTURE structure TO <value>.
      IF sy-subrc = 0.
        <value> = value.
      ENDIF.
      attributenode = nodeiterator->get_next( ).
    ENDWHILE.















*    .-"-.
*  .'=^=^='.
* /=^=^=^=^=\
*:^=SAPLINK=^;
*|^ EASTER  ^|
*:^=^EGG^=^=^:
* \=^=^=^=^=/
*  `.=^=^=.'
*    `~~~`
* Don't like the way we did something?
* Help us fix it!  Tell us what you think!
* http://saplink.org
  ENDMETHOD.
  METHOD get_version_info.

*--------------------------------------------------------------------*
* Please use the following 6 lines of code when versioning a
* SAPLINK-Plugin.  See documentation of Type GTS_VERSION_INFO
* what should be put here
*--------------------------------------------------------------------*
    rs_version_info-zsaplink_plugin_major_version = 0.  " Default for all child classes, that have not been updated to return a version info.
    rs_version_info-zsaplink_plugin_minor_version = 0.  " Default for all child classes, that have not been updated to return a version info.
    rs_version_info-zsaplink_plugin_build_version = 0.  " Default for all child classes, that have not been updated to return a version info.

    rs_version_info-zsaplink_plugin_info1         = ''. " Sufficient to set this the first time a child class is being updated
    rs_version_info-zsaplink_plugin_info2         = ''. " Sufficient to set this the first time a child class is being updated
    rs_version_info-zsaplink_plugin_info3         = ''. " Sufficient to set this the first time a child class is being updated
    rs_version_info-zsaplink_plugin_info4         = ''. " Sufficient to set this the first time a child class is being updated
    rs_version_info-zsaplink_plugin_info5         = ''. " Sufficient to set this the first time a child class is being updated

* Hint - see redefinition of this class in ZSAPLINK_CLASS how information may be set
  ENDMETHOD.
  METHOD get_version_info_static.

    DATA: lo_zsaplink TYPE REF TO zsaplink.

    TRY.
        CREATE OBJECT lo_zsaplink TYPE (iv_classname)
           EXPORTING
             name = 'Not needed for versio info'.
        rs_version_info = lo_zsaplink->get_version_info( ).
      CATCH cx_root.  " Don't pass version info for unknown or abstract classes
    ENDTRY.

  ENDMETHOD.
  METHOD setattributesfromstructure.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA int TYPE i.
    int = int.
    DATA structdescr TYPE REF TO cl_abap_structdescr.
    DATA acomponent TYPE abap_compdescr.
    FIELD-SYMBOLS <fieldvalue> TYPE any.
    DATA rc TYPE sysubrc.
    DATA sname TYPE string.
    DATA svalue TYPE string.

    structdescr ?= cl_abap_structdescr=>describe_by_data( structure ).
    LOOP AT structdescr->components INTO acomponent.
      ASSIGN COMPONENT acomponent-name OF STRUCTURE
        structure TO <fieldvalue>.
      IF sy-subrc = 0.
        sname = acomponent-name.
*      sValue = <fieldValue>.
*     for certain attributes, set to a standard for exporting
        CASE sname.
*        when 'VERSION'. "version should always export as inactive
*          sValue = '0'. "commented by ewH: issue 45
          WHEN 'DEVCLASS'. "development class should always be $TMP
            svalue = '$TMP'.
            " Developer, Date and Time Metadata has to be removed to
            " not clutter diffs
            "
            " Meta Attributes for DDIC Types
          WHEN 'AS4USER'.
            CLEAR svalue.
          WHEN 'AS4DATE'.
            CLEAR svalue.
          WHEN 'AS4TIME'.
            CLEAR svalue.
            " Meta Attributes for PROG
          WHEN 'CNAM'.
            CLEAR svalue.
          WHEN 'CDAT'.
            CLEAR svalue.
          WHEN 'UNAM'.
            CLEAR svalue.
          WHEN 'UDAT'.
            CLEAR svalue.
          WHEN 'VERN'.
            CLEAR svalue.
          WHEN 'SDATE'.
            CLEAR svalue.
          WHEN 'STIME'.
            CLEAR svalue.
          WHEN 'IDATE'.
            CLEAR svalue.
          WHEN 'ITIME'.
            CLEAR svalue.
            " Meta Attributes for CLAS
          WHEN 'AUTHOR'.
            CLEAR svalue.
          WHEN 'CREATEDON'.
            CLEAR svalue.
          WHEN 'CHANGEDBY'.
            CLEAR svalue.
          WHEN 'CHANGEDON'.
            CLEAR svalue.
          WHEN 'CHANGETIME'.
            CLEAR svalue.
          WHEN 'CHGDANYON'.
            CLEAR svalue.
          WHEN 'R3RELEASE'.
            CLEAR svalue.
          WHEN 'UUID'.
            CLEAR svalue.
            " SOTR
          WHEN 'CREA_NAME'.
            CLEAR svalue.
          WHEN 'CHAN_NAME'.
            CLEAR svalue.
          WHEN 'CREA_TSTUT'.
            CLEAR svalue.
          WHEN 'CHAN_TSTUT'.
            CLEAR svalue.
            " MSAG
          WHEN 'LASTUSER'.
            CLEAR svalue.
          WHEN 'LDATE'.
            CLEAR svalue.
          WHEN 'LTIME'.
            CLEAR svalue.
          WHEN 'DGEN'.
            CLEAR svalue.
          WHEN 'TGEN'.
            CLEAR svalue.
          WHEN 'GENDATE'.
            CLEAR svalue.
          WHEN 'GENTIME'.
            CLEAR svalue.
            " BSP
          WHEN 'IMPLCLASS'.
            CLEAR svalue.
          WHEN OTHERS.
            svalue = <fieldvalue>.
        ENDCASE.
        IF svalue IS NOT INITIAL.
          rc = node->set_attribute( name = sname value = svalue ).
        ENDIF.
      ELSE.
* WHAT?>!??
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD uploadxml.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA istream TYPE REF TO if_ixml_istream.
    DATA ixmlparser TYPE REF TO if_ixml_parser.

    istream = streamfactory->create_istream_string( xmldata ).
    ixmlparser = ixml->create_parser(  stream_factory = streamfactory
                                       istream        = istream
                                       document       = xmldoc ).
    ixmlparser->parse( ).

  ENDMETHOD.
  METHOD valuehelp.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA l_object_type TYPE  euobj-id.
    DATA objname(40) TYPE c.

    l_object_type = i_objtype.


    CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
      EXPORTING
        object_type           = l_object_type
        object_name           = objname
        suppress_selection    = 'X'
        use_alv_grid          = ''
        without_personal_list = ''
      IMPORTING
        object_name_selected  = objname
      EXCEPTIONS
        cancel                = 1.

    e_objname = objname.
  ENDMETHOD.
ENDCLASS.
CLASS zsaplink_oo IMPLEMENTATION.
  METHOD create_alias_method.
    DATA: filter   TYPE REF TO if_ixml_node_filter,
          iterator TYPE REF TO if_ixml_node_iterator,
          node     TYPE REF TO if_ixml_element.

    DATA: ls_alias_method  LIKE LINE OF xt_aliases_method.


    filter = xmldoc->create_filter_name( c_xml_key_alias_method ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR ls_alias_method.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = ls_alias_method.
      INSERT ls_alias_method INTO TABLE xt_aliases_method.
      node ?= iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_clsdeferrd.
    DATA: filter   TYPE REF TO if_ixml_node_filter,
          iterator TYPE REF TO if_ixml_node_iterator,
          node     TYPE REF TO if_ixml_element.

    DATA: ls_clsdeferrd  LIKE LINE OF xt_clsdeferrds.


    filter   = xmldoc->create_filter_name( c_xml_key_clsdeferrd ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = ls_clsdeferrd.
      APPEND ls_clsdeferrd TO xt_clsdeferrds.
      node ?= iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_intdeferrd.
    DATA: filter   TYPE REF TO if_ixml_node_filter,
          iterator TYPE REF TO if_ixml_node_iterator,
          node     TYPE REF TO if_ixml_element.

    DATA: ls_intdeferrd  LIKE LINE OF xt_intdeferrds.


    filter   = xmldoc->create_filter_name( c_xml_key_intdeferrd ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = ls_intdeferrd.
      APPEND ls_intdeferrd TO xt_intdeferrds.
      node ?= iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_otr.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA txtnode TYPE REF TO if_ixml_element.
    DATA filter TYPE REF TO if_ixml_node_filter.
    DATA iterator TYPE REF TO if_ixml_node_iterator.

    DATA sotrheader TYPE sotr_head.
    DATA sotrtextline TYPE sotr_text.
    DATA sotrtexttable TYPE TABLE OF sotr_text.
    DATA sotrpaket TYPE sotr_pack.

* get OTR header info
    CALL METHOD getstructurefromattributes
      EXPORTING
        node      = node
      CHANGING
        structure = sotrheader.

* get OTR text info
    filter = node->create_filter_name( c_xml_key_sotrtext ).
    iterator = node->create_iterator_filtered( filter ).
    txtnode ?= iterator->get_next( ).

    WHILE txtnode IS NOT INITIAL.
      CLEAR sotrtextline.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = txtnode
        CHANGING
          structure = sotrtextline.
      CLEAR: sotrtextline-concept, sotrtextline-object.       "ewH:33
      APPEND sotrtextline TO sotrtexttable.
      txtnode ?= iterator->get_next( ).
    ENDWHILE.

* ewH:issue 33--> in 6.40 and above, you cannot pass a default concept
*  (otr) guid, so we will always create new
*  CALL FUNCTION 'SOTR_GET_CONCEPT'
*    EXPORTING
*      concept              = sotrHeader-concept
**   IMPORTING
**     HEADER               =
**   TABLES
**     ENTRIES              =
*   EXCEPTIONS
*     NO_ENTRY_FOUND       = 1
*     OTHERS               = 2
*            .
*  IF sy-subrc <> 1.
**   delete OTR if exists already
*    CALL FUNCTION 'SOTR_DELETE_CONCEPT'
*      EXPORTING
*        concept                     = sotrHeader-concept
*     EXCEPTIONS
*       NO_AUTHORIZATION            = 1
*       NO_ENTRY_FOUND              = 2. "who cares
**       CONCEPT_USED                = 3
**       NO_MASTER_LANGUAGE          = 4
**       NO_SOURCE_SYSTEM            = 5
**       NO_TADIR_ENTRY              = 6
**       ERROR_IN_CORRECTION         = 7
**       USER_CANCELLED              = 8
**       OTHERS                      = 9
**              .
*    if sy-subrc = 1.
*      raise exception type zcx_saplink
*        exporting textid = zcx_saplink=>not_authorized.
*    endif.
*  ENDIF.


    DATA objecttable TYPE sotr_objects.
    DATA objecttype TYPE LINE OF sotr_objects.
* Retrieve object type of OTR
    CALL FUNCTION 'SOTR_OBJECT_GET_OBJECTS'
      EXPORTING
        object_vector    = sotrheader-objid_vec
      IMPORTING
        objects          = objecttable
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    READ TABLE objecttable INTO objecttype INDEX 1.

* create OTR
    sotrpaket-paket = devclass.
    CALL FUNCTION 'SOTR_CREATE_CONCEPT'
      EXPORTING
        paket                         = sotrpaket
        crea_lan                      = sotrheader-crea_lan
        alias_name                    = sotrheader-alias_name
*       CATEGORY                      =
        object                        = objecttype
        entries                       = sotrtexttable
*       FLAG_CORRECTION_ENTRY         =
*       IN_UPDATE_TASK                =
*       CONCEPT_DEFAULT               = sotrHeader-concept "ewH:33
      IMPORTING
        concept                       = concept         "ewH:33
      EXCEPTIONS
        package_missing               = 1
        crea_lan_missing              = 2
        object_missing                = 3
        paket_does_not_exist          = 4
        alias_already_exist           = 5
        object_type_not_found         = 6
        langu_missing                 = 7
        identical_context_not_allowed = 8
        text_too_long                 = 9
        error_in_update               = 10
        no_master_langu               = 11
        error_in_concept_id           = 12
        alias_not_allowed             = 13
        tadir_entry_creation_failed   = 14
        internal_error                = 15
        error_in_correction           = 16
        user_cancelled                = 17
        no_entry_found                = 18
        OTHERS                        = 19.
    IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDMETHOD.
  METHOD create_typepusage.
    DATA: filter   TYPE REF TO if_ixml_node_filter,
          iterator TYPE REF TO if_ixml_node_iterator,
          node     TYPE REF TO if_ixml_element,
          source   TYPE string.


    DATA: ls_typepusage  LIKE LINE OF xt_typepusages.

*rrq comments Forward nodes are created in an old version of the
*create XML from object.  In that node, the only attribute set
*is the "TypeGroup".  All other attributes are hard coded on the
*create Object from XML .  To fix this and make it transparent to
*users, "forwaredDeclaration" nodes will be supported, and a new
*node will be added.
*if it is an old version XML document, forwardDeclarations nodes
*if it is a new version XML document, typeUsages nodes

    filter   = xmldoc->create_filter_name( c_xml_key_typepusage ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = ls_typepusage.
      APPEND ls_typepusage TO xt_typepusages.
      node ?= iterator->get_next( ).
    ENDWHILE.

* only check forwardDeclaration if typeUsages does not exist
* later version this will be removed
    IF xt_typepusages IS INITIAL.
      filter = xmldoc->create_filter_name( c_xml_key_forwarddeclaration ).
      iterator = xmldoc->create_iterator_filtered( filter ).
      node ?= iterator->get_next( ).

      WHILE node IS NOT INITIAL.
        CLEAR ls_typepusage.
        source = node->get_value( ).
        ls_typepusage-clsname = objname.
        ls_typepusage-version = '0'.
        ls_typepusage-tputype = '0'.
        ls_typepusage-explicit =  'X'.
        ls_typepusage-implicit = ''.
        ls_typepusage-typegroup = source.
        APPEND ls_typepusage TO xt_typepusages.
        node ?= iterator->get_next( ).
      ENDWHILE.
    ENDIF.

  ENDMETHOD.
  METHOD get_alias_method.
    DATA lo_alias  TYPE REF TO if_ixml_element.
    DATA ls_alias  TYPE seoaliases.
    DATA: l_rc          TYPE sy-subrc,
          ls_method     LIKE LINE OF it_methods,
          ls_clsmethkey TYPE seocmpkey.

    LOOP AT it_methods INTO ls_method.
      ls_clsmethkey-clsname = objname.
      ls_clsmethkey-cmpname = ls_method-name.
      CLEAR ls_alias.
      CALL FUNCTION 'SEO_ALIAS_GET'
        EXPORTING
          cmpkey       = ls_clsmethkey
*         VERSION      = SEOC_VERSION_INACTIVE
        IMPORTING
          alias        = ls_alias
        EXCEPTIONS
          not_existing = 1
          deleted      = 2
          OTHERS       = 3.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ELSE.
        lo_alias = xmldoc->create_element( c_xml_key_alias_method ).
        setattributesfromstructure( node      = lo_alias
                                    structure = ls_alias ).
        l_rc = xo_rootnode->append_child( lo_alias ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
  METHOD get_clsdeferrd.
    DATA: lt_clsdeferrds TYPE seot_clsdeferrds_r,
          lo_clsdeferrds TYPE REF TO if_ixml_element,
          ls_clsdeferrd  TYPE seot_typepusage_r.

    DATA: l_rc        TYPE sy-subrc,
          ls_classkey TYPE seoclskey.

    ls_classkey-clsname = objname.

    CALL FUNCTION 'SEO_CLSDEFERRD_READ_ALL'
      EXPORTING
        cifkey            = ls_classkey
        version           = seoc_version_active
      IMPORTING
        classdeferreds    = lt_clsdeferrds
      EXCEPTIONS
        clif_not_existing = 1
        OTHERS            = 2.

    LOOP AT lt_clsdeferrds INTO ls_clsdeferrd.
      lo_clsdeferrds = xmldoc->create_element( c_xml_key_clsdeferrd ).
      setattributesfromstructure( node      = lo_clsdeferrds
                                  structure = ls_clsdeferrd ).
      l_rc = xo_rootnode->append_child( lo_clsdeferrds ).
    ENDLOOP.
  ENDMETHOD.
  METHOD get_intdeferrd.
    DATA: lt_intdeferrds TYPE seot_intdeferrds_r,
          lo_intdeferrds TYPE REF TO if_ixml_element,
          ls_intdeferrd  TYPE seot_intdeferrd_r.

    DATA: l_rc        TYPE sy-subrc,
          ls_classkey TYPE seoclskey.

    ls_classkey-clsname = objname.

    CALL FUNCTION 'SEO_INTDEFERRD_READ_ALL'
      EXPORTING
        cifkey             = ls_classkey
        version            = seoc_version_active
      IMPORTING
        interfacedeferreds = lt_intdeferrds
      EXCEPTIONS
        clif_not_existing  = 1
        OTHERS             = 2.

    LOOP AT lt_intdeferrds INTO ls_intdeferrd.
      lo_intdeferrds = xmldoc->create_element( c_xml_key_intdeferrd ).
      setattributesfromstructure( node      = lo_intdeferrds
                                  structure = ls_intdeferrd ).
      l_rc = xo_rootnode->append_child( lo_intdeferrds ).
    ENDLOOP.

  ENDMETHOD.
  METHOD get_otr.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA txtnode TYPE REF TO if_ixml_element.
    DATA rc TYPE sysubrc.

    DATA sotrheader TYPE sotr_head.
    DATA sotrtextline TYPE sotr_text.
    DATA sotrtexttable TYPE TABLE OF sotr_text.

    DATA _ixml TYPE REF TO if_ixml.
    DATA _xmldoc TYPE REF TO if_ixml_document.

    CALL FUNCTION 'SOTR_GET_CONCEPT'
      EXPORTING
        concept        = otrguid
      IMPORTING
        header         = sotrheader
      TABLES
        entries        = sotrtexttable
      EXCEPTIONS
        no_entry_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    sotrheader-paket = '$TMP'. "change devclass to $TMP for exports

* Create xml doc
*  _ixml = cl_ixml=>create( ).
*  _xmldoc = _ixml->create_document( ).
*  streamfactory = _ixml->create_stream_factory( ).

* Create parent node
    rootnode = xmldoc->create_element( c_xml_key_sotr ). "OTR object type
    CLEAR sotrheader-concept.                                 "ewH:33
    setattributesfromstructure( node = rootnode structure = sotrheader ).

* Create nodes for texts
    LOOP AT sotrtexttable INTO sotrtextline.
      txtnode = xmldoc->create_element( c_xml_key_sotrtext ).
      CLEAR: sotrtextline-concept, sotrtextline-object.       "ewH:33
      setattributesfromstructure(
        node = txtnode structure = sotrtextline ).
      rc = rootnode->append_child( txtnode ).
    ENDLOOP.

    node = rootnode.

  ENDMETHOD.
  METHOD get_typepusage.
    DATA: lt_typepusages TYPE seot_typepusages_r,
          lo_typepusages TYPE REF TO if_ixml_element,
          ls_typepusage  TYPE seot_typepusage_r.

    DATA: l_rc        TYPE sy-subrc,
          l_string    TYPE string,
          ls_classkey TYPE seoclskey.

    ls_classkey-clsname = objname.

    CALL FUNCTION 'SEO_TYPEPUSAGE_READ_ALL'
      EXPORTING
        cifkey            = ls_classkey
        version           = seoc_version_active
      IMPORTING
        typepusages       = lt_typepusages
      EXCEPTIONS
        clif_not_existing = 1
        OTHERS            = 2.

    LOOP AT lt_typepusages INTO ls_typepusage.
      lo_typepusages = xmldoc->create_element( c_xml_key_typepusage ).
      setattributesfromstructure( node      = lo_typepusages
                                  structure = ls_typepusage ).
      l_rc = xo_rootnode->append_child( lo_typepusages ).
    ENDLOOP.

*ewH: for version 0.1.3, we will continue to generate both nodes
* in order for upgradeability of saplink itself.  For version
* 2.0, forwardDeclaration node generations will be deprecated.
    LOOP AT lt_typepusages INTO ls_typepusage.
      lo_typepusages = xmldoc->create_element( c_xml_key_forwarddeclaration ).
      l_string       = ls_typepusage-typegroup.
      l_rc = lo_typepusages->if_ixml_node~set_value( l_string ).
      l_rc = xo_rootnode->append_child( lo_typepusages ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
CLASS zsaplink_class IMPLEMENTATION.
  METHOD checkexists.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA classkey TYPE seoclskey.
    DATA not_active TYPE  seox_boolean.

    classkey-clsname = objname.

    CALL FUNCTION 'SEO_CLASS_EXISTENCE_CHECK'
      EXPORTING
        clskey       = classkey
      IMPORTING
        not_active   = not_active
      EXCEPTIONS
*       not_specified = 1
        not_existing = 2.
*      is_interface  = 3
*      no_text       = 4
*      inconsistent  = 5
*      others        = 6.

    IF sy-subrc <> 2.
      exists = 'X'.
    ENDIF.
  ENDMETHOD.
  METHOD createixmldocfromobject.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA localimplementation TYPE REF TO if_ixml_element.
    DATA localtypes TYPE REF TO if_ixml_element.
    DATA localmacros TYPE REF TO if_ixml_element.
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA reportlist TYPE STANDARD TABLE OF string.
    DATA includename TYPE program.
    DATA _classname TYPE seoclsname.
    DATA reportstring TYPE string.
    DATA rc TYPE sysubrc.
    DATA classdescr TYPE REF TO cl_abap_classdescr.
    DATA typedescr TYPE REF TO cl_abap_typedescr.
    DATA methoddescr TYPE abap_methdescr.
    DATA methodnode TYPE REF TO if_ixml_element.
    DATA parameternode TYPE REF TO if_ixml_element.
    DATA sourcenode TYPE REF TO if_ixml_element.
    DATA exceptionnode TYPE REF TO if_ixml_element.
    DATA exceptionlist TYPE seos_exceptions_r.
    DATA anexception TYPE vseoexcep.
    DATA inheritancenode TYPE REF TO if_ixml_element.
    DATA redefnode TYPE REF TO if_ixml_element.

    DATA tempstring TYPE string.
    DATA methodkey TYPE seocpdkey.
    DATA clsmethkey TYPE seocmpkey.
    DATA methodproperties TYPE vseomethod.
    DATA classkey TYPE seoclskey.
    DATA classproperties TYPE vseoclass.
    DATA paramdescr TYPE abap_parmdescr.
    DATA paramkey TYPE seoscokey.
    DATA paramproperties TYPE vseoparam.
    DATA superclass TYPE REF TO cl_abap_typedescr.
    DATA superclassname TYPE string.
    DATA superclasskey TYPE seorelkey.

    DATA attribdescr TYPE abap_attrdescr.
    DATA attribkey TYPE seocmpkey.
    DATA attribproperties TYPE vseoattrib.
    DATA attribnode TYPE REF TO if_ixml_element.
    DATA inheritanceprops TYPE vseoextend.
    DATA redefines TYPE STANDARD TABLE OF seoredef
        WITH KEY clsname refclsname version mtdname.
    DATA inheritance TYPE seor_inheritance_r.
    DATA redefinitions TYPE seor_redefinitions_r.
    DATA redefinition LIKE LINE OF redefinitions.

    DATA otrnode TYPE REF TO if_ixml_element.
    DATA _otrguid TYPE sotr_conc.

    DATA: ls_version_info TYPE gts_version_info.

    _classname = objname.
    classkey-clsname = objname.

*  setObjectType( ).

    DATA _objtype TYPE string.
*  _objType = objType.
    _objtype = getobjecttype( ).
    rootnode = xmldoc->create_element( _objtype ).
    CALL FUNCTION 'SEO_CLASS_GET'
      EXPORTING
        clskey       = classkey
        version      = '1'
      IMPORTING
        class        = classproperties
      EXCEPTIONS
        not_existing = 1
        deleted      = 2
        is_interface = 3
        model_only   = 4.

    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 1.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>not_found
              object = objname.
        WHEN 2.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'class deleted'.
        WHEN 3.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'interfaces not supported'.
        WHEN 4.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'class is modeled only'.
      ENDCASE.
    ENDIF.

    setattributesfromstructure( node      = rootnode
                                structure = classproperties ).
*--------------------------------------------------------------------*
* Added versioning info
*--------------------------------------------------------------------*
    ls_version_info = get_version_info( ).
    setattributesfromstructure( node      = rootnode
                                structure = ls_version_info ).

    TRY.
        CALL METHOD cl_abap_classdescr=>describe_by_name
          EXPORTING
            p_name         = objname
          RECEIVING
            p_descr_ref    = typedescr
          EXCEPTIONS
            type_not_found = 1.
        IF sy-subrc = 0.
          classdescr ?= typedescr.
        ELSE.

        ENDIF.
      CATCH cx_root.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>system_error.
    ENDTRY.

    CALL METHOD classdescr->get_super_class_type
      RECEIVING
        p_descr_ref           = superclass
      EXCEPTIONS
        super_class_not_found = 1.

    IF sy-subrc = 0.
      superclassname = superclass->get_relative_name( ).
      IF NOT superclassname CS 'OBJECT'.
        superclasskey-clsname = objname.
        superclasskey-refclsname = superclassname.
        CALL FUNCTION 'SEO_INHERITANC_GET'
          EXPORTING
            inhkey        = superclasskey
          IMPORTING
            inheritance   = inheritanceprops
            redefinitions = redefines.
        setattributesfromstructure( node = rootnode structure =
        inheritanceprops ).
      ENDIF.
    ENDIF.

*/***TPJ - Added Logic for TYPES  -------------------*/
    DATA: types      TYPE seoo_types_r,
          wa_type    LIKE LINE OF types,
          types_node TYPE REF TO if_ixml_element.
    CALL FUNCTION 'SEO_TYPE_READ_ALL'
      EXPORTING
        cifkey            = classkey
        version           = 1
      IMPORTING
        types             = types
      EXCEPTIONS
        clif_not_existing = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
    ENDIF.
    LOOP AT types INTO wa_type.
      types_node = xmldoc->create_element( 'types' ).
      CLEAR wa_type-typesrc_leng. " Will be recalculated on import, differs depending on OS due to linebreaks
      setattributesfromstructure( node = types_node structure =
      wa_type ).
      rc = rootnode->append_child( types_node ).
    ENDLOOP.
*/***TPJ - End of Added Logic for TYPES  -------------------*/

*/***TPJ - Added Logic for Friends  -------------------*/
    DATA: clif_keys    TYPE STANDARD TABLE OF seoclskey,
          friends      TYPE STANDARD TABLE OF seofriends,
          wa_friend    LIKE LINE OF friends,
          friends_node TYPE REF TO if_ixml_element.

    APPEND classkey TO clif_keys.
    CALL FUNCTION 'SEO_FRIENDS_SELECT'
      EXPORTING
        with_external_ref = 'X'
      TABLES
        clif_keys         = clif_keys
        friends_relations = friends.
    IF sy-subrc <> 0.
    ENDIF.
    LOOP AT friends INTO wa_friend.
      friends_node = xmldoc->create_element( c_xml_key_friends ).
      setattributesfromstructure( node = friends_node structure =
      wa_friend ).
      rc = rootnode->append_child( friends_node ).
    ENDLOOP.
*/***TPJ - End of Added Logic for Friends  -------------------*/

*/***ewH - Added Logic for Interfaces  -------------------*/
*/***uku - discard included interfaces -------------------*/
    DATA: it_implementings      TYPE seor_implementings_r,
          lt_implementings_copy TYPE seor_implementings_r,
          wa_implementings      LIKE LINE OF it_implementings,
          implementingnode      TYPE REF TO if_ixml_element,
          ls_interface          TYPE seoc_interface_r,
          lt_comprisings        TYPE seor_comprisings_r,
          ls_intfkey            TYPE seoclskey.
    FIELD-SYMBOLS <ls_comprisings> TYPE seor_comprising_r.

    CALL FUNCTION 'SEO_IMPLEMENTG_READ_ALL'
      EXPORTING
        clskey             = classkey
      IMPORTING
        implementings      = it_implementings
      EXCEPTIONS
        class_not_existing = 1
        OTHERS             = 2.

    lt_implementings_copy = it_implementings.
    LOOP AT it_implementings INTO wa_implementings.
      CLEAR: ls_intfkey.
      ls_intfkey-clsname = wa_implementings-refclsname.
      CALL FUNCTION 'SEO_INTERFACE_TYPEINFO_GET'
        EXPORTING
          intkey      = ls_intfkey
        IMPORTING
          comprisings = lt_comprisings.
      LOOP AT lt_comprisings ASSIGNING <ls_comprisings>.
        DELETE lt_implementings_copy WHERE refclsname = <ls_comprisings>-refclsname.
      ENDLOOP.
    ENDLOOP.

    LOOP AT lt_implementings_copy INTO wa_implementings.
      implementingnode = xmldoc->create_element( 'implementing' ).
      setattributesfromstructure( node = implementingnode structure =
      wa_implementings ).
      rc = rootnode->append_child( implementingnode ).
    ENDLOOP.
*/***uku - End of discard included interfaces -------------------*/
*/***ewH - End of Added Logic for Interfaces  -------------------*/
*/***rrq - Added Logic for EVENTS  -------------------*/
    DATA: events      TYPE seoo_events_r,
          wa_event    LIKE LINE OF events,
          event_node  TYPE REF TO if_ixml_element,
          eventkey    TYPE seocmpkey,
          eventparams TYPE seos_parameters_r,
          wa_params   TYPE seos_parameter_r.
    CALL FUNCTION 'SEO_EVENT_READ_ALL'
      EXPORTING
        cifkey            = classkey
        version           = 1
      IMPORTING
        events            = events
      EXCEPTIONS
        clif_not_existing = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
    ENDIF.
    LOOP AT events INTO wa_event.
      eventkey-clsname = wa_event-clsname.
      eventkey-cmpname = wa_event-cmpname.
      event_node = xmldoc->create_element( 'events' ).
      setattributesfromstructure( node = event_node structure =
      wa_event ).
      CALL FUNCTION 'SEO_EVENT_SIGNATURE_GET'
        EXPORTING
          evtkey     = eventkey
        IMPORTING
          parameters = eventparams.

*   parameters
      LOOP AT eventparams INTO wa_params.

        parameternode = xmldoc->create_element( 'parameter' ).
        setattributesfromstructure( node = parameternode
        structure = wa_params ).
        rc = event_node->append_child( parameternode ).
      ENDLOOP.
      rc = rootnode->append_child( event_node ).
    ENDLOOP.
*/***rrq - End of Added Logic for EVENTS  -------------------*/
* removed by Rene.
    get_sections( CHANGING rootnode = rootnode ) .
*|--------------------------------------------------------------------|
    includename = cl_oo_classname_service=>get_ccimp_name( _classname ).
    READ REPORT includename INTO reportlist.
    localimplementation = xmldoc->create_element( 'localImplementation' ).
    reportstring = buildsourcestring( sourcetable = reportlist ).
    rc = localimplementation->if_ixml_node~set_value( reportstring ).
*|--------------------------------------------------------------------|
    includename = cl_oo_classname_service=>get_ccdef_name( _classname ).
    READ REPORT includename INTO reportlist.
    localtypes = xmldoc->create_element( 'localTypes' ).
    reportstring = buildsourcestring( sourcetable = reportlist ).
    rc = localtypes->if_ixml_node~set_value( reportstring ).
*|--------------------------------------------------------------------|
    includename = cl_oo_classname_service=>get_ccmac_name( _classname ).
    READ REPORT includename INTO reportlist.
    localmacros = xmldoc->create_element( 'localMacros' ).
    reportstring = buildsourcestring( sourcetable = reportlist ).
    rc = localmacros->if_ixml_node~set_value( reportstring ).
*|--------------------------------------------------------------------|
*/***EVP - Added Logic for Local Test Classes  ----------------------*/
    DATA localtestclasses TYPE REF TO if_ixml_element.
    DATA localtestclassesexist TYPE i.

    includename = cl_oo_classname_service=>get_local_testclasses_include( _classname ).
    READ REPORT includename INTO reportlist.
    " If sy-subrc = 0 the local test classes do exist
    localtestclassesexist = sy-subrc.
    IF localtestclassesexist = 0.
      localtestclasses = xmldoc->create_element( 'localTestClasses' ).
      reportstring = buildsourcestring( sourcetable = reportlist ).
      rc = localtestclasses->if_ixml_node~set_value( reportstring ).
    ENDIF.
*/***EVP - End of Added Logic for Local Test Classes  ---------------*/
*|                                                                    |
*\--------------------------------------------------------------------/
    rc = rootnode->append_child( localimplementation ).
    rc = rootnode->append_child( localtypes ).
    rc = rootnode->append_child( localmacros ).
*/***EVP - Added Logic for Local Test Classes  -------------------*/
    IF localtestclassesexist = 0.
      rc = rootnode->append_child( localtestclasses ).
    ENDIF.
*/***EVP - End of Added Logic for Local Test Classes  ------------*/
**// Rich:  Start
    get_textpool( CHANGING rootnode = rootnode ).
    get_documentation( CHANGING rootnode = rootnode ).
**// Rich:  End
    get_typepusage( CHANGING  xo_rootnode = rootnode ).
    get_clsdeferrd( CHANGING  xo_rootnode = rootnode ).
    get_intdeferrd( CHANGING  xo_rootnode = rootnode ).

*  classDescriptor ?= cl_abap_typedescr=>describe_by_name( className ).
    attribkey-clsname = objname.

    LOOP AT classdescr->attributes INTO attribdescr
    WHERE is_inherited = abap_false
    AND is_interface = abap_false. "rrq:issue 46
      attribnode = xmldoc->create_element( 'attribute' ).
      attribkey-cmpname = attribdescr-name.
      CALL FUNCTION 'SEO_ATTRIBUTE_GET'
        EXPORTING
          attkey    = attribkey
        IMPORTING
          attribute = attribproperties.

*   include OTR if necessary (for exception classes)
      IF attribproperties-type = 'SOTR_CONC' AND attribproperties-attvalue
      IS NOT INITIAL.
        _otrguid = attribproperties-attvalue+1(32).
        otrnode = get_otr( _otrguid ).
        IF otrnode IS BOUND.
          rc = attribnode->append_child( otrnode ).
          " Issue #222 - get_text empty when ZCX_SAPLINK exception is raised
          " Gregor Wolf, 2012-12-20
          " As GUID for OTR Node is created new in every system we import
          " the Slinkee we should empty it
          CLEAR: attribproperties-attvalue.
        ENDIF.
      ENDIF.

*   append attribute node to parent node
      setattributesfromstructure( node      = attribnode
                                  structure = attribproperties ).
      rc = rootnode->append_child( attribnode ).
    ENDLOOP.

*// ewH: begin of logic for interface methods & inheritance redesign-->
* inheritances & redefinitions: old source removed-recover w/subversion
    CALL FUNCTION 'SEO_INHERITANC_READ'
      EXPORTING
        clskey             = classkey
      IMPORTING
        inheritance        = inheritance
        redefinitions      = redefinitions
      EXCEPTIONS
        class_not_existing = 1
        OTHERS             = 2.

    IF inheritance IS NOT INITIAL.
      inheritancenode = xmldoc->create_element( c_xml_key_inheritance ).
      setattributesfromstructure( node = inheritancenode structure =
      inheritance ).

      LOOP AT redefinitions INTO redefinition.
        redefnode = xmldoc->create_element( 'redefinition' ).
        setattributesfromstructure( node = redefnode structure =
        redefinition ).
        rc = inheritancenode->append_child( redefnode ).
      ENDLOOP.
      rc = rootnode->append_child( inheritancenode ).
    ENDIF.

* methods with out alias We handle this later
    LOOP AT classdescr->methods INTO methoddescr WHERE alias_for IS INITIAL AND
    NOT ( is_inherited = 'X' AND is_redefined IS INITIAL ).
      methodkey-clsname = _classname.
      methodkey-cpdname = methoddescr-name.
*//nbus: added logic for exception class
      IF    methoddescr-name         =  'CONSTRUCTOR'
        AND classproperties-category =  seoc_category_exception
        AND me->mv_steamroller       <> abap_true.
        " Constructor() will be generated automatically into the
        " target system once the class is saved
        CONTINUE.
      ENDIF.
*//nbus: end of added logic for exception class
*   interface methods
      IF methoddescr-is_interface = 'X'.
        CALL METHOD cl_oo_classname_service=>get_method_include
          EXPORTING
            mtdkey              = methodkey
          RECEIVING
            result              = includename
          EXCEPTIONS
            method_not_existing = 1.
        IF sy-subrc = 0.
          methodnode = xmldoc->create_element( 'interfaceMethod' ).
          setattributesfromstructure( node = methodnode structure =
          methodkey ).
          sourcenode = xmldoc->create_element( 'source' ).
*        tempString = includeName.
*        rc = sourceNode->set_attribute(
*          name = 'includeName' value = tempString ).
          READ REPORT includename INTO reportlist.
          reportstring = buildsourcestring( sourcetable = reportlist ).
          rc = sourcenode->if_ixml_node~set_value( reportstring ).
          rc = methodnode->append_child( sourcenode ).
          rc = rootnode->append_child( methodnode ).
        ENDIF.
*   other methods
      ELSE.
        clsmethkey-clsname = _classname.
        clsmethkey-cmpname = methoddescr-name.
        CLEAR methodproperties.

        IF methoddescr-is_redefined = 'X'.
          methodnode = xmldoc->create_element( 'method' ).
          MOVE-CORRESPONDING clsmethkey TO methodproperties.
*// ewh: begin of forward compatibility hack, can be removed for next
*//      major release-->
          READ TABLE redefinitions INTO redefinition
            WITH KEY mtdname = methoddescr-name.
          IF sy-subrc = 0.
            methodproperties-clsname = redefinition-refclsname.
          ENDIF.
*//<--ewH: end of forward compatibility hack
          setattributesfromstructure( node = methodnode structure =
          methodproperties ).
        ELSE.
          CALL FUNCTION 'SEO_METHOD_GET'
            EXPORTING
              mtdkey       = clsmethkey
            IMPORTING
              method       = methodproperties
            EXCEPTIONS
              not_existing = 1.
          IF sy-subrc = 0.
            methodnode = xmldoc->create_element( 'method' ).
            setattributesfromstructure( node = methodnode structure =
            methodproperties ).

*         parameters
            LOOP AT methoddescr-parameters INTO paramdescr.
              CLEAR paramproperties.
              parameternode = xmldoc->create_element( 'parameter' ).
              paramkey-cmpname = clsmethkey-cmpname.
              paramkey-sconame = paramdescr-name.
              paramkey-clsname = objname.
              CALL FUNCTION 'SEO_PARAMETER_GET'
                EXPORTING
                  parkey    = paramkey
                  version   = '1'
                IMPORTING
                  parameter = paramproperties.
              setattributesfromstructure( node = parameternode
              structure = paramproperties ).
              rc = methodnode->append_child( parameternode ).
            ENDLOOP.

*         exceptions
            CALL FUNCTION 'SEO_METHOD_SIGNATURE_GET'
              EXPORTING
                mtdkey  = clsmethkey
                version = '1'
              IMPORTING
                exceps  = exceptionlist.
            LOOP AT exceptionlist INTO anexception.
              exceptionnode = xmldoc->create_element( 'exception' ).
              setattributesfromstructure( node = exceptionnode
              structure = anexception ).
              rc = methodnode->append_child( exceptionnode ).
            ENDLOOP.
          ENDIF. "method found
        ENDIF. "is_redefined?
*     source
        CALL METHOD cl_oo_classname_service=>get_method_include
          EXPORTING
            mtdkey              = methodkey
          RECEIVING
            result              = includename
          EXCEPTIONS
            method_not_existing = 1.
        IF sy-subrc = 0.
          READ REPORT includename INTO reportlist.
          reportstring = buildsourcestring( sourcetable = reportlist ).
          sourcenode = xmldoc->create_element( 'source' ).
          rc = sourcenode->if_ixml_node~set_value( reportstring ).
          rc = methodnode->append_child( sourcenode ).
        ENDIF.
** StartInsert Rich - Handle method documenation
        get_method_documentation(  EXPORTING method_key = methodkey
                                   CHANGING  rootnode   = methodnode ).
** EndInsert Rich - Handle method documenation
        rc = rootnode->append_child( methodnode ).
      ENDIF. "is_interface?
    ENDLOOP.
* create alias info for load.
    get_alias_method( EXPORTING it_methods     = classdescr->methods
                      CHANGING  xo_rootnode    = rootnode ).
* append root node to xmldoc
    rc = xmldoc->append_child( rootnode ).
    ixmldocument = xmldoc.
*// <--ewH: end of logic for interface methods & inheritance redesign
  ENDMETHOD.
  METHOD createobjectfromixmldoc.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA classkey TYPE seoclskey.
    DATA filter TYPE REF TO if_ixml_node_filter.
    DATA iterator TYPE REF TO if_ixml_node_iterator.
    DATA node TYPE REF TO if_ixml_element.
    DATA otrnode TYPE REF TO if_ixml_element.
    DATA filter2 TYPE REF TO if_ixml_node_filter.
    DATA iterator2 TYPE REF TO if_ixml_node_iterator.
    DATA superclass TYPE vseoextend-clsname.
    DATA superclasskey TYPE vseoextend.
    DATA methodsourcenode TYPE REF TO if_ixml_node.
    DATA sourcenode TYPE REF TO if_ixml_node.
    DATA source TYPE string.
    DATA sourcetable TYPE TABLE OF string.
    DATA methodkey TYPE seocpdkey.
    DATA node2 TYPE REF TO if_ixml_element.
    DATA _objtype TYPE string.
    DATA aobjname TYPE e071-obj_name.
    DATA inheritancenode TYPE REF TO if_ixml_element.
    DATA redefnode TYPE REF TO if_ixml_element.
    DATA includename TYPE program.
    DATA mtdkey   TYPE seocpdkey.

*data excClass type ref to ZCX_SAPLINK.

*// --> begin of new data type rrq
    DATA:
*exporting dataTypes
      e_corrnr            TYPE trkorr,
      e_devclass          TYPE devclass,
      e_version           TYPE seoversion,
      e_genflag           TYPE genflag,
      e_authority_check   TYPE seox_boolean,
      e_overwrite         TYPE seox_boolean,
*e_suppress_meth_gen      type SEOX_BOOLEAN,
*e_suppress_refac_gen     type SEOX_BOOLEAN,
      e_method_sources    TYPE seo_method_source_table,
      e_locals_def        TYPE rswsourcet,
      e_locals_imp        TYPE rswsourcet,
      e_locals_mac        TYPE rswsourcet,
*e_suppress_ind_update    type SEOX_BOOLEAN,
*importing dataTypes
      i_korrnr            TYPE trkorr,
*changing dataTypes
      ch_class            TYPE vseoclass,
      ch_inheritance      TYPE vseoextend,
      ch_redefinitions    TYPE seor_redefinitions_r,
      ch_implementings    TYPE seor_implementings_r,
      ch_impl_details     TYPE seo_redefinitions,
      ch_attributes       TYPE seoo_attributes_r,
      ch_methods          TYPE seoo_methods_r,
      ch_events           TYPE seoo_events_r,
      ch_types            TYPE seoo_types_r,
      ch_type_source      TYPE seop_source,
      ch_type_source_temp TYPE seop_source,
      ch_parameters       TYPE seos_parameters_r,
      ch_exceps           TYPE seos_exceptions_r,
      ch_aliases          TYPE seoo_aliases_r,
      ch_typepusages      TYPE seot_typepusages_r,
      ch_clsdeferrds      TYPE seot_clsdeferrds_r,
      ch_intdeferrds      TYPE seot_intdeferrds_r,
      ch_friendships      TYPE seo_friends,
**table dataTypes
*tb_classDescription      type table of seoclasstx,
*tb_component_descr       type table of seocompotx,
*tb_subcomponent_descr    type table of seosubcotx,
* work areas for the tables
      wa_attributes       TYPE seoo_attribute_r,
      wa_types            TYPE seoo_type_r,
      wa_friends          TYPE seofriends,
      wa_implementings    TYPE seor_implementing_r,
      wa_redefinitions    TYPE seoredef,
      wa_methods          TYPE seoo_method_r,
      wa_parameters       TYPE seos_parameter_r,
      wa_exceps           TYPE seos_exception_r,
      wa_method_sources   TYPE seo_method_source,
      wa_events           TYPE seoo_event_r.
    DATA: lines TYPE i,
          l_msg TYPE string.
*//<-- end of new data types rrq

    CALL FUNCTION 'SEO_BUFFER_INIT'.

    e_devclass = devclass.
    _objtype = getobjecttype( ).
    e_overwrite = overwrite.
    xmldoc = ixmldocument.
    rootnode = xmldoc->find_from_name( _objtype ).

    CALL METHOD getstructurefromattributes
      EXPORTING
        node      = rootnode
      CHANGING
        structure = ch_class.

    objname = classkey-clsname = ch_class-clsname.
    ch_class-version = '0'.
    superclass = rootnode->get_attribute( name = 'REFCLSNAME' ).
    IF superclass IS NOT INITIAL.
* set something for inheritence
      superclasskey-clsname = classkey-clsname.
      superclasskey-refclsname = superclass.
      superclasskey-version = '0'.
      superclasskey-state = '1'.
      MOVE-CORRESPONDING superclasskey TO ch_inheritance.
      ch_inheritance-author = 'BCUSER'.
      ch_inheritance-createdon = sy-datum.
    ENDIF.

*Add attributes to new class
    DATA otrconcept TYPE sotr_text-concept.
    filter = xmldoc->create_filter_name( 'attribute' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
*   create OTR texts if necessary (for exception classes)
      CLEAR otrconcept.
      otrnode = node->find_from_name( c_xml_key_sotr ).
      IF otrnode IS NOT INITIAL.
*     ewH:33-->create new concept with new guid
*      me->createotrfromnode( otrnode ).
        me->create_otr(
          EXPORTING node = otrnode
          IMPORTING concept = otrconcept ).
      ENDIF.
      CLEAR wa_attributes.
*   create attribute
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_attributes.
      wa_attributes-version = '0'.
*   ewH:issue33-->6.40 and above, must create new concept
      IF otrconcept IS NOT INITIAL.
        CONCATENATE `'` otrconcept `'` INTO wa_attributes-attvalue.
      ENDIF.
      APPEND wa_attributes TO ch_attributes.
      node ?= iterator->get_next( ).
    ENDWHILE.

*/***TPJ - Added Logic for TYPES  -------------------*/
*  DATA: types           TYPE seoo_types_r,
*        type_properties LIKE LINE OF types.

    filter = xmldoc->create_filter_name( 'types' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR wa_types.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_types.
      wa_types-version = '0'.
      APPEND wa_types TO ch_types.
      node ?= iterator->get_next( ).
    ENDWHILE.
*/***TPJ - End of Added Logic for TYPES  -------------------*/

*/***TPJ - Added Logic for Friends  -------------------*/
*  DATA: wa_friends type seofriends.

    filter = xmldoc->create_filter_name( c_xml_key_friends ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR wa_friends.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_friends.
      wa_friends-version = '0'.
      APPEND wa_friends TO ch_friendships.
      node ?= iterator->get_next( ).
    ENDWHILE.
*/***TPJ - End of Added Logic for Friends  -------------------*/

*// ewH: Added Logic for Implementings(interfaces)-->
    filter = xmldoc->create_filter_name( 'implementing' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR wa_implementings.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_implementings.
      APPEND wa_implementings TO ch_implementings.
      node ?= iterator->get_next( ).
    ENDWHILE.
*//<--ewH: End of Added Logic for Implementings(interfaces)

*// rrq: Added Logic for events-->
    filter = xmldoc->create_filter_name( 'events' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR wa_events.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_events.
      APPEND wa_events TO ch_events.
      filter2 = node->create_filter_name( 'parameter' ).
      iterator2 = node->create_iterator_filtered( filter2 ).
      node2 ?= iterator2->get_next( ).
      WHILE node2 IS NOT INITIAL.
        CLEAR wa_parameters.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = node2
          CHANGING
            structure = wa_parameters.

        "//-> Mar: Added logic for parameter/interface implementation - 08/20/2008
        IF NOT wa_parameters-clsname IS INITIAL.
          APPEND wa_parameters TO ch_parameters.
        ENDIF.
        "//<- Mar: Added logic for parameter/interface implementation - 08/20/2008

        node2 ?= iterator2->get_next( ).
      ENDWHILE.
      node ?= iterator->get_next( ).
    ENDWHILE.
*//<--rrq: End of Added Logic for events

*// ewH: start redesign method/inheritances-->
* inheritance
    inheritancenode = rootnode->find_from_name( c_xml_key_inheritance ).
    IF inheritancenode IS BOUND.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = inheritancenode
        CHANGING
          structure = ch_inheritance.
*   redefs
      filter = inheritancenode->create_filter_name( 'redefinition' ).
      iterator = inheritancenode->create_iterator_filtered( filter ).
      redefnode ?= iterator->get_next( ).
      WHILE redefnode IS NOT INITIAL.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = redefnode
          CHANGING
            structure = wa_redefinitions.
        APPEND wa_redefinitions TO ch_redefinitions.
        redefnode ?= iterator->get_next( ).
      ENDWHILE.
    ENDIF.

*Add Methods to new class
    filter = xmldoc->create_filter_name( 'method' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CLEAR wa_methods.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_methods.

*   only create metadata if method is not a redefinition
      READ TABLE ch_redefinitions INTO wa_redefinitions
      WITH KEY mtdname = wa_methods-cmpname.
      IF sy-subrc = 0.
        node ?= iterator->get_next( ).
        CONTINUE.
      ENDIF.
*// ewh: begin of backward compatibility hack, can be removed for next
*//      major release-->
      IF wa_methods-clsname <> ch_class-clsname.
        MOVE-CORRESPONDING wa_methods TO wa_redefinitions.
        wa_redefinitions-clsname = ch_class-clsname.
        wa_redefinitions-refclsname = wa_methods-clsname.
        wa_redefinitions-version = '0'.
        wa_redefinitions-mtdabstrct = ''.
        wa_redefinitions-mtdname = wa_methods-cmpname.
        APPEND wa_redefinitions TO ch_redefinitions.

        node ?= iterator->get_next( ).
        CONTINUE.
      ENDIF.
*// <--ewH: break in backward compatibility hack - 2Bcontinued below

      filter2 = node->create_filter_name( 'parameter' ).
      iterator2 = node->create_iterator_filtered( filter2 ).
      node2 ?= iterator2->get_next( ).
      WHILE node2 IS NOT INITIAL.
        CLEAR wa_parameters.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = node2
          CHANGING
            structure = wa_parameters.

        "//-> Mar: Added logic for parameter/interface implementation - 08/20/2008
        IF NOT wa_parameters-clsname IS INITIAL.
          APPEND wa_parameters TO ch_parameters.
        ENDIF.
        "//<- Mar: Added logic for parameter/interface implementation - 08/20/2008

        node2 ?= iterator2->get_next( ).
      ENDWHILE.
      filter2 = node->create_filter_name( 'exception' ).
      iterator2 = node->create_iterator_filtered( filter2 ).
      node2 ?= iterator2->get_next( ).
      WHILE node2 IS NOT INITIAL.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = node2
          CHANGING
            structure = wa_exceps.
        APPEND wa_exceps TO ch_exceps.
        node2 ?= iterator2->get_next( ).
      ENDWHILE.
      APPEND wa_methods TO ch_methods.

** StartInsert Rich - Handle method documenation
      create_method_documentation( node = node ).
** EndInsert Rich - Handle method documenation

      node ?= iterator->get_next( ).
    ENDWHILE.
*// <--ewH: end redesign method/inheritances
*// ewh: continuation of backward compatibility hack-->
*  IF ( ch_redefinitions IS NOT INITIAL OR superclass-clsname
*  IS NOT INITIAL ) and ch_inheritance is initial.
*    CALL FUNCTION 'SEO_INHERITANC_CREATE_F_DATA'
*      EXPORTING
*        save          = ' '
*      CHANGING
*        inheritance   = superclasskey
*        redefinitions = ch_redefinitions.
*  ENDIF.
*// <--ewH: end of backward compatibility hack

    create_typepusage( CHANGING xt_typepusages = ch_typepusages ).
    create_clsdeferrd( CHANGING xt_clsdeferrds = ch_clsdeferrds ).
    create_intdeferrd( CHANGING xt_intdeferrds = ch_intdeferrds ).

*Insert source code into the methods
    filter = xmldoc->create_filter_name( 'method' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = wa_methods.
      methodkey-clsname = objname.
      methodkey-cpdname = wa_methods-cmpname.
      aobjname = methodkey.
      methodsourcenode = node->find_from_name( 'source' ).
      IF methodsourcenode IS NOT INITIAL.
        CLEAR wa_method_sources.
        source = methodsourcenode->get_value( ).
        sourcetable = buildtablefromstring( source ).
        READ TABLE ch_redefinitions INTO wa_redefinitions
        WITH KEY mtdname = methodkey-cpdname.
        IF sy-subrc = 0.
          wa_method_sources-redefine = 'X'.
        ENDIF.
        wa_method_sources-cpdname = methodkey-cpdname.
        wa_method_sources-source = sourcetable.
        APPEND wa_method_sources TO e_method_sources.
      ENDIF.
      node ?= iterator->get_next( ).
    ENDWHILE.
*
**// ewH: create interface methods-->
    filter = xmldoc->create_filter_name( 'interfaceMethod' ).
    iterator = xmldoc->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).

    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = methodkey.
      aobjname = methodkey.
      methodsourcenode = node->find_from_name( 'source' ).
      IF methodsourcenode IS NOT INITIAL.
        CLEAR wa_method_sources.
        source = methodsourcenode->get_value( ).
        sourcetable = buildtablefromstring( source ).
        wa_method_sources-cpdname = methodkey-cpdname.
        READ TABLE ch_redefinitions INTO wa_redefinitions
        WITH KEY mtdname = methodkey-cpdname.
        IF sy-subrc = 0.
          wa_method_sources-redefine = 'X'.
        ENDIF.
*      wa_method_sources-redefine = wa_methods-redefin.
        wa_method_sources-source = sourcetable.

        APPEND wa_method_sources TO e_method_sources.
      ENDIF.

      node ?= iterator->get_next( ).
    ENDWHILE.
*// <--ewH: end create interface methods

* local implementation
    DATA _classname TYPE seoclsname.
    _classname = objname.
    sourcenode = xmldoc->find_from_name( 'localImplementation' ).
    IF sourcenode IS NOT INITIAL.
      source = sourcenode->get_value( ).
      e_locals_imp = buildtablefromstring( source ).
    ENDIF.

* local types
    sourcenode = xmldoc->find_from_name( 'localTypes' ).
    IF sourcenode IS NOT INITIAL.
      source = sourcenode->get_value( ).
      e_locals_def = buildtablefromstring( source ).
    ENDIF.

* local macros
    sourcenode = xmldoc->find_from_name( 'localMacros' ).
    IF sourcenode IS NOT INITIAL.
      source = sourcenode->get_value( ).
      e_locals_mac = buildtablefromstring( source ).
    ENDIF.
* We don't need the sections for now. Code moved by Rene
    create_sections( ).

*Add Alias to new class
    create_alias_method( CHANGING xt_aliases_method = ch_aliases ).

    name = objname.

    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
        corrnr          = e_corrnr
        devclass        = e_devclass
        version         = e_version
        genflag         = e_genflag
        authority_check = e_authority_check
        overwrite       = e_overwrite
*       SUPPRESS_METHOD_GENERATION         = e_suppress_meth_gen
*       SUPPRESS_REFACTORING_SUPPORT       = e_suppress_refac_gen
*       method_sources  = e_method_sources
        locals_def      = e_locals_def
        locals_imp      = e_locals_imp
        locals_mac      = e_locals_mac
*       SUPPRESS_INDEX_UPDATE              = e_suppress_ind_update
      IMPORTING
        korrnr          = i_korrnr
* TABLES
*       CLASS_DESCRIPTIONS                 = tb_classDescription
*       COMPONENT_DESCRIPTIONS             = tb_component_descr
*       SUBCOMPONENT_DESCRIPTIONS          = tb_subcomponent_descr
      CHANGING
        class           = ch_class
        inheritance     = ch_inheritance
        redefinitions   = ch_redefinitions
        implementings   = ch_implementings
        impl_details    = ch_impl_details
        attributes      = ch_attributes
        methods         = ch_methods
        events          = ch_events
        types           = ch_types
*       TYPE_SOURCE     = ch_type_source "???
        parameters      = ch_parameters
        exceps          = ch_exceps
        aliases         = ch_aliases
        typepusages     = ch_typepusages
        clsdeferrds     = ch_clsdeferrds
        intdeferrds     = ch_intdeferrds
        friendships     = ch_friendships
      EXCEPTIONS
        existing        = 1
        is_interface    = 2
        db_error        = 3
        component_error = 4
        no_access       = 5
        other           = 6
        OTHERS          = 7.
    CASE sy-subrc.
      WHEN '0'.
** i guess if we made it this far, we will assume success
** successful install
      WHEN '1'.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>existing.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>system_error.
    ENDCASE.
* Now let's add the methods
    LOOP AT e_method_sources INTO wa_method_sources.
      mtdkey-clsname = objname.
      mtdkey-cpdname = wa_method_sources-cpdname.

      CALL FUNCTION 'SEO_METHOD_GENERATE_INCLUDE'
        EXPORTING
          mtdkey                         = mtdkey
          version                        = e_version
          force                          = e_overwrite
          redefine                       = wa_method_sources-redefine
*         SUPPRESS_CORR                  = SEOX_FALSE
          implementation_expanded        = wa_method_sources-source
*         IMPLEMENTATION                 =
          suppress_mtdkey_check          = seox_true
*         EDITOR_LOCK                    = SEOX_FALSE
*         GENERATED                      = SEOX_FALSE
          corrnr                         = e_corrnr
          without_method_frame           = seox_true
*         WITH_SUPER_CALL                = SEOX_FALSE
*         SUPPRESS_INDEX_UPDATE          = SEOX_FALSE
*         EXTEND                         = SEOX_FALSE
*         ENHANCEMENT                    = ' '
*         SUPPRESS_MODIFICATION_SUPPORT  = SEOX_FALSE
        EXCEPTIONS
          not_existing                   = 1
          model_only                     = 2
          include_existing               = 3
          method_imp_not_generated       = 4
          method_imp_not_initialised     = 5
          _internal_class_not_existing   = 6
          _internal_method_overflow      = 7
          cancelled                      = 8
          method_is_abstract_implemented = 9
          method_is_final_implemented    = 10
          internal_error_insert_report   = 11
          OTHERS                         = 12.
      CASE sy-subrc.
        WHEN '0'.
** i guess if we made it this far, we will assume success
** successful install
        WHEN '3'.
          l_msg = mtdkey.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>existing
              msg    = l_msg.
        WHEN OTHERS.
          l_msg = mtdkey.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>system_error
              msg    = l_msg.
      ENDCASE.
    ENDLOOP.

*ewH:insert pub, prot, and priv sections manually to keep any direct
* attribute/type definitions
    aobjname = classkey-clsname.
**public
    sourcenode = xmldoc->find_from_name( 'publicSection' ).
    IF sourcenode IS NOT INITIAL.
      includename = cl_oo_classname_service=>get_pubsec_name( _classname ).
      source = sourcenode->get_value( ).
      sourcetable = buildtablefromstring( source ).
      INSERT REPORT includename FROM sourcetable EXTENSION TYPE
      srext_ext_class_public STATE 'I'.
    ENDIF.

**protected
    sourcenode = xmldoc->find_from_name( 'protectedSection' ).
    IF sourcenode IS NOT INITIAL.
      includename = cl_oo_classname_service=>get_prosec_name( _classname ).
      source = sourcenode->get_value( ).
      sourcetable = buildtablefromstring( source ).
      INSERT REPORT includename FROM sourcetable EXTENSION TYPE
      srext_ext_class_protected STATE 'I'.
    ENDIF.

**private
    sourcenode = xmldoc->find_from_name( 'privateSection' ).
    IF sourcenode IS NOT INITIAL.
      includename = cl_oo_classname_service=>get_prisec_name( _classname ).
      source = sourcenode->get_value( ).
      sourcetable = buildtablefromstring( source ).
      INSERT REPORT includename FROM sourcetable EXTENSION TYPE
      srext_ext_class_private STATE 'I'.
    ENDIF.
*/***EVP - Added Logic for Local Test Classes  -------------------*/
**local test classes
    sourcenode = xmldoc->find_from_name( 'localTestClasses' ).
    IF sourcenode IS NOT INITIAL.
      DATA clskey TYPE seoclskey.
      source = sourcenode->get_value( ).
      sourcetable = buildtablefromstring( source ).

      clskey-clsname = _classname.
      CALL FUNCTION 'SEO_CLASS_GENERATE_LOCALS'
        EXPORTING
          clskey                 = clskey
          force                  = overwrite
          locals_testclasses     = sourcetable
        EXCEPTIONS
          not_existing           = 1
          model_only             = 2
          locals_not_generated   = 3
          locals_not_initialised = 4
          OTHERS                 = 5.
      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.
*/***EVP - End Of Added Logic for Local Test Classes  -------------------*/

**// Rich:  Start
* Create class textpool
    create_textpool( ).

    create_documentation( ).
**// Rich:  End

* insert inactive sections into worklist
    CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
      EXPORTING
        object            = 'CPUB'
        obj_name          = aobjname
      EXCEPTIONS
        wrong_object_name = 1.
    IF sy-subrc <> 0.
    ENDIF.

    CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
      EXPORTING
        object            = 'CPRO'
        obj_name          = aobjname
      EXCEPTIONS
        wrong_object_name = 1.
    IF sy-subrc <> 0.
    ENDIF.

    CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
      EXPORTING
        object            = 'CPRI'
        obj_name          = aobjname
      EXCEPTIONS
        wrong_object_name = 1.
    IF sy-subrc <> 0.
    ENDIF.


  ENDMETHOD.
  METHOD create_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA txtline_node     TYPE REF TO if_ixml_element.
    DATA txtline_filter   TYPE REF TO if_ixml_node_filter.
    DATA txtline_iterator TYPE REF TO if_ixml_node_iterator.

    DATA docnode          TYPE REF TO if_ixml_element.

    DATA lang_node        TYPE REF TO if_ixml_element.
    DATA lang_filter      TYPE REF TO if_ixml_node_filter.
    DATA lang_iterator    TYPE REF TO if_ixml_node_iterator.

    DATA obj_name TYPE dokhl-object.
    DATA class_name TYPE string.
    DATA language  TYPE string.
    DATA obj_langu TYPE dokhl-langu.
    DATA lv_str TYPE string.
    DATA rc TYPE sy-subrc.

    DATA lt_lines  TYPE TABLE OF tline.
    FIELD-SYMBOLS: <ls_lines> LIKE LINE OF lt_lines.

    docnode = xmldoc->find_from_name( c_xml_key_class_documentation ).

    IF docnode IS NOT BOUND.
      RETURN.
    ENDIF.

    class_name = docnode->get_attribute( name = c_xml_key_object ).
    obj_name = class_name.

* If no class name, then there was no class documenation, just return.
    IF class_name IS INITIAL.
      RETURN.
    ENDIF.

* Get languages from XML
    FREE: lang_filter, lang_iterator, lang_node.
    lang_filter = docnode->create_filter_name( c_xml_key_language ).
    lang_iterator = docnode->create_iterator_filtered( lang_filter ).
    lang_node ?= lang_iterator->get_next( ).
    WHILE lang_node IS NOT INITIAL.

      REFRESH lt_lines.
      language = lang_node->get_attribute( name = c_xml_key_spras ).
      obj_langu = language.

* Get TextLines from XML
      FREE: txtline_filter, txtline_iterator, txtline_node.
      txtline_filter = lang_node->create_filter_name( c_xml_key_textline ).
      txtline_iterator = lang_node->create_iterator_filtered( txtline_filter ).
      txtline_node ?= txtline_iterator->get_next( ).
      WHILE txtline_node IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_lines ASSIGNING <ls_lines>.
        me->getstructurefromattributes(
                EXPORTING   node      = txtline_node
                CHANGING    structure = <ls_lines> ).
        txtline_node ?= txtline_iterator->get_next( ).
      ENDWHILE.

* Delete any documentation that may currently exist.
      CALL FUNCTION 'DOCU_DEL'
        EXPORTING
          id       = 'CL'
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.

* Now update with new documentation text
      CALL FUNCTION 'DOCU_UPD'
        EXPORTING
          id       = 'CL'
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        TABLES
          line     = lt_lines
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>error_message
            msg    = `Class Documentation object import failed`.
      ENDIF.

      lang_node ?= lang_iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_method_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA txtline_node     TYPE REF TO if_ixml_element.
    DATA txtline_filter   TYPE REF TO if_ixml_node_filter.
    DATA txtline_iterator TYPE REF TO if_ixml_node_iterator.

    DATA: methdocnode     TYPE REF TO if_ixml_element.

    DATA lang_node        TYPE REF TO if_ixml_element.
    DATA lang_filter      TYPE REF TO if_ixml_node_filter.
    DATA lang_iterator    TYPE REF TO if_ixml_node_iterator.

    DATA obj_name TYPE dokhl-object.
    DATA classmeth_name TYPE string.
    DATA language  TYPE string.
    DATA obj_langu TYPE dokhl-langu.
    DATA lv_str TYPE string.
    DATA rc TYPE sy-subrc.

    DATA lt_lines  TYPE TABLE OF tline.
    FIELD-SYMBOLS: <ls_lines> LIKE LINE OF lt_lines.

    methdocnode = node->find_from_name( 'methodDocumentation' ).

    IF methdocnode IS NOT BOUND.
      RETURN.
    ENDIF.

    classmeth_name = methdocnode->get_attribute( name = 'OBJECT' ).
    obj_name = classmeth_name.

* If no class method name, then there was no class method documenation, just return.
    IF classmeth_name IS INITIAL.
      RETURN.
    ENDIF.

* Get languages from XML
    FREE: lang_filter, lang_iterator, lang_node.
    lang_filter = methdocnode->create_filter_name( `language` ).
    lang_iterator = methdocnode->create_iterator_filtered( lang_filter ).
    lang_node ?= lang_iterator->get_next( ).
    WHILE lang_node IS NOT INITIAL.

      REFRESH lt_lines.
      language = lang_node->get_attribute( name = 'SPRAS' ).
      obj_langu = language.

* Get TextLines from XML
      FREE: txtline_filter, txtline_iterator, txtline_node.
      txtline_filter = lang_node->create_filter_name( `textLine` ).
      txtline_iterator = lang_node->create_iterator_filtered( txtline_filter ).
      txtline_node ?= txtline_iterator->get_next( ).
      WHILE txtline_node IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_lines ASSIGNING <ls_lines>.
        me->getstructurefromattributes(
                EXPORTING   node      = txtline_node
                CHANGING    structure = <ls_lines> ).
        txtline_node ?= txtline_iterator->get_next( ).
      ENDWHILE.

* Delete any documentation that may currently exist.
      CALL FUNCTION 'DOCU_DEL'
        EXPORTING
          id       = 'CO'
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.

* Now update with new documentation text
      CALL FUNCTION 'DOCU_UPD'
        EXPORTING
          id       = 'CO'
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        TABLES
          line     = lt_lines
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>error_message
            msg    = `Class Method Documentation object import failed`.
      ENDIF.

      lang_node ?= lang_iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_sections.

*ewH-not sure how this type_source param works. type sources can come
* from private or protected sections, but there is no way to pass
* these separately into the class create FM. After debugging into
* FM->clif_save_all->generate_classpool it treats the source table
* as one, so I am not sure how to get it to differentiate between
* private and protected sections. If only one section has types
* defined, the FM call works, otherwise all hell breaks loose. To
* solve the problem for now, we will just do an insert report for
* the sections after the class creation, since that's all the FM
* does in the end anyway. Wow, this is a really long comment, but
* I dont want to have to try to remember what the hell was going
* on here later...sorry.  :)
*insert code for publicSection
*  sourcenode = xmldoc->find_from_name( 'publicSection' )
*  IF sourcenode IS NOT INITIAL.
*    source = sourcenode->get_value( ).
*    ch_type_source = buildtablefromstring( source ).
*  ENDIF.
**insert code for pivateSection
*  sourcenode = xmldoc->find_from_name( 'privateSection' ).
*  IF sourcenode IS NOT INITIAL.
*    source = sourcenode->get_value( ).
*    ch_type_source_temp = buildtablefromstring( source ).
*    append lines of ch_type_source_temp to ch_type_source.
*  ENDIF.
**insert code for ProtectedSection
*  sourcenode = xmldoc->find_from_name( 'protectedSection' ).
*  IF sourcenode IS NOT INITIAL.
*    source = sourcenode->get_value( ).
*    ch_type_source_temp = buildtablefromstring( source ).
*    append lines of ch_type_source_temp to ch_type_source.
*  ENDIF.

  ENDMETHOD.
  METHOD create_textpool.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA textpooltable TYPE STANDARD TABLE OF textpool.
    DATA textpoolrow TYPE textpool.
    DATA langiterator TYPE REF TO if_ixml_node_iterator.
    DATA filter TYPE REF TO if_ixml_node_filter.
    DATA textfilter TYPE REF TO if_ixml_node_filter.
    DATA textiterator TYPE REF TO if_ixml_node_iterator.
    DATA textpoolnode TYPE REF TO if_ixml_element.
    DATA langnode TYPE REF TO if_ixml_element.
    DATA atextnode TYPE REF TO if_ixml_element.
    DATA _objname TYPE trobj_name.
    DATA obj_name TYPE seoclsname.
    DATA lang TYPE spras.
    DATA langnodeexists TYPE flag.
*  data logonLanguageExists type flag.                  " del #255 - seemingly not used
    DATA _state(1) TYPE c.
    DATA classpoolname TYPE program.
    DATA lv_original_language TYPE sylangu.                " ins #255

    textpoolnode = xmldoc->find_from_name( 'textPool' ).

    IF textpoolnode IS NOT BOUND.
      RETURN.
    ENDIF.

*--------------------------------------------------------------------*
* Ticket #255 - Error importing texts when logon language different
*               then original language of class
*--------------------------------------------------------------------*
    textpoolnode = xmldoc->find_from_name( 'CLAS' ).              " ins #255
    lv_original_language = textpoolnode->get_attribute( 'LANGU' )." ins #255
    SET LANGUAGE lv_original_language. " ins #255
    " Gregor Wolf: With this all languages from the Nugget/Slinkee are imported

    obj_name = objname.
    classpoolname = cl_oo_classname_service=>get_classpool_name( obj_name ).
    _objname = classpoolname.

    filter = textpoolnode->create_filter_name( 'language' ).
    langiterator = textpoolnode->create_iterator_filtered( filter ).
    langnode ?= langiterator->get_next( ).

    WHILE langnode IS NOT INITIAL.
      langnodeexists = 'X'.

      CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
        EXPORTING
          object   = 'REPT'
          obj_name = _objname
        EXCEPTIONS
          OTHERS   = 0.
      REFRESH textpooltable.
      textiterator = langnode->create_iterator( ).
      atextnode ?= textiterator->get_next( ).
*For some reason the 1st one is blank... not sure why.
      atextnode ?= textiterator->get_next( ).
      WHILE atextnode IS NOT INITIAL.
        getstructurefromattributes(
          EXPORTING
            node            = atextnode
          CHANGING
            structure       = textpoolrow
        ).
        APPEND textpoolrow TO textpooltable.
        atextnode ?= textiterator->get_next( ).
      ENDWHILE.
      IF textpooltable IS NOT INITIAL.
        lang = langnode->get_attribute( 'SPRAS' ).
*      if lang = sy-langu.                " del #255 - replaced by original language
        IF lang = lv_original_language.    " ins #255 - replaced former coding
*        logonLanguageExists = 'X'.
          _state = 'I'.
        ELSE.
*       seems that if a textpool is inserted as inactive for language
*       other than the logon language, it is lost upon activation
*       not sure inserting as active is best solution,but seems to work
*       Stefan Schmöcker:  Looks like this does not trigger on logon- " ins #255
*                          but on class original language             " ins #255
          _state = 'A'.
        ENDIF.
        INSERT TEXTPOOL _objname
          FROM textpooltable
          LANGUAGE lang
          STATE    _state.
      ENDIF.
      langnode ?= langiterator->get_next( ).
    ENDWHILE.
  ENDMETHOD.
  METHOD deleteobject.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA clskey TYPE seoclskey.

    clskey-clsname = objname.
    CALL FUNCTION 'SEO_CLASS_DELETE_W_DEPS'
      EXPORTING
        clskey       = clskey
      EXCEPTIONS
        not_existing = 1
        is_interface = 2
        not_deleted  = 3
        db_error     = 4
        OTHERS       = 5.
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 1.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>not_found.
        WHEN 2.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'interfaces not supported'.
        WHEN 3.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'class not deleted'.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>system_error.
      ENDCASE.
    ENDIF.
  ENDMETHOD.
  METHOD findimplementingclass.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA methodkey TYPE seocmpkey.
    DATA methodproperties TYPE vseomethod.
    DATA classdescr TYPE REF TO cl_abap_classdescr.
    DATA superclass TYPE REF TO cl_abap_typedescr.
    DATA superclassname TYPE string.

    IF startclass IS INITIAL.
      methodkey-clsname = objname.
    ELSE.
      methodkey-clsname = startclass.
    ENDIF.
    methodkey-cmpname = methodname.

    CALL FUNCTION 'SEO_METHOD_GET'
      EXPORTING
        mtdkey       = methodkey
      IMPORTING
        method       = methodproperties
      EXCEPTIONS
        not_existing = 1.
    IF sy-subrc = 0.
      classname = methodproperties-clsname.
    ELSE.
      classdescr ?= cl_abap_classdescr=>describe_by_name(
      methodkey-clsname ).
      CALL METHOD classdescr->get_super_class_type
        RECEIVING
          p_descr_ref           = superclass
        EXCEPTIONS
          super_class_not_found = 1.
      superclassname = superclass->get_relative_name( ).
      classname = findimplementingclass( methodname = methodname
      startclass = superclassname ).
    ENDIF.
  ENDMETHOD.
  METHOD getobjecttype.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/

    objecttype = 'CLAS'.  "Class

  ENDMETHOD.
  METHOD get_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA languagenode   TYPE REF TO if_ixml_element.
    DATA docnode       TYPE REF TO if_ixml_element.
    DATA txtlines_node TYPE REF TO if_ixml_element.
    DATA rc            TYPE sysubrc.
    DATA _objtype      TYPE string.

    TYPES: BEGIN OF t_dokhl,
             id         TYPE dokhl-id,
             object     TYPE dokhl-object,
             langu      TYPE dokhl-langu,
             typ        TYPE dokhl-typ,
             dokversion TYPE dokhl-dokversion,
           END OF t_dokhl.

    DATA lt_dokhl TYPE TABLE OF t_dokhl.
    DATA ls_dokhl LIKE LINE OF lt_dokhl.

    DATA lt_lines TYPE TABLE OF tline.
    DATA ls_lines LIKE LINE OF lt_lines.

    DATA lv_str TYPE string.
    DATA _objname TYPE e071-obj_name.

    _objname = objname.

* Check against database
    SELECT  id object langu typ dokversion
          INTO CORRESPONDING FIELDS OF TABLE lt_dokhl
             FROM dokhl
               WHERE id = 'CL'
                  AND object = _objname.

* Use only most recent version.
    SORT lt_dokhl BY id object langu typ ASCENDING dokversion DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_dokhl COMPARING id object typ langu.

* Make sure there is at least one record here.
    CLEAR ls_dokhl.
    READ TABLE lt_dokhl INTO ls_dokhl INDEX 1.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    docnode = xmldoc->create_element( c_xml_key_class_documentation ).

* Set docNode object attribute
    lv_str = ls_dokhl-object.
    rc = docnode->set_attribute( name = c_xml_key_object value = lv_str ).

    LOOP AT lt_dokhl INTO ls_dokhl.

* Create language node, and set attribute
      languagenode = xmldoc->create_element( c_xml_key_language ).
      lv_str = ls_dokhl-langu.
      rc = languagenode->set_attribute( name = c_xml_key_spras value = lv_str ).

* Read the documentation text
      CALL FUNCTION 'DOCU_READ'
        EXPORTING
          id      = ls_dokhl-id
          langu   = ls_dokhl-langu
          object  = ls_dokhl-object
          typ     = ls_dokhl-typ
          version = ls_dokhl-dokversion
        TABLES
          line    = lt_lines.

* Write records to XML node
      LOOP AT lt_lines INTO ls_lines.
        txtlines_node = xmldoc->create_element( c_xml_key_textline ).
        me->setattributesfromstructure( node = txtlines_node structure = ls_lines ).
        rc = languagenode->append_child( txtlines_node ).
      ENDLOOP.
      rc = docnode->append_child( languagenode ) .
    ENDLOOP.

    rc = rootnode->append_child( docnode ).

  ENDMETHOD.
  METHOD get_method_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA languagenode   TYPE REF TO if_ixml_element.
    DATA docnode        TYPE REF TO if_ixml_element.
    DATA txtlines_node TYPE REF TO if_ixml_element.
    DATA rc            TYPE sysubrc.
    DATA _objtype      TYPE string.

    TYPES: BEGIN OF t_dokhl,
             id         TYPE dokhl-id,
             object     TYPE dokhl-object,
             langu      TYPE dokhl-langu,
             typ        TYPE dokhl-typ,
             dokversion TYPE dokhl-dokversion,
           END OF t_dokhl.

    DATA lt_dokhl TYPE TABLE OF t_dokhl.
    DATA ls_dokhl LIKE LINE OF lt_dokhl.

    DATA lt_lines TYPE TABLE OF tline.
    DATA ls_lines LIKE LINE OF lt_lines.

    DATA lv_str TYPE string.
    DATA _objname TYPE e071-obj_name.

    _objname = method_key.

* Check against database
    SELECT  id object langu typ dokversion
          INTO CORRESPONDING FIELDS OF TABLE lt_dokhl
             FROM dokhl
               WHERE id = 'CO'
                  AND object = _objname.

* Use only most recent version.
    SORT lt_dokhl BY id object langu typ ASCENDING dokversion DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_dokhl COMPARING id object typ langu.

* Make sure there is at least one record here.
    CLEAR ls_dokhl.
    READ TABLE lt_dokhl INTO ls_dokhl INDEX 1.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    docnode = xmldoc->create_element( c_xml_key_method_documentation ).

* Set docNode object attribute
    lv_str = ls_dokhl-object.
    rc = docnode->set_attribute( name = c_xml_key_object value = lv_str ).

    LOOP AT lt_dokhl INTO ls_dokhl.

* Create language node, and set attribute
      languagenode = xmldoc->create_element( c_xml_key_language ).
      lv_str = ls_dokhl-langu.
      rc = languagenode->set_attribute( name = c_xml_key_spras value = lv_str ).

* Read the documentation text
      CALL FUNCTION 'DOCU_READ'
        EXPORTING
          id      = ls_dokhl-id
          langu   = ls_dokhl-langu
          object  = ls_dokhl-object
          typ     = ls_dokhl-typ
          version = ls_dokhl-dokversion
        TABLES
          line    = lt_lines.

* Write records to XML node
      LOOP AT lt_lines INTO ls_lines.
        txtlines_node = xmldoc->create_element( c_xml_key_textline ).
        me->setattributesfromstructure( node = txtlines_node structure = ls_lines ).
        rc = languagenode->append_child( txtlines_node ).
      ENDLOOP.
      rc = docnode->append_child( languagenode ) .
    ENDLOOP.

    rc = rootnode->append_child( docnode ).

  ENDMETHOD.
  METHOD get_sections.
    DATA publicsection TYPE REF TO if_ixml_element.
    DATA protectedsection TYPE REF TO if_ixml_element.
    DATA privatesection TYPE REF TO if_ixml_element.
    DATA includename TYPE program.
    DATA reportstring TYPE string.

**/--------------------------------------------------------------------\
**|                                                                    |
*  includename = cl_oo_classname_service=>get_pubsec_name( _classname ).
*  READ REPORT includename INTO reportlist.
*  publicsection = xmldoc->create_element( 'publicSection' ).
*
*  reportstring = buildsourcestring( sourcetable = reportlist ).
*  rc = publicsection->if_ixml_node~set_value( reportstring ).
*  CLEAR reportstring.
**|--------------------------------------------------------------------|
*  includename = cl_oo_classname_service=>get_prosec_name( _classname ).
*  READ REPORT includename INTO reportlist.
*  protectedsection = xmldoc->create_element( 'protectedSection' ).
*  reportstring = buildsourcestring( sourcetable = reportlist ).
*  rc = protectedsection->if_ixml_node~set_value( reportstring ).
*  CLEAR reportstring.
**|--------------------------------------------------------------------|
*  includename = cl_oo_classname_service=>get_prisec_name( _classname ).
*  READ REPORT includename INTO reportlist.
*  privatesection = xmldoc->create_element( 'privateSection' ).
*  reportstring = buildsourcestring( sourcetable = reportlist ).
*  rc = privatesection->if_ixml_node~set_value( reportstring ).

*  rc = rootnode->append_child( publicsection ).
*  rc = rootnode->append_child( protectedsection ).
*  rc = rootnode->append_child( privatesection ).

  ENDMETHOD.
  METHOD get_textpool.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA atext TYPE REF TO if_ixml_element.
    DATA textpooltable TYPE STANDARD TABLE OF textpool.
    DATA textpoolrow TYPE textpool.
    DATA languagelist TYPE instlang.
    DATA alanguage TYPE spras.
    DATA _objname TYPE seoclsname.
    DATA rc TYPE i.
    DATA stemp TYPE string.
    DATA languagenode TYPE REF TO if_ixml_element.
    DATA textnode      TYPE REF TO if_ixml_element.
    DATA classpoolname TYPE program.
    DATA firstloop TYPE flag.

    _objname = objname.

    classpoolname = cl_oo_classname_service=>get_classpool_name( _objname ).

    CALL FUNCTION 'RS_TEXTLOG_GET_PARAMETERS'
      CHANGING
        installed_languages = languagelist.

    firstloop = abap_true.

    LOOP AT languagelist INTO alanguage.
      READ TEXTPOOL classpoolname INTO textpooltable LANGUAGE alanguage.
      IF sy-subrc = 0.
        IF firstloop = abap_true.
          textnode = xmldoc->create_element( c_xml_key_textpool ).
          firstloop = abap_false.
        ENDIF.
        languagenode = xmldoc->create_element( c_xml_key_language ).
        stemp = alanguage.
        rc = languagenode->set_attribute( name = c_xml_key_spras value = stemp ).
        LOOP AT textpooltable INTO textpoolrow.
          atext = xmldoc->create_element( c_xml_key_textelement ).
          setattributesfromstructure( node = atext structure =
          textpoolrow ).
          rc = languagenode->append_child( atext ).
        ENDLOOP.
        rc = textnode->append_child( languagenode ).
      ENDIF.
    ENDLOOP.

    rc = rootnode->append_child( textnode ).

  ENDMETHOD.
  METHOD get_version_info.

    rs_version_info-zsaplink_plugin_major_version = 0.  " We will still import anything written by older version, versioning doesn't change in- or ouptut
    rs_version_info-zsaplink_plugin_minor_version = 1.  " Since we add versioning info this has to increase
    rs_version_info-zsaplink_plugin_build_version = 0.  " minor version increased --> reset to 0

    rs_version_info-zsaplink_plugin_info1         = 'ZSAPLINK_CLASS is part of the main ZSAPLINK project --> This plugin found there instead of ZSAPLINK_PLUGINS projects'.
    rs_version_info-zsaplink_plugin_info2         = 'SAPLINK homepage: https://www.assembla.com/spaces/saplink/wiki'.
    rs_version_info-zsaplink_plugin_info3         = 'Download from https://www.assembla.com/code/saplink/subversion/nodes'.
    rs_version_info-zsaplink_plugin_info4         = 'and navigate to:  trunk -> core -> ZSAPLINK -> CLAS -> ZSAPLINK_CLASS.slnk'.
    rs_version_info-zsaplink_plugin_info5         = ''.

  ENDMETHOD.
ENDCLASS.
CLASS zsaplink_program IMPLEMENTATION.
  METHOD checkexists.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/

    SELECT SINGLE name FROM trdir INTO objname WHERE name = objname.
    IF sy-subrc = 0.
      exists = 'X'.
    ENDIF.

  ENDMETHOD.
  METHOD createixmldocfromobject.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA sourcenode TYPE REF TO if_ixml_element.
    DATA textpoolnode TYPE REF TO if_ixml_element.
    DATA docnode TYPE REF TO if_ixml_element.
    DATA dynpronode TYPE REF TO if_ixml_element.
    DATA statusnode TYPE REF TO if_ixml_element.
    DATA rc TYPE sysubrc.
    DATA progattribs TYPE trdir.
    DATA progsource TYPE rswsourcet.
    DATA sourcestring TYPE string.
    DATA _objtype TYPE string.

    _objtype = getobjecttype( ).
    rootnode = xmldoc->create_element( _objtype ).
    sourcenode = xmldoc->create_element( 'source' ).
    SELECT SINGLE * FROM trdir INTO progattribs WHERE name = objname.
    IF sy-subrc = 0.
      setattributesfromstructure( node = rootnode structure =  progattribs ).
      progsource = me->get_source( ).
      sourcestring = buildsourcestring( sourcetable = progsource ).
      rc = sourcenode->if_ixml_node~set_value( sourcestring ).
      textpoolnode = get_textpool( ).
      rc = rootnode->append_child( textpoolnode ).
      docnode = get_documentation( ).
      rc = rootnode->append_child( docnode ).
      dynpronode = get_dynpro( ).
      rc = rootnode->append_child( dynpronode ).
      statusnode = get_pfstatus( ).
      rc = rootnode->append_child( statusnode ).
      rc = rootnode->append_child( sourcenode ).
      rc = xmldoc->append_child( rootnode ).
      ixmldocument = xmldoc.
    ELSE.
      CLEAR ixmldocument.
      RAISE EXCEPTION TYPE zcx_saplink
        EXPORTING
          textid = zcx_saplink=>not_found
          object = objname.
    ENDIF.
  ENDMETHOD.
  METHOD createobjectfromixmldoc.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA rootnode TYPE REF TO if_ixml_element.
    DATA progattribs TYPE trdir.
    DATA sourcenode TYPE REF TO if_ixml_element.
    DATA textnode TYPE REF TO if_ixml_element.
    DATA docnode TYPE REF TO if_ixml_element.
    DATA dynpnode TYPE REF TO if_ixml_element.
    DATA statnode TYPE REF TO if_ixml_element.
    DATA source TYPE string.
    DATA sourcetable TYPE table_of_strings.
    DATA _objname(30) TYPE c.
    DATA aobjname TYPE trobj_name.
    DATA _objtype TYPE string.
    DATA checkexists TYPE flag.

*if sy-uname <> 'USDWM01'.
*    _objType = getObjectType( ).
*    xmlDoc = ixmlDocument.
*    rootNode = xmlDoc->find_from_name( _objType ).
*    call method GETSTRUCTUREFROMATTRIBUTES
*          exporting
*            node = rootNode
*          changing
*            structure = progAttribs.
*    objName = progAttribs-NAME.
*
**   check existing
*    select single name from trdir into objName where NAME = objName.
*    if sy-subrc = 0.
*      raise exception type zcx_saplink
*        exporting textid = zcx_saplink=>existing.
*    endif.
*
*    sourceNode = rootNode->find_from_name( 'source' ).
*    source = sourceNode->get_value( ).
*    sourceTable = BUILDTABLEFROMSTRING( source ).
*    insert report progAttribs-NAME from sourceTable.
*
*    commit work.
*
*    call function 'RS_INSERT_INTO_WORKING_AREA'
*      EXPORTING
*        object            = 'REPS'
*        obj_name          = aobjName
*      EXCEPTIONS
*        wrong_object_name = 1.
*    if sy-subrc <> 0.
*
*    endif.
*
*else.

    _objtype = getobjecttype( ).
    xmldoc = ixmldocument.
    rootnode = xmldoc->find_from_name( _objtype ).
    CALL METHOD getstructurefromattributes
      EXPORTING
        node      = rootnode
      CHANGING
        structure = progattribs.
    objname = progattribs-name.

*  check if object exists
*  select single name from trdir into objName where NAME = objName.
*  if sy-subrc = 0 and overwrite <> 'X'.
*    raise exception type zcx_saplink
*      exporting textid = zcx_saplink=>existing.
*  endif.

    checkexists = checkexists( ).
    IF checkexists IS NOT INITIAL.
      IF overwrite IS INITIAL.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>existing.
      ELSE.
*     delete object for new install
        deleteobject( ).
      ENDIF.
    ENDIF.


    enqueue_abap( ).
    transport_copy( author = progattribs-cnam devclass = devclass ).
    sourcenode = rootnode->find_from_name( 'source' ).
    source = sourcenode->get_value( ).
    sourcetable = buildtablefromstring( source ).
    create_source( source = sourcetable attribs = progattribs ).
    textnode = rootnode->find_from_name( 'textPool' ).
    create_textpool( textnode ).
    docnode = rootnode->find_from_name( 'programDocumentation' ).
    create_documentation( docnode ).
    dynpnode = rootnode->find_from_name( 'dynpros' ).
    create_dynpro( dynpnode ).
    statnode = rootnode->find_from_name( 'pfstatus' ).
    create_pfstatus( statnode ).

    dequeue_abap( ).
    update_wb_tree( ).
*endif.

* successful install
    name = objname.

  ENDMETHOD.
  METHOD createstringfromobject.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA progsource TYPE rswsourcet.
    progsource = me->get_source( ).
    string = buildsourcestring( sourcetable = progsource ).
  ENDMETHOD.
  METHOD create_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA txtline_node     TYPE REF TO if_ixml_element.
    DATA txtline_filter   TYPE REF TO if_ixml_node_filter.
    DATA txtline_iterator TYPE REF TO if_ixml_node_iterator.

    DATA lang_node     TYPE REF TO if_ixml_element.
    DATA lang_filter   TYPE REF TO if_ixml_node_filter.
    DATA lang_iterator TYPE REF TO if_ixml_node_iterator.

    DATA obj_name TYPE dokhl-object.
    DATA prog_name TYPE string.
    DATA language  TYPE string.
    DATA obj_langu TYPE dokhl-langu.
    DATA lv_str TYPE string.
    DATA rc TYPE sy-subrc.

    DATA lt_lines  TYPE TABLE OF tline.
    FIELD-SYMBOLS: <ls_lines> LIKE LINE OF lt_lines.

    IF docnode IS NOT BOUND.
      RETURN.
    ENDIF.

    prog_name = docnode->get_attribute( name = 'OBJECT' ).
    obj_name = prog_name.

* If no prog name, then there was no program documenation, just return.
    IF prog_name IS INITIAL.
      RETURN.
    ENDIF.

* Get languages from XML
    FREE: lang_filter, lang_iterator, lang_node.
    lang_filter = docnode->create_filter_name( `language` ).
    lang_iterator = docnode->create_iterator_filtered( lang_filter ).
    lang_node ?= lang_iterator->get_next( ).
    WHILE lang_node IS NOT INITIAL.

      REFRESH lt_lines.
      language = lang_node->get_attribute( name = 'SPRAS' ).
      obj_langu = language.

* Get TextLines from XML
      FREE: txtline_filter, txtline_iterator, txtline_node.
      txtline_filter = lang_node->create_filter_name( `textLine` ).
      txtline_iterator = lang_node->create_iterator_filtered( txtline_filter ).
      txtline_node ?= txtline_iterator->get_next( ).
      WHILE txtline_node IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_lines ASSIGNING <ls_lines>.
        me->getstructurefromattributes(
                EXPORTING   node      = txtline_node
                CHANGING    structure = <ls_lines> ).
        txtline_node ?= txtline_iterator->get_next( ).
      ENDWHILE.

* Delete any documentation that may currently exist.
      CALL FUNCTION 'DOCU_DEL'
        EXPORTING
          id       = 'RE'   "<-- Report/program documentation
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.

* Now update with new documentation text
      CALL FUNCTION 'DOCU_UPD'
        EXPORTING
          id       = 'RE'
          langu    = obj_langu
          object   = obj_name
          typ      = 'E'
        TABLES
          line     = lt_lines
        EXCEPTIONS
          ret_code = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>error_message
            msg    = `Program Documentation object import failed`.
      ENDIF.

      lang_node ?= lang_iterator->get_next( ).
    ENDWHILE.

  ENDMETHOD.
  METHOD create_dynpro.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    TYPES: BEGIN OF tdyn_head_temp.
        INCLUDE TYPE d020s.
    TYPES: dtext TYPE d020t-dtxt.
    TYPES: END OF tdyn_head_temp.

    DATA: idyn_fldl TYPE TABLE OF d021s,
          idyn_flow TYPE TABLE OF d022s,
          idyn_mcod TYPE TABLE OF d023s.

    DATA: xdyn_head TYPE  d020s,
          xdyn_fldl TYPE  d021s,
          xdyn_flow TYPE  d022s,
          xdyn_mcod TYPE  d023s.

    DATA: xdyn_text_string TYPE string.
    DATA: xdyn_text        TYPE d020t-dtxt .
    DATA: xdyn_head_temp   TYPE tdyn_head_temp.

    DATA _objname TYPE trobj_name.

    DATA dynpros_node       TYPE REF TO if_ixml_element.
    DATA dynpros_filter     TYPE REF TO if_ixml_node_filter.
    DATA dynpros_iterator   TYPE REF TO if_ixml_node_iterator.

    DATA dynpro_node        TYPE REF TO if_ixml_element.
    DATA dynpro_filter      TYPE REF TO if_ixml_node_filter.
    DATA dynpro_iterator    TYPE REF TO if_ixml_node_iterator.

    DATA dynfldl_node       TYPE REF TO if_ixml_element.
    DATA dynfldl_filter     TYPE REF TO if_ixml_node_filter.
    DATA dynfldl_iterator   TYPE REF TO if_ixml_node_iterator.

    DATA dynmcod_node       TYPE REF TO if_ixml_element.
    DATA dynmcod_filter     TYPE REF TO if_ixml_node_filter.
    DATA dynmcod_iterator   TYPE REF TO if_ixml_node_iterator.

    DATA dynflow_node       TYPE REF TO if_ixml_element.

    DATA xdynpro_flow_source TYPE string.
    DATA idynpro_flow_source TYPE table_of_strings.

    _objname = objname.

    dynpros_node =  dynp_node.
    CHECK dynpros_node IS NOT INITIAL.

    FREE: dynpro_filter, dynpro_iterator, dynpro_node.
    dynpro_filter = dynpros_node->create_filter_name( 'dynpro' ).
    dynpro_iterator =
          dynpros_node->create_iterator_filtered( dynpro_filter ).
    dynpro_node ?= dynpro_iterator->get_next( ).

    WHILE dynpro_node IS NOT INITIAL.

      CLEAR:    xdyn_head, xdyn_fldl, xdyn_flow, xdyn_mcod.
      REFRESH:  idyn_fldl, idyn_flow, idyn_mcod.

* Get the header data for the screen.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = dynpro_node
        CHANGING
          structure = xdyn_head_temp.

      xdyn_head    = xdyn_head_temp.
      xdyn_text    = xdyn_head_temp-dtext.

* Retrieve field list
      FREE: dynfldl_filter, dynfldl_iterator, dynfldl_node.
      dynfldl_filter = dynpro_node->create_filter_name( 'dynprofield' ).
      dynfldl_iterator =
          dynpro_node->create_iterator_filtered( dynfldl_filter ).
      dynfldl_node ?= dynfldl_iterator->get_next( ).
      WHILE dynfldl_node IS NOT INITIAL.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = dynfldl_node
          CHANGING
            structure = xdyn_fldl.
        APPEND xdyn_fldl TO idyn_fldl.
        dynfldl_node ?= dynfldl_iterator->get_next( ).
      ENDWHILE.

* Retrieve matchcode data.
      FREE: dynmcod_filter, dynmcod_iterator, dynmcod_node.
      dynmcod_filter = dynpro_node->create_filter_name( 'dynprofield' ).
      dynmcod_iterator =
           dynpro_node->create_iterator_filtered( dynmcod_filter ).
      dynmcod_node ?= dynmcod_iterator->get_next( ).
      WHILE dynmcod_node IS NOT INITIAL.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = dynmcod_node
          CHANGING
            structure = xdyn_mcod.
        APPEND xdyn_mcod TO idyn_mcod.
        dynmcod_node ?= dynmcod_iterator->get_next( ).
      ENDWHILE.

* retieve flow logic source.
      CLEAR xdynpro_flow_source.  REFRESH idynpro_flow_source.
      CLEAR xdyn_flow.            REFRESH idyn_flow.
      FREE dynflow_node.
      dynflow_node = dynpro_node->find_from_name( 'dynproflowsource' ).
      xdynpro_flow_source  = dynflow_node->get_value( ).
      idynpro_flow_source = buildtablefromstring( xdynpro_flow_source ).
      LOOP AT idynpro_flow_source INTO xdyn_flow.
        APPEND xdyn_flow  TO idyn_flow.
      ENDLOOP.

* Build dynpro from data
      CALL FUNCTION 'RPY_DYNPRO_INSERT_NATIVE'
        EXPORTING
*         suppress_corr_checks           = ' '
*         CORRNUM            = ' '
          header             = xdyn_head
          dynprotext         = xdyn_text
*         SUPPRESS_EXIST_CHECKS          = ' '
*         USE_CORRNUM_IMMEDIATEDLY       = ' '
*         SUPPRESS_COMMIT_WORK           = ' '
        TABLES
          fieldlist          = idyn_fldl
          flowlogic          = idyn_flow
          params             = idyn_mcod
        EXCEPTIONS
          cancelled          = 1
          already_exists     = 2
          program_not_exists = 3
          not_executed       = 4
          OTHERS             = 5.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_saplink
          EXPORTING
            textid = zcx_saplink=>system_error.
      ENDIF.

      dynpro_node ?= dynpro_iterator->get_next( ).

    ENDWHILE.

  ENDMETHOD.
  METHOD create_pfstatus.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA: ista TYPE TABLE OF rsmpe_stat,
          ifun TYPE TABLE OF rsmpe_funt,
          imen TYPE TABLE OF rsmpe_men,
          imtx TYPE TABLE OF rsmpe_mnlt,
          iact TYPE TABLE OF rsmpe_act,
          ibut TYPE TABLE OF rsmpe_but,
          ipfk TYPE TABLE OF rsmpe_pfk,
          iset TYPE TABLE OF rsmpe_staf,
          idoc TYPE TABLE OF rsmpe_atrt,
          itit TYPE TABLE OF rsmpe_titt,
          ibiv TYPE TABLE OF rsmpe_buts.

    DATA: xsta TYPE rsmpe_stat,
          xfun TYPE rsmpe_funt,
          xmen TYPE rsmpe_men,
          xmtx TYPE rsmpe_mnlt,
          xact TYPE rsmpe_act,
          xbut TYPE rsmpe_but,
          xpfk TYPE rsmpe_pfk,
          xset TYPE rsmpe_staf,
          xdoc TYPE rsmpe_atrt,
          xtit TYPE rsmpe_titt,
          xbiv TYPE rsmpe_buts.

    DATA xtrkey TYPE trkey.
    DATA xadm   TYPE rsmpe_adm.
    DATA _program TYPE  trdir-name.
    DATA _objname TYPE trobj_name.

    DATA stat_node  TYPE REF TO if_ixml_element.
    DATA node       TYPE REF TO if_ixml_element.
    DATA filter     TYPE REF TO if_ixml_node_filter.
    DATA iterator   TYPE REF TO if_ixml_node_iterator.

    DATA: ls_iact TYPE rsmpe_act,
          ls_ipfk TYPE rsmpe_pfk,
          ls_imen TYPE rsmpe_men.

    _objname = objname.

    stat_node =  pfstat_node.
    CHECK stat_node IS NOT INITIAL.

* read pfstatus_sta node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_sta' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xsta.
      APPEND xsta TO ista.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_fun node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_fun' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xfun.
      APPEND xfun TO ifun.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_men node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_men' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xmen.
      APPEND xmen TO imen.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_mtx node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_mtx' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xmtx.
      APPEND xmtx TO imtx.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_act node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_act' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xact.
      APPEND xact TO iact.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_but node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_but' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xbut.
      APPEND xbut TO ibut.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_pfk node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_pfk' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xpfk.
      APPEND xpfk TO ipfk.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_set node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_set' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xset.
      APPEND xset TO iset.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_doc node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_doc' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xdoc.
      APPEND xdoc TO idoc.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_tit node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_tit' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xtit.
      APPEND xtit TO itit.
      node ?= iterator->get_next( ).
    ENDWHILE.

* read pfstatus_biv node
    FREE: filter, iterator, node.
    filter = stat_node->create_filter_name( 'pfstatus_biv' ).
    iterator = stat_node->create_iterator_filtered( filter ).
    node ?= iterator->get_next( ).
    WHILE node IS NOT INITIAL.
      CALL METHOD getstructurefromattributes
        EXPORTING
          node      = node
        CHANGING
          structure = xbiv.
      APPEND xbiv TO ibiv.
      node ?= iterator->get_next( ).
    ENDWHILE.

* Update the gui status
    _program = _objname.

    xtrkey-obj_type = 'PROG'.
    xtrkey-obj_name = _program.
    xtrkey-sub_type = 'CUAD'.
    xtrkey-sub_name = _program.

    LOOP AT iact INTO ls_iact.
      xadm-actcode = ls_iact-code.
    ENDLOOP.
    LOOP AT ipfk INTO ls_ipfk.
      xadm-pfkcode = ls_ipfk-code.
    ENDLOOP.
    LOOP AT imen INTO ls_imen.
      xadm-mencode = ls_imen-code.
    ENDLOOP.

    CALL FUNCTION 'RS_CUA_INTERNAL_WRITE'
      EXPORTING
        program   = _program
        language  = sy-langu
        tr_key    = xtrkey
        adm       = xadm
        state     = 'I'
      TABLES
        sta       = ista
        fun       = ifun
        men       = imen
        mtx       = imtx
        act       = iact
        but       = ibut
        pfk       = ipfk
        set       = iset
        doc       = idoc
        tit       = itit
        biv       = ibiv
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_saplink
        EXPORTING
          textid = zcx_saplink=>system_error.
    ENDIF.

  ENDMETHOD.
  METHOD create_source.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/

    DATA _objname TYPE trobj_name.
    DATA progline TYPE progdir.
    DATA titleinfo TYPE trdirti.
    DATA reportline TYPE string.
    DATA minireport TYPE table_of_strings.

    _objname = objname.
    CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
      EXPORTING
        object            = 'REPS'
        obj_name          = _objname
      EXCEPTIONS
        wrong_object_name = 1.
    INSERT REPORT _objname FROM source STATE 'I'
      PROGRAM TYPE attribs-subc.  "added to handle includes, etc.
    MOVE 'I' TO progline-state.
    MOVE-CORRESPONDING attribs TO progline.
    progline-idate = sy-datum.
    progline-itime = sy-uzeit.
    progline-cdat  = sy-datum.
    progline-udat  = sy-datum.
    progline-sdate = sy-datum.
    MODIFY progdir FROM progline.
*  Are you kidding me?!?  No idea why you need to do this!!
    CONCATENATE 'REPORT' _objname '.' INTO reportline SEPARATED BY space.
    APPEND reportline TO minireport.
    INSERT REPORT _objname FROM minireport STATE 'A'
      PROGRAM TYPE attribs-subc. "added to handle includes, etc.
    MOVE 'A' TO progline-state.
    MODIFY progdir FROM progline.

  ENDMETHOD.
  METHOD create_textpool.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA textpooltable TYPE STANDARD TABLE OF textpool.
    DATA textpoolrow TYPE textpool.
    DATA langiterator TYPE REF TO if_ixml_node_iterator.
    DATA filter TYPE REF TO if_ixml_node_filter.
    DATA textfilter TYPE REF TO if_ixml_node_filter.
    DATA textiterator TYPE REF TO if_ixml_node_iterator.
    DATA langnode TYPE REF TO if_ixml_element.
    DATA atextnode TYPE REF TO if_ixml_element.
    DATA _objname TYPE trobj_name.
    DATA lang TYPE spras.
    DATA langnodeexists TYPE flag.
    DATA logonlanguageexists TYPE flag.
    DATA _state(1) TYPE c.

    _objname = objname.
    CHECK textpoolnode IS NOT INITIAL.

    filter = textpoolnode->create_filter_name( 'language' ).
    langiterator = textpoolnode->create_iterator_filtered( filter ).
    langnode ?= langiterator->get_next( ).

    WHILE langnode IS NOT INITIAL.
      langnodeexists = 'X'.
      CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'
        EXPORTING
          object   = 'REPT'
          obj_name = _objname
        EXCEPTIONS
          OTHERS   = 0.

      REFRESH textpooltable.
      textiterator = langnode->create_iterator( ).
      atextnode ?= textiterator->get_next( ).
*For some reason the 1st one is blank... not sure why.
      atextnode ?= textiterator->get_next( ).
      WHILE atextnode IS NOT INITIAL.
        CALL METHOD getstructurefromattributes
          EXPORTING
            node      = atextnode
          CHANGING
            structure = textpoolrow.
        APPEND textpoolrow TO textpooltable.
        atextnode ?= textiterator->get_next( ).
      ENDWHILE.
      IF textpooltable IS NOT INITIAL.
        lang = langnode->get_attribute( 'SPRAS' ).
        IF lang = sy-langu.
          logonlanguageexists = 'X'.
          _state = 'I'.
        ELSE.
*       seems that if a textpool is inserted as inactive for language
*       other than the logon language, it is lost upon activation
*       not sure inserting as active is best solution,but seems to work
          _state = 'A'.
        ENDIF.
        INSERT TEXTPOOL _objname
          FROM textpooltable
          LANGUAGE lang
          STATE    _state.
      ENDIF.
      langnode ?= langiterator->get_next( ).
    ENDWHILE.
  ENDMETHOD.
  METHOD deleteobject.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA program TYPE sy-repid.

    program = objname.

    CALL FUNCTION 'RS_DELETE_PROGRAM'
      EXPORTING
*       CORRNUMBER     =
        program        = program
*       SUPPRESS_CHECKS                  = ' '
*       SUPPRESS_COMMIT                  = ' '
        suppress_popup = 'X'
*       MASS_DELETE_CALL                 = ' '
*       WITH_CUA       = 'X'
*       WITH_DOCUMENTATION               = 'X'
*       WITH_DYNPRO    = 'X'
*       WITH_INCLUDES  = ' '
*       WITH_TEXTPOOL  = 'X'
*       WITH_VARIANTS  = 'X'
*       TADIR_DEVCLASS =
*       SKIP_PROGRESS_IND                = ' '
*       FORCE_DELETE_USED_INCLUDES       = ' '
* IMPORTING
*       CORRNUMBER     =
*       PROGRAM        =
* EXCEPTIONS
*       ENQUEUE_LOCK   = 1
*       OBJECT_NOT_FOUND                 = 2
*       PERMISSION_FAILURE               = 3
*       REJECT_DELETION                  = 4
*       OTHERS         = 5
      .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDMETHOD.
  METHOD dequeue_abap.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    CALL FUNCTION 'RS_ACCESS_PERMISSION'
      EXPORTING
        global_lock              = 'X'
        mode                     = 'FREE'
        object                   = objname
        object_class             = 'ABAP'
      EXCEPTIONS
        canceled_in_corr         = 1
        enqueued_by_user         = 3
        enqueue_system_failure   = 4
        locked_by_author         = 5
        illegal_parameter_values = 6
        no_modify_permission     = 7
        no_show_permission       = 8
        permission_failure       = 9.

    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 7 OR 8 OR 9.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>not_authorized.
        WHEN 5.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'object locked'.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>system_error.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
  METHOD enqueue_abap.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    CALL FUNCTION 'RS_ACCESS_PERMISSION'
      EXPORTING
*       authority_check          = authority_check
        global_lock              = 'X'
        mode                     = 'INSERT'
*       master_language          = trdir-rload
        object                   = objname
        object_class             = 'ABAP'
*       importing
*       transport_key            = trkey_global
*       new_master_language      = trdir-rload
*       devclass                 = devclass_local
      EXCEPTIONS
        canceled_in_corr         = 1
        enqueued_by_user         = 3
        enqueue_system_failure   = 4
        locked_by_author         = 5
        illegal_parameter_values = 6
        no_modify_permission     = 7
        no_show_permission       = 8
        permission_failure       = 9.

    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 7 OR 8 OR 9.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>not_authorized.
        WHEN 5.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>error_message
              msg    = 'object locked'.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>system_error.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
  METHOD getobjecttype.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    objecttype = 'PROG'. "ABAP Program
  ENDMETHOD.
  METHOD get_documentation.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA languagenode   TYPE REF TO if_ixml_element.
    DATA txtlines_node TYPE REF TO if_ixml_element.
    DATA rc            TYPE sysubrc.
    DATA _objtype      TYPE string.

    TYPES: BEGIN OF t_dokhl,
             id         TYPE dokhl-id,
             object     TYPE dokhl-object,
             langu      TYPE dokhl-langu,
             typ        TYPE dokhl-typ,
             dokversion TYPE dokhl-dokversion,
           END OF t_dokhl.

    DATA lt_dokhl TYPE TABLE OF t_dokhl.
    DATA ls_dokhl LIKE LINE OF lt_dokhl.

    DATA lt_lines TYPE TABLE OF tline.
    DATA ls_lines LIKE LINE OF lt_lines.

    DATA lv_str TYPE string.
    DATA _objname TYPE e071-obj_name.

    _objname = objname.

* Check against database
    SELECT  id object langu typ dokversion
          INTO CORRESPONDING FIELDS OF TABLE lt_dokhl
             FROM dokhl
               WHERE id = 'RE'
                  AND object = _objname.

* Use only most recent version.
    SORT lt_dokhl BY id object langu typ ASCENDING dokversion DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_dokhl COMPARING id object typ langu.

* Make sure there is at least one record here.
    CLEAR ls_dokhl.
    READ TABLE lt_dokhl INTO ls_dokhl INDEX 1.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    docnode = xmldoc->create_element( 'programDocumentation' ).

* Set docNode object attribute
    lv_str = ls_dokhl-object.
    rc = docnode->set_attribute( name = 'OBJECT' value = lv_str ).

    LOOP AT lt_dokhl INTO ls_dokhl.

* Create language node, and set attribute
      languagenode = xmldoc->create_element( 'language' ).
      lv_str = ls_dokhl-langu.
      rc = languagenode->set_attribute( name = 'SPRAS' value = lv_str ).

* Read the documentation text
      CALL FUNCTION 'DOCU_READ'
        EXPORTING
          id      = ls_dokhl-id
          langu   = ls_dokhl-langu
          object  = ls_dokhl-object
          typ     = ls_dokhl-typ
          version = ls_dokhl-dokversion
        TABLES
          line    = lt_lines.

* Write records to XML node
      LOOP AT lt_lines INTO ls_lines.
        txtlines_node = xmldoc->create_element( `textLine` ).
        me->setattributesfromstructure( node = txtlines_node structure = ls_lines ).
        rc = languagenode->append_child( txtlines_node ).
      ENDLOOP.
      rc = docnode->append_child( languagenode ) .
    ENDLOOP.

  ENDMETHOD.
  METHOD get_dynpro.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    TYPES: BEGIN OF tdynp,
             prog TYPE d020s-prog,
             dnum TYPE d020s-dnum,
           END OF tdynp.

    DATA: idyn_fldl TYPE TABLE OF d021s,
          idyn_flow TYPE TABLE OF d022s,
          idyn_mcod TYPE TABLE OF d023s.

    DATA: xdyn_head TYPE  d020s,
          xdyn_fldl TYPE  d021s,
          xdyn_flow TYPE  d022s,
          xdyn_mcod TYPE  d023s.

    DATA idynp TYPE TABLE OF tdynp.
    DATA xdynp TYPE tdynp.

    DATA xdyn_text TYPE d020t-dtxt.
    DATA xdyn_text_string TYPE string.

    DATA _objname TYPE trobj_name.
    DATA rc TYPE sy-subrc .

    DATA iflowsource TYPE rswsourcet.
    DATA xflowsource LIKE LINE OF iflowsource.
    DATA flowsourcestring TYPE string.

    DATA dynnr_node TYPE REF TO if_ixml_element.
    DATA dynpromatchnode TYPE REF TO if_ixml_element.
    DATA dynprofieldsnode TYPE REF TO if_ixml_element.
    DATA dynproflownode TYPE REF TO if_ixml_element.

    _objname = objname.

* Get all dynpros for program object
    CLEAR xdynp.  REFRESH idynp.
    SELECT prog dnum INTO TABLE idynp
                  FROM d020s
                     WHERE prog = _objname
                       AND type <> 'S'    " No Selection Screens
                       AND type <> 'J'.   " No selection subscreens
    CHECK sy-subrc  = 0 .

    dynp_node = xmldoc->create_element( 'dynpros' ).

    LOOP AT idynp INTO xdynp.

* Retrieve dynpro imformation
      dynnr_node =  xmldoc->create_element( 'dynpro' ).

      CLEAR:    xdyn_head, xdyn_fldl, xdyn_flow, xdyn_mcod.
      REFRESH:  idyn_fldl, idyn_flow, idyn_mcod.

      CALL FUNCTION 'RPY_DYNPRO_READ_NATIVE'
        EXPORTING
          progname         = xdynp-prog
          dynnr            = xdynp-dnum
*         SUPPRESS_EXIST_CHECKS       = ' '
*         SUPPRESS_CORR_CHECKS        = ' '
        IMPORTING
          header           = xdyn_head
          dynprotext       = xdyn_text
        TABLES
          fieldlist        = idyn_fldl
          flowlogic        = idyn_flow
          params           = idyn_mcod
*         FIELDTEXTS       =
        EXCEPTIONS
          cancelled        = 1
          not_found        = 2
          permission_error = 3
          OTHERS           = 4.

      CHECK sy-subrc = 0.

* Add heading information for screen.
      setattributesfromstructure(
                       node = dynnr_node structure =  xdyn_head  ).
* Add the dynpro text also.
      xdyn_text_string =  xdyn_text.
      rc = dynnr_node->set_attribute(
                 name = 'DTEXT'  value = xdyn_text_string ).
      rc = dynp_node->append_child( dynnr_node ).

* Add fields information for screen.
      IF NOT idyn_fldl[] IS INITIAL.
        LOOP AT idyn_fldl INTO xdyn_fldl.
          dynprofieldsnode = xmldoc->create_element( 'dynprofield' ).
          setattributesfromstructure(
                   node = dynprofieldsnode structure =  xdyn_fldl ).
          rc = dynnr_node->append_child( dynprofieldsnode ).
        ENDLOOP.
      ENDIF.

* Add flow logic of screen
      IF NOT idyn_flow[] IS INITIAL.
        CLEAR xflowsource. REFRESH  iflowsource.
        LOOP AT idyn_flow INTO xdyn_flow.
          xflowsource  = xdyn_flow.
          APPEND xflowsource TO iflowsource.
        ENDLOOP.

        dynproflownode = xmldoc->create_element( 'dynproflowsource' ).
        flowsourcestring = buildsourcestring( sourcetable = iflowsource ).
        rc = dynproflownode->if_ixml_node~set_value( flowsourcestring ).
        rc = dynnr_node->append_child( dynproflownode  ).
      ENDIF.

* Add matchcode information for screen.
      IF NOT idyn_mcod[] IS INITIAL.
        LOOP AT idyn_mcod INTO xdyn_mcod.
          CHECK NOT xdyn_mcod-type IS INITIAL
            AND NOT xdyn_mcod-content IS INITIAL.
          dynpromatchnode = xmldoc->create_element( 'dynpromatchcode' ).
          setattributesfromstructure(
                   node = dynpromatchnode structure =  xdyn_mcod ).
          rc = dynnr_node->append_child( dynpromatchnode ).
        ENDLOOP.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD get_pfstatus.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA: ista TYPE TABLE OF rsmpe_stat,
          ifun TYPE TABLE OF rsmpe_funt,
          imen TYPE TABLE OF rsmpe_men,
          imtx TYPE TABLE OF rsmpe_mnlt,
          iact TYPE TABLE OF rsmpe_act,
          ibut TYPE TABLE OF rsmpe_but,
          ipfk TYPE TABLE OF rsmpe_pfk,
          iset TYPE TABLE OF rsmpe_staf,
          idoc TYPE TABLE OF rsmpe_atrt,
          itit TYPE TABLE OF rsmpe_titt,
          ibiv TYPE TABLE OF rsmpe_buts.

    DATA: xsta TYPE rsmpe_stat,
          xfun TYPE rsmpe_funt,
          xmen TYPE rsmpe_men,
          xmtx TYPE rsmpe_mnlt,
          xact TYPE rsmpe_act,
          xbut TYPE rsmpe_but,
          xpfk TYPE rsmpe_pfk,
          xset TYPE rsmpe_staf,
          xdoc TYPE rsmpe_atrt,
          xtit TYPE rsmpe_titt,
          xbiv TYPE rsmpe_buts.

    DATA sta_node TYPE REF TO if_ixml_element.
    DATA fun_node TYPE REF TO if_ixml_element.
    DATA men_node TYPE REF TO if_ixml_element.
    DATA mtx_node TYPE REF TO if_ixml_element.
    DATA act_node TYPE REF TO if_ixml_element.
    DATA but_node TYPE REF TO if_ixml_element.
    DATA pfk_node TYPE REF TO if_ixml_element.
    DATA set_node TYPE REF TO if_ixml_element.
    DATA doc_node TYPE REF TO if_ixml_element.
    DATA tit_node TYPE REF TO if_ixml_element.
    DATA biv_node TYPE REF TO if_ixml_element.

    DATA _objname TYPE trobj_name.
    DATA _program TYPE  trdir-name.
    DATA rc TYPE sy-subrc.

    _objname = objname.
    _program = objname.

    CALL FUNCTION 'RS_CUA_INTERNAL_FETCH'
      EXPORTING
        program         = _program
        language        = sy-langu
      TABLES
        sta             = ista
        fun             = ifun
        men             = imen
        mtx             = imtx
        act             = iact
        but             = ibut
        pfk             = ipfk
        set             = iset
        doc             = idoc
        tit             = itit
        biv             = ibiv
      EXCEPTIONS
        not_found       = 1
        unknown_version = 2
        OTHERS          = 3.

    CHECK sy-subrc = 0.

* if there is a gui status or gui title present, then
* create pfstatus node.
    IF ista[] IS NOT INITIAL
       OR itit[] IS NOT INITIAL.
      pfstat_node = xmldoc->create_element( 'pfstatus' ).
    ENDIF.


* if ista is filled, assume there are one or more
* gui statuses
    IF ista[] IS NOT INITIAL.

      LOOP AT ista INTO xsta.
        sta_node = xmldoc->create_element( 'pfstatus_sta' ).
        setattributesfromstructure(
                 node = sta_node
                 structure =  xsta ).
        rc = pfstat_node->append_child( sta_node ).
      ENDLOOP.

      LOOP AT ifun INTO xfun.
        fun_node = xmldoc->create_element( 'pfstatus_fun' ).
        setattributesfromstructure(
                 node = fun_node
                 structure =  xfun ).
        rc = pfstat_node->append_child( fun_node ).
      ENDLOOP.

      LOOP AT imen INTO xmen.
        men_node = xmldoc->create_element( 'pfstatus_men' ).
        setattributesfromstructure(
                 node = men_node
                 structure =  xmen ).
        rc = pfstat_node->append_child( men_node ).
      ENDLOOP.

      LOOP AT imtx INTO xmtx.
        mtx_node = xmldoc->create_element( 'pfstatus_mtx' ).
        setattributesfromstructure(
                 node = mtx_node
                 structure =  xmtx ).
        rc = pfstat_node->append_child( mtx_node ).
      ENDLOOP.

      LOOP AT iact INTO xact.
        act_node = xmldoc->create_element( 'pfstatus_act' ).
        setattributesfromstructure(
                 node = act_node
                 structure =  xact ).
        rc = pfstat_node->append_child( act_node ).
      ENDLOOP.

      LOOP AT ibut INTO xbut.
        but_node = xmldoc->create_element( 'pfstatus_but' ).
        setattributesfromstructure(
                 node = but_node
                 structure =  xbut ).
        rc = pfstat_node->append_child( but_node ).
      ENDLOOP.

      LOOP AT ipfk INTO xpfk.
        pfk_node = xmldoc->create_element( 'pfstatus_pfk' ).
        setattributesfromstructure(
                 node = pfk_node
                 structure =  xpfk ).
        rc = pfstat_node->append_child( pfk_node ).
      ENDLOOP.

      LOOP AT iset INTO xset.
        set_node = xmldoc->create_element( 'pfstatus_set' ).
        setattributesfromstructure(
                 node = set_node
                 structure =  xset ).
        rc = pfstat_node->append_child( set_node ).
      ENDLOOP.

      LOOP AT idoc INTO xdoc.
        doc_node = xmldoc->create_element( 'pfstatus_doc' ).
        setattributesfromstructure(
                 node = doc_node
                 structure =  xdoc ).
        rc = pfstat_node->append_child( doc_node ).
      ENDLOOP.


      LOOP AT ibiv INTO xbiv.
        biv_node = xmldoc->create_element( 'pfstatus_biv' ).
        setattributesfromstructure(
                 node = biv_node
                 structure =  xbiv ).
        rc = pfstat_node->append_child( biv_node ).
      ENDLOOP.

    ENDIF.


* It itit is filled, assume one or more titles
    IF itit[] IS NOT INITIAL.

      LOOP AT itit INTO xtit.
        tit_node = xmldoc->create_element( 'pfstatus_tit' ).
        setattributesfromstructure(
                 node = tit_node
                 structure =  xtit ).
        rc = pfstat_node->append_child( tit_node ).
      ENDLOOP.

    ENDIF.

  ENDMETHOD.
  METHOD get_source.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/

    DATA _objname(30) TYPE c.

    _objname = me->objname.
    READ REPORT _objname INTO progsource.

  ENDMETHOD.
  METHOD get_textpool.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    DATA atext TYPE REF TO if_ixml_element.
    DATA textpooltable TYPE STANDARD TABLE OF textpool.
    DATA textpoolrow TYPE textpool.
    DATA languagelist TYPE instlang.
    DATA alanguage TYPE spras.
    DATA _objname(30) TYPE c.
    DATA rc TYPE i.
    DATA stemp TYPE string.
    DATA languagenode TYPE REF TO if_ixml_element.
    DATA firstloop TYPE flag.

    _objname = objname.


    CALL FUNCTION 'RS_TEXTLOG_GET_PARAMETERS'
      CHANGING
        installed_languages = languagelist.

    firstloop = abap_true.

    LOOP AT languagelist INTO alanguage.
      READ TEXTPOOL _objname INTO textpooltable LANGUAGE alanguage.
      IF sy-subrc = 0.
        IF firstloop = abap_true.
          textnode = xmldoc->create_element( 'textPool' ).
          firstloop = abap_false.
        ENDIF.
        languagenode = xmldoc->create_element( 'language' ).
        stemp = alanguage.
        rc = languagenode->set_attribute( name = 'SPRAS' value = stemp ).
        LOOP AT textpooltable INTO textpoolrow.
          atext = xmldoc->create_element( 'textElement' ).
          setattributesfromstructure( node = atext structure =
          textpoolrow ).
          rc = languagenode->append_child( atext ).
        ENDLOOP.
        rc = textnode->append_child( languagenode ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
  METHOD transport_copy.
*/---------------------------------------------------------------------\
*| This file is part of SAPlink.                                       |
*|                                                                     |
*| Copyright 2014 SAPlink project members                              |
*|                                                                     |
*| Licensed under the Apache License, Version 2.0 (the "License");     |
*| you may not use this file except in compliance with the License.    |
*| You may obtain a copy of the License at                             |
*|                                                                     |
*|     http://www.apache.org/licenses/LICENSE-2.0                      |
*|                                                                     |
*| Unless required by applicable law or agreed to in writing, software |
*| distributed under the License is distributed on an "AS IS" BASIS,   |
*| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or     |
*| implied.                                                            |
*| See the License for the specific language governing permissions and |
*| limitations under the License.                                      |
*\---------------------------------------------------------------------/
    CALL FUNCTION 'RS_CORR_INSERT'
      EXPORTING
        author              = author
        global_lock         = 'X'
        object              = objname
        object_class        = 'ABAP'
        devclass            = devclass
*       KORRNUM             = CORRNUMBER_LOCAL
        master_language     = sy-langu
*       PROGRAM             = PROGRAM_LOCAL
        mode                = 'INSERT'
*       IMPORTING
*       AUTHOR              = UNAME
*       KORRNUM             = CORRNUMBER_LOCAL
*       DEVCLASS            = DEVCLASS_LOCAL
      EXCEPTIONS
        cancelled           = 1
        permission_failure  = 2
        unknown_objectclass = 3.

    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 2.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>not_authorized.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_saplink
            EXPORTING
              textid = zcx_saplink=>system_error.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
  METHOD update_wb_tree.

    DATA: BEGIN OF pname,
            root(3)     VALUE 'PG_',
            program(27),
          END OF pname.

    DATA: trdir TYPE trdir.

    pname-program = me->objname.

    CALL FUNCTION 'WB_TREE_ACTUALIZE'
      EXPORTING
        tree_name = pname.

    trdir-name    = me->objname.

    CALL FUNCTION 'RS_TREE_OBJECT_PLACEMENT'
      EXPORTING
        object    = trdir-name
        program   = trdir-name
        operation = 'INSERT'
        type      = 'CP'.

  ENDMETHOD.
ENDCLASS.

TYPE-POOLS: seor, abap, icon.
DATA retfiletable TYPE filetable.
DATA retrc TYPE sysubrc.
DATA retuseraction TYPE i.

DATA tempxmlstring TYPE string.
DATA ixmlnugget TYPE REF TO if_ixml_document.

DATA pluginexists TYPE flag.
DATA objectexists TYPE flag.
DATA flag TYPE flag.
DATA statusmsg TYPE string.
DATA  y2all TYPE flag.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) filecom FOR FIELD nuggfil.
PARAMETERS nuggfil(300) TYPE c MODIF ID did OBLIGATORY.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) checkcom FOR FIELD nuggfil.
PARAMETERS overwrt TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF LINE.



START-OF-SELECTION.
  CLEAR tempxmlstring.
  PERFORM uploadxmlfromlm USING nuggfil tempxmlstring.
  PERFORM convertstringtoixmldoc USING tempxmlstring CHANGING ixmlnugget.
  PERFORM installnugget USING ixmlnugget overwrt.


*/--------------------------------------------------------------------\
*| Selection screen events                                            |
INITIALIZATION.
  filecom = 'Installation Nugget'.
  checkcom = 'Overwrite Originals'.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR nuggfil.
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      multiselection    = abap_false
      file_filter       = '*.nugg'
      default_extension = 'nugg'
    CHANGING
      file_table        = retfiletable
      rc                = retrc
      user_action       = retuseraction.
  READ TABLE retfiletable INTO nuggfil INDEX 1.
  REFRESH retfiletable.

*\--------------------------------------------------------------------/


*/--------------------------------------------------------------------\
*| Forms from the SAPLink Installer                                   |
*|                                                                     |
FORM uploadxmlfromlm USING p_filename xmlstring TYPE string .
  DATA retfiletable TYPE filetable.
  DATA retrc TYPE sysubrc.
  DATA retuseraction TYPE i.
  DATA temptable TYPE table_of_strings.
  DATA temptable_bin TYPE TABLE OF x255.
  DATA filelength TYPE i.
  DATA l_filename TYPE string.

  l_filename = p_filename.
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = l_filename
      filetype                = 'BIN'       " File Type Binary
    IMPORTING
      filelength              = filelength
    CHANGING
      data_tab                = temptable_bin
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN '1'.
        PERFORM writemessage USING 'E' 'File Open Error'.
      WHEN OTHERS.
        PERFORM writemessage USING 'E' 'Unknown Error occured'.
    ENDCASE.
  ENDIF.

  CALL FUNCTION 'SCMS_BINARY_TO_STRING'
    EXPORTING
      input_length = filelength
    IMPORTING
      text_buffer  = xmlstring
    TABLES
      binary_tab   = temptable_bin.
  IF sy-subrc <> 0.
    " Just catch the sy-subrc when there was nothing replaced
    sy-subrc = 0.
  ENDIF.
*  call method CL_GUI_FRONTEND_SERVICES=>GUI_UPLOAD
*        exporting
*          FILENAME = l_fileName
*        changing
*          data_tab = tempTable.
*  PERFORM createstring USING temptable CHANGING xmlstring.
ENDFORM.
*\--------------------------------------------------------------------/
FORM createstring
      USING
        temptable TYPE table_of_strings
      CHANGING
        bigstring TYPE string.

  DATA stemp TYPE string.
  LOOP AT temptable INTO stemp.
    CONCATENATE bigstring stemp cl_abap_char_utilities=>newline INTO
    bigstring.
  ENDLOOP.

ENDFORM.
*/----------------------------------------------------------------------



*/--------------------------------------------------------------------\
*| Forms from the SAPLink Root Class                                  |
FORM convertstringtoixmldoc
      USING
        i_xmlstring TYPE string
      CHANGING
        ixmldocument TYPE REF TO if_ixml_document.

  DATA xmlstring TYPE string.
  DATA ixml TYPE REF TO if_ixml.
  DATA streamfactory TYPE REF TO if_ixml_stream_factory.
  DATA istream TYPE REF TO if_ixml_istream.
  DATA ixmlparser TYPE REF TO if_ixml_parser.
  DATA xmldoc TYPE REF TO if_ixml_document.

  xmlstring = i_xmlstring.
  " Make sure to convert Windows Line Break to Unix as
  " this linebreak is used to get a correct import
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf
    IN xmlstring WITH cl_abap_char_utilities=>newline.

  ixml = cl_ixml=>create( ).
  xmldoc = ixml->create_document( ).
  streamfactory = ixml->create_stream_factory( ).
  istream = streamfactory->create_istream_string( xmlstring ).
  ixmlparser = ixml->create_parser(  stream_factory = streamfactory
                                     istream        = istream
                                     document       = xmldoc ).
  ixmlparser->parse( ).
  ixmldocument = xmldoc.

ENDFORM.

*|                                                                     |
*|                                                                     |

FORM getobjectinfofromixmldoc
      USING ixmldocument TYPE REF TO if_ixml_document
      CHANGING objtypename TYPE string objname TYPE string.
  DATA rootnode TYPE REF TO if_ixml_node.
  DATA rootattr TYPE REF TO if_ixml_named_node_map.
  DATA attrnode TYPE REF TO if_ixml_node.
  DATA nodename TYPE string.

  rootnode ?= ixmldocument->get_root_element( ).

* get object type
  objtypename = rootnode->get_name( ).
  TRANSLATE objtypename TO UPPER CASE.

* get object name
  rootattr = rootnode->get_attributes( ).
  attrnode = rootattr->get_item( 0 ).
  objname = attrnode->get_value( ).

ENDFORM.

*/--------------------------------------------------------------------\
*|  Nugget Class                                                      |
FORM     installnugget
      USING xmldoc TYPE REF TO if_ixml_document overwrite TYPE c.
  TYPES: BEGIN OF t_objecttable,
           classname TYPE string,
           object    TYPE ko100-object,
           text      TYPE ko100-text,
         END OF t_objecttable.


  DATA iterator TYPE REF TO if_ixml_node_iterator.
  DATA ixml TYPE REF TO if_ixml.
  DATA namefilter TYPE REF TO if_ixml_node_filter.
  DATA parentfilter TYPE REF TO if_ixml_node_filter.
  DATA currentnode TYPE REF TO if_ixml_node.
  DATA newnode TYPE REF TO if_ixml_node.
  DATA rval TYPE i.
  DATA ixmldocument TYPE REF TO if_ixml_document.
  DATA _objname TYPE string.
  DATA objtype TYPE string.
  DATA objecttable TYPE TABLE OF t_objecttable.
  DATA objectline TYPE t_objecttable.
  DATA exists TYPE flag.
  DATA stemp TYPE string.
  DATA namecollision TYPE flag.
  DATA l_targetobject TYPE REF TO zsaplink.
  DATA l_installobject TYPE string.
  DATA l_excclass TYPE REF TO zcx_saplink.
  DATA tempcname TYPE string.

  ixml = cl_ixml=>create( ).
  namefilter = xmldoc->create_filter_name( name = 'nugget' ).
  parentfilter = xmldoc->create_filter_parent( namefilter ).
  iterator = xmldoc->create_iterator_filtered( parentfilter ).

  currentnode ?= iterator->get_next( ).
  WHILE currentnode IS NOT INITIAL.
    CLEAR exists.
    ixmldocument = ixml->create_document( ).
    newnode = currentnode->clone( ).
    rval = ixmldocument->append_child( newnode ).

    CALL METHOD zsaplink=>getobjectinfofromixmldoc
      EXPORTING
        ixmldocument = ixmldocument
      IMPORTING
        objtypename  = objtype
        objname      = _objname.

*  call method zsaplink=>getplugins( changing objectTable = objectTable )
*.
*
*  read table objectTable into objectLine with key object = objType.
*
*  if sy-subrc = 0.

    TRANSLATE objtype TO UPPER CASE.
    CASE objtype.
      WHEN 'CLAS'.
        tempcname = 'ZSAPLINK_CLASS'.
      WHEN 'PROG'.
        tempcname = 'ZSAPLINK_PROGRAM'.
      WHEN OTHERS.
    ENDCASE.

    CREATE OBJECT l_targetobject TYPE (tempcname)
      EXPORTING name = _objname.

    objectexists = l_targetobject->checkexists( ).

    IF objectexists = 'X' AND overwrt = ''.
      WRITE :/  objtype, _objname,
      ' exists on this system , if you wish to install this Nugget '
      & 'please set the Overwrite Originals checkbox.'
          .
    ELSEIF objectexists = 'X' AND overwrt = 'X'.

      IF l_targetobject IS NOT INITIAL.

        IF y2all <> 'X'.
          CONCATENATE objtype _objname INTO stemp SEPARATED BY space.
          PERFORM confirmoverwrite USING stemp
                                CHANGING flag.
          IF flag = '1'. "yes
          ELSEIF flag = '2'. "yes to all
            y2all = 'X'.
          ELSEIF flag = 'A'. "cancel
            WRITE / 'Import cancelled by user'.
*          Flag = 'X'.
            EXIT.
          ENDIF.
        ENDIF.
        TRY.
            l_installobject = l_targetobject->createobjectfromixmldoc(
                                            ixmldocument = ixmldocument
                                            overwrite = overwrt ).

          CATCH zcx_saplink INTO l_excclass.
            statusmsg = l_excclass->get_text( ).
            flag = 'X'.
        ENDTRY.
        IF l_installobject IS NOT INITIAL.
          CONCATENATE 'Installed: ' objtype l_installobject
           INTO statusmsg SEPARATED BY space.
        ENDIF.
      ELSE.
        statusmsg = 'an undetermined error occured'.
        flag = 'X'.
      ENDIF.

    ELSE.
      TRY.
          l_installobject = l_targetobject->createobjectfromixmldoc(
                                          ixmldocument = ixmldocument
                                          overwrite = overwrt ).

        CATCH zcx_saplink INTO l_excclass.
          statusmsg = l_excclass->get_text( ).
          flag = 'X'.
      ENDTRY.
      IF l_installobject IS NOT INITIAL.
        CONCATENATE 'Installed: ' objtype l_installobject
         INTO statusmsg SEPARATED BY space.
      ENDIF.
    ENDIF.
    currentnode ?= iterator->get_next( ).
    WRITE: / statusmsg.
  ENDWHILE.
ENDFORM.

*/----------------------confirmOverwrite------------------------------\
FORM confirmoverwrite USING l_objinfo TYPE string
                   CHANGING l_answer TYPE flag.

  DATA l_message TYPE string.
  DATA l_title TYPE string.

  CLEAR l_answer.
  l_title = 'Overwrite confirm. Proceed with CAUTION!'.

  CONCATENATE 'You have selected to overwrite originals.'
    l_objinfo 'will be overwritten. Are you sure?'
    INTO l_message SEPARATED BY space.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = l_title
      text_question         = l_message
      text_button_1         = 'Yes'
      text_button_2         = 'Yes to all'
      default_button        = '1'
      display_cancel_button = 'X'
    IMPORTING
      answer                = l_answer.
ENDFORM.
*\--------------------------------------------------------------------/
*/---------------------writeMessage-----------------------\
FORM writemessage USING VALUE(p_type) TYPE sy-msgty
                        VALUE(p_msg).
  CASE p_type.
    WHEN 'E' OR 'A' OR 'X'.
      WRITE / icon_led_red AS ICON.
    WHEN 'W'.
      WRITE / icon_led_yellow AS ICON.
    WHEN OTHERS.
      WRITE / icon_led_green AS ICON.
  ENDCASE.

  WRITE p_msg.
ENDFORM.                    "WriteMessage
