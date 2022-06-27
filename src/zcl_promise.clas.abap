class ZCL_PROMISE definition
  public
  inheriting from ZCL_ABAP_ASYNC
  final
  create public

  global friends ZCL_ABAP_ASYNC .

public section.

  interfaces ZIF_PROMISE .

  aliases THEN
    for ZIF_PROMISE~THEN .

  types:
    RESULTS TYPE TABLE OF REF TO data WITH EMPTY KEY .
  types:
    PROMISES TYPE TABLE OF REF TO zcl_promise WITH EMPTY KEY .

  methods CONSTRUCTOR
    importing
      !RESOLVER type ref to ZCL_PROMISE_RESOLVER .
  class-methods ALL
    importing
      !PROMISES type PROMISES
    returning
      value(RESULT) type ref to ZIF_PROMISE .
  class-methods RESOLVE
    importing
      !WITH type ANY optional
    returning
      value(RESULT) type ref to ZIF_PROMISE .
  class-methods REJECT
    importing
      !REASON type ANY optional
    returning
      value(RESULT) type ref to ZIF_PROMISE .
protected section.
private section.

  data STATE type ref to ZIF_PROMISE_STATE .
  data:
    HANDLERS TYPE TABLE OF REF TO zif_promise_handler WITH EMPTY KEY .

  methods ON_STATE_CHANGED
    for event STATE_CHANGED of ZIF_PROMISE_STATE .
ENDCLASS.



CLASS ZCL_PROMISE IMPLEMENTATION.


  method all.

    " wait for all promises to be settled
    wait for asynchronous tasks
    until line_exists( promises[ table_line->state->state = zif_promise_state=>rejected ] )
    or not line_exists( promises[ table_line->state->state = zif_promise_state=>pending ] ).

    data lt_results type results. " type table of ref to data with empty key.

    LOOP at promises INTO data(promise).
      CASE promise->state->state .
        WHEN zif_promise_state=>rejected.
          result = reject( promise->state->result ).
          return.
        WHEN OTHERS.
          APPEND promise->state->result to lt_results.
      ENDCASE.
    ENDLOOP.

    result = resolve( new results( lt_results ) ).

  endmethod.


  method constructor.

    super->constructor( ).

    " Promise.resolve/Promise.reject support
    try.
        me->state = cast lcl_settled_promise( resolver )->state.
      catch cx_sy_move_cast_error.
        "create async task
        me->state = new zcl_abap_async_task( resolver )->state.
    endtry.

    set HANDLER on_state_changed for me->state.

  endmethod.


method on_state_changed.

  " makes sense to process only if it's changed
  check state->state ne state->pending.

  loop at handlers into data(handler).

    " delete handler if it's non-pending.
    delete handlers index sy-tabix.
    check handler is bound.

    case state->state.
      when state->fulfilled.
        handler->on_fulfilled( state->result ).
      when state->rejected.
        handler->on_rejected( state->result ).
    endcase.

  endloop.

endmethod.


  method reject.

    result = new zcl_promise( new lcl_rejected( ref=>from( reason ) ) ).

  endmethod.


  method resolve.

    result = new zcl_promise( new lcl_resolved( ref=>from( with ) ) ).

  endmethod.


  method zif_promise~then.

    APPEND handler to handlers.

    " in case if state is not pending already
    me->on_state_changed( ).

    " chaining support
    result = me.

  endmethod.
ENDCLASS.
