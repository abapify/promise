*"* use this source file for your ABAP unit test classes
class tcl_main definition inheriting from zcl_promise_resolver for testing risk level harmless duration short.
  public section.
    methods test_resolve for testing.
    methods test_reject for testing.
    METHODs then REDEFINITION.
endclass.

class tcl_resolved definition for testing inheriting from zcl_promise_resolver.
  public section.
    constants resolution type string value 'OK'.
    methods then redefinition.
endclass.

class tcl_resolved implementation.
  method then.
    resolve( resolution ).
  endmethod.
endclass.

class tcl_rejected definition for testing inheriting from zcl_promise_resolver.
  public section.
    constants resolution type string value 'Error'.
    methods then redefinition.
endclass.

class tcl_rejected implementation.
  method then.
    reject( resolution ).
  endmethod.
endclass.


class tcl_main implementation.
  METHOD then.
    "needed because parent is abstract
    "we need this inheritance to access with variable of exception
  endmethod.
  method test_resolve.

    try.
        new tcl_resolved( )->then( ).

        cl_abap_unit_assert=>fail( 'Should exit after resolve' ).

      catch lcx_promise_resolved into data(lo_cx).

        cl_abap_unit_assert=>assert_bound( lo_cx->with ).

        assign lo_cx->with->* to field-symbol(<lv_resolution>).

        cl_abap_unit_assert=>assert_equals(
          exporting
            act                  = <lv_resolution>    " Data object with current value
            exp                  = tcl_resolved=>resolution    " Data object with expected type
        ).

    endtry.

  endmethod.

  method test_reject.

    try.
        new tcl_rejected( )->then( ).

        cl_abap_unit_assert=>fail( 'Should exit after resolve' ).

      catch lcx_promise_rejected into data(lo_cx).

        cl_abap_unit_assert=>assert_bound( lo_cx->with ).

        assign lo_cx->with->* to field-symbol(<lv_resolution>).

        cl_abap_unit_assert=>assert_equals(
          exporting
            act                  = <lv_resolution>    " Data object with current value
            exp                  = tcl_rejected=>resolution    " Data object with expected type
        ).

    endtry.

  endmethod.
endclass.
