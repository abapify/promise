class ZCL_PROMISE_STATE definition
  public
  final
  create public

  global friends ZCL_ABAP_ASYNC_TASK .

public section.

  interfaces ZIF_PROMISE_STATE .

  methods CONSTRUCTOR .
  methods RESOLVE
    importing
      !WITH type ref to DATA RETURNING VALUE(this) TYPE REF TO zcl_promise_state.

  methods REJECT
    importing
      !WITH type ref to DATA RETURNING VALUE(this) TYPE REF TO zcl_promise_state.
protected section.
private section.

  aliases FULFILLED
    for ZIF_PROMISE_STATE~FULFILLED .
  aliases PENDING
    for ZIF_PROMISE_STATE~PENDING .
  aliases REJECTED
    for ZIF_PROMISE_STATE~REJECTED .
  aliases RESULT
    for ZIF_PROMISE_STATE~RESULT .
  aliases STATE
    for ZIF_PROMISE_STATE~STATE .
ENDCLASS.



CLASS ZCL_PROMISE_STATE IMPLEMENTATION.


  method CONSTRUCTOR.
    me->state = pending.
  endmethod.


  method REJECT.

    ASSERT state eq pending.
    state = rejected.
    result = with.
    this = me.

  endmethod.


  method RESOLVE.
    ASSERT state eq pending.
    state = fulfilled.
    result = with.
    this = me.
  endmethod.
ENDCLASS.
