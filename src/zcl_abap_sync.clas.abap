class ZCL_ABAP_SYNC definition
  public
  create public .

public section.

  class-methods AWAIT
    importing
      !FOR type ANY
    returning
      value(RESULT) type ref to DATA
    raising
      ZCX_PROMISE_REJECTED .
protected section.
private section.

  class-methods GET_THENABLE
    importing
      !FROM type ANY
    returning
      value(RESULT) type ref to ZIF_ABAP_THENABLE .
ENDCLASS.



CLASS ZCL_ABAP_SYNC IMPLEMENTATION.


  method AWAIT.

    try.

        " if it's thenable
        data(thenable) = get_thenable( from = for ).

        if thenable is not bound.

          result = ref #( for ).
*          try.
*              result = cast #( for ).
*            catch cx_sy_move_cast_error.
*              result = ref #( for ).
*          endtry.
          return.
        endif.

        thenable->then( ).

        raise exception type zcx_promise_not_resolved.

      catch cx_no_check into data(lo_cx).

        if zcl_promise_resolver=>promise_exception_type->applies_to( lo_cx ) eq abap_true.

          " no need to check cast because type check
          data(state) = cast zif_promise_state( lo_cx ).
          case state->state.
            when state->rejected.
              raise exception type zcx_promise_rejected
                exporting
                  previous = lo_cx
                  with     = state->result.
            when state->fulfilled.
              result = state->result.
              return.
          endcase.

        endif.

        raise exception lo_cx.

    endtry.

  endmethod.


  method GET_THENABLE.

    " if thenable
    try.
        result = cast #( from ).
        return.
      CATCH cx_sy_move_cast_error.
    endtry.

    " if thenable
*    try.
*        result = cast zcl_promise( from )->resolver.
*        return.
*      CATCH cx_sy_move_cast_error.
*    endtry.

  endmethod.
ENDCLASS.
