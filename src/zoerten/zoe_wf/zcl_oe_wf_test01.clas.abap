class ZCL_OE_WF_TEST01 definition
  public
  final
  create public .

public section.

  interfaces BI_OBJECT .
  interfaces BI_PERSISTENT .
  interfaces IF_WORKFLOW .

  data M_KEY type CHAR10 .

  methods CONSTRUCTOR
    importing
      !I_ID type CHAR10 .
  methods GET_RESULT
    importing
      !P1 type I
      !P2 type I
    exporting
      !P3 type I .
  class-methods CREATE
    importing
      !I_ID type CHAR10
    exporting
      !E_INSTANCE type ref to ZCL_OE_WF_TEST01 .
protected section.
private section.

  data M_LPOR type SIBFLPOR .
ENDCLASS.



CLASS ZCL_OE_WF_TEST01 IMPLEMENTATION.


  METHOD bi_persistent~find_by_lpor.

    CREATE OBJECT result
      TYPE
      zcl_oe_wf_test01
      EXPORTING
        i_id = lpor-instid(10).

  ENDMETHOD.


  METHOD bi_persistent~lpor.

    result = me->m_lpor.

  ENDMETHOD.


  METHOD constructor.

    m_lpor-instid = i_id.
    m_lpor-catid = 'CL'.
    m_lpor-typeid = 'ZCL_OE_WF_TEST01'.

  ENDMETHOD.


  METHOD create.

    CREATE OBJECT e_instance
      TYPE
      zcl_oe_wf_test01
      EXPORTING
        i_id = i_id.

  ENDMETHOD.


  METHOD get_result.

    p3 = p1 * p2.

  ENDMETHOD.
ENDCLASS.
