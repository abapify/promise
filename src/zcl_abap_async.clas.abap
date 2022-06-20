class ZCL_ABAP_ASYNC definition
  public
  create public .

public section.

  interfaces ZIF_ABAP_ASYNC .

  aliases AWAIT
    for ZIF_ABAP_ASYNC~AWAIT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP_ASYNC IMPLEMENTATION.


  method zif_abap_async~await.

    " promise handling
    try.
        data(state) = cast zcl_promise( for )->state.
      catch cx_sy_move_cast_error.

        " direct thenable assignment
        try.
            state = new lcl_async_task( cast #( for ) )->state.
          catch cx_sy_move_cast_error.
        endtry.

    endtry.

    " fallback
    if state is not bound.
      result = ref #( for ).
      return.
    endif.

    wait for asynchronous tasks until state->state ne state->pending.

    case state->state.
      when state->resolved.
        result = state->with.
      when state->rejected.
        raise exception type zcx_promise_rejected
          exporting
            with = state->with.
      when state->unhandled_rejection.

        try.
            types cx_no_check_type type ref to cx_no_check.
            data(lo_cx) = cast cx_no_check_type( state->with ).
            raise exception lo_cx->* .
          catch cx_sy_move_cast_error.
            raise exception type zcx_promise_not_resolved.
        endtry.

    endcase.

  endmethod.
ENDCLASS.
