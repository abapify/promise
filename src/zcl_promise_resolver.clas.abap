class ZCL_PROMISE_RESOLVER definition
  public
  inheriting from ZCL_ABAP_ASYNC
  abstract
  create public

  global friends ZCL_ABAP_ASYNC
                 ZCL_ABAP_SYNC .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces ZIF_ABAP_THENABLE
      all methods abstract .

  aliases THEN
    for ZIF_ABAP_THENABLE~THEN .

  class-methods CLASS_CONSTRUCTOR .
protected section.

  methods RESOLVE
  final
    importing
      !WITH type ANY optional .
  methods REJECT
  final
    importing
      !WITH type ANY optional .
private section.

  types STATUS_TV type I .

  class-data PROMISE_EXCEPTION_TYPE type ref to CL_ABAP_OBJECTDESCR .
ENDCLASS.



CLASS ZCL_PROMISE_RESOLVER IMPLEMENTATION.


  method class_constructor.

    types promise_exception_ref type ref to lcx_promise_state_changed.

    promise_exception_type = cast #( cast cl_abap_refdescr(
      cl_abap_typedescr=>describe_by_data_ref(
        new promise_exception_ref( ) )
    )->get_referenced_type( ) ).

  endmethod.


  method REJECT.
    RAISE EXCEPTION TYPE lcx_promise_rejected EXPORTING with = ref=>from( with ).
  endmethod.


  method RESOLVE.

    RAISE EXCEPTION TYPE lcx_promise_resolved EXPORTING with = ref=>from( with ).

  endmethod.
ENDCLASS.
