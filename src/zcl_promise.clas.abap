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

  types RESULTS TYPE TABLE OF REF TO data WITH EMPTY KEY .
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

  data RESOLVER type ref to ZIF_ABAP_THENABLE .
  data STATE type ref to ZIF_PROMISE_STATE .
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
          result = reject( promise->state->with ).
          return.
        WHEN OTHERS.
          APPEND promise->state->with to lt_results.
      ENDCASE.
    ENDLOOP.

    result = resolve( new results( lt_results ) ).

  endmethod.


  method constructor.

    super->constructor( ).

    data(lo_resolver) = new lcl_promise_resolver( resolver ).

    me->resolver = lo_resolver.
    me->state = lo_resolver->state.

    lo_resolver->then( ).

  endmethod.


  method reject.

    result = new zcl_promise( new lcl_rejected( ref=>from( reason ) ) ).

  endmethod.


  method RESOLVE.

    result = new zcl_promise( new lcl_resolved( ref=>from( with ) ) ).

  endmethod.


  method zif_promise~then.

    " triggering callbacks
    case state->state.
      when state->resolved.
        if handler is bound.
          handler->on_fulfilled( with = state->with ).
        endif.
      when state->rejected.
        if handler is bound.
          handler->on_rejected( with = state->with ).
        endif.
*      when others.
*        " if promise is still pending - something went wrongly
*        raise exception type zcx_promise_not_resolved.
    endcase.

    " chaining support
    result = me.

  endmethod.
ENDCLASS.
