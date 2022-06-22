*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcx_promise_state_changed definition inheriting from cx_no_check.
  public section.
    interfaces zif_promise_state.
    methods constructor importing with type ref to data.
  protected section.

    aliases with for zif_promise_state~result.
    aliases state for zif_promise_state~state.
    aliases resolved for zif_promise_state~fulfilled.
    aliases rejected for zif_promise_state~rejected.

  private section.

endclass.

class lcx_promise_resolved definition inheriting from lcx_promise_state_changed friends zcl_promise_resolver.
  public section.
    methods constructor importing with type ref to data.
endclass.

class lcx_promise_rejected definition inheriting from lcx_promise_state_changed friends zcl_promise_resolver.
  public section.
    methods constructor importing with type ref to data.
endclass.

class lcx_promise_state_changed implementation.
  method constructor.
    super->constructor( ).
    me->with = with.
  endmethod.
endclass.

class lcx_promise_resolved implementation.
  method constructor.
    super->constructor( with ).
    me->state = resolved.
  endmethod.
endclass.

class lcx_promise_rejected implementation.
  method constructor.
    super->constructor( with ).
    me->state = rejected.
  endmethod.
endclass.
