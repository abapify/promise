*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_resolved definition deferred.
class lcl_rejected definition deferred.


class lcl_settled_promise definition abstract create protected
  inheriting from zcl_promise_resolver friends zcl_promise lcl_resolved lcl_rejected  .

  PUBLIC SECTION.
    METHODs then REDEFINITION.

  protected section.
    data state type ref to zif_promise_state.

endclass.

CLASS lcl_settled_promise IMPLEMENTATION.
  METHOD then.
  ENDMETHOD.
endclass.

class lcl_resolved definition inheriting from lcl_settled_promise create private friends zcl_promise.
  public section.
    methods constructor
      importing with type ref to data.
endclass.

class lcl_rejected definition inheriting from lcl_settled_promise create private friends zcl_promise.
  public section.
    methods constructor
      importing with type ref to data.
endclass.

class lcl_resolved implementation.
  method constructor.
    super->constructor( ).
    state = new zcl_promise_state( )->resolve( with ).
  endmethod.
endclass.

class lcl_rejected implementation.
  method constructor.
    super->constructor( ).
    state = new zcl_promise_state( )->reject( with ).
  endmethod.
endclass.

class ref definition abstract.
  public section.
    class-methods:
      from importing from type any returning value(ref) type ref to data.
endclass.

class ref implementation.
  method from.
    try.
        ref = cast #( from ).
      catch cx_sy_move_cast_error.
        ref = ref #( from ).
    endtry.
  endmethod.
endclass.
