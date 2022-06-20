*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_promise_resolver definition deferred.

class lcl_promise_state definition friends lcl_promise_resolver zcl_promise.
  public section.
    interfaces zif_promise_state.

    aliases state for zif_promise_state~state.
    aliases with for zif_promise_state~with.
    aliases pending for zif_promise_state~pending.
    aliases resolved for zif_promise_state~resolved.
    aliases rejected for zif_promise_state~rejected.
    aliases state_type for zif_promise_state~state_type.

    methods constructor importing
                          state type state_type optional
                          with  type ref to data optional.

endclass.

class lcl_promise_state implementation.
  method constructor.
    me->state = state.
    me->with = with.
  endmethod.
endclass.

class lcl_promise_resolver definition "create private
  inheriting from zcl_promise_resolver friends zcl_promise .
  public section.
    methods constructor
      importing
        thenable type ref to zif_abap_thenable optional
        state    type ref to lcl_promise_state optional
          preferred parameter thenable.

    methods then redefinition.

  private section.
    data resolver type ref to zif_abap_thenable.
    data state type ref to lcl_promise_state.
endclass.

*class lcl_settled_promise definition abstract inheriting from lcl_promise_resolver.
*  public section.
*    methods constructor importing with type ref to data.
*endclass.
*
*class lcl_resolved definition inheriting from lcl_settled_promise.
*endclass.
*
*class lcl_rejected definition inheriting from lcl_settled_promise.
*endclass.

class lcl_promise_resolver implementation.

  method constructor.
    super->constructor( ).
    me->resolver = thenable.

    try.
        " promise.resolve / promise.reject support
        me->state = cond #(
          when state is bound then state
          else cast lcl_promise_resolver( thenable )->state ).
      catch cx_sy_move_cast_error.
        me->state = new #( ).
    endtry.


  endmethod.

  method then.

    case state->state.

      when state->pending.

        try.
            state->with = await( resolver ).
            state->state = state->resolved.

          catch zcx_promise_rejected into data(lo_cx).

            state->with = lo_cx->with.
            state->state = state->rejected.

        endtry.

    endcase.

  endmethod.

endclass.

class lcl_resolved definition inheriting from lcl_promise_resolver.
  public section.
    methods constructor
      importing with type ref to data.
endclass.

class lcl_resolved implementation.
  method constructor.
    super->constructor(
      state = new #(
        state = zif_promise_state=>resolved
        with = with
        )
        ).
  endmethod.
endclass.

class lcl_rejected definition inheriting from lcl_promise_resolver.
  public section.
    methods constructor
      importing with type ref to data.
endclass.

class lcl_rejected implementation.
  method constructor.
    super->constructor(
      state = new #(
        state = zif_promise_state=>rejected
        with = with ) ).
  endmethod.
endclass.

CLASS ref DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-METHODS:
      from IMPORTING from TYPE any RETURNING VALUE(ref) TYPE REF TO data.
ENDCLASS.

CLASS ref IMPLEMENTATION.
  METHOD from.
    TRY.
      ref = cast #( from ).
    CATCH cx_sy_move_cast_error.
      ref = ref #( from ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
