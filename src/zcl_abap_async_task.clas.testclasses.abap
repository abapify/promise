*"* use this source file for your ABAP unit test classes

*"* use this source file for your ABAP unit test classes

class tcl_main definition INHERITING FROM zcl_abap_async
  for testing  risk level harmless duration short.
  private section.

    methods test_await_resolved for testing.
    methods test_await_rejected for testing.
    methods test_any_other_cx for testing.
    methods test_no_resolution for testing.
    methods test_no_async for testing.

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

class tcl_other_cx definition FOR TESTING inheriting from zcl_promise_resolver.
  public section.
    methods then redefinition.
endclass.

class lcx_other_cx definition inheriting from cx_no_check.
endclass.

class tcl_other_cx implementation.
  method then.
    raise exception type lcx_other_cx.
  endmethod.
endclass.

class tcl_dummy_resolver definition for testing inheriting from zcl_promise_resolver.
  public section.
    methods then redefinition.
endclass.

class tcl_dummy_resolver implementation.
  method then.
    " no resolve or reject call
  endmethod.
endclass.



class tcl_main implementation.

  method test_await_resolved.

    try.

        data(result) = cast string( await( new tcl_resolved( ) ) ).

        cl_abap_unit_assert=>assert_equals(
          exporting
            act                  = result->*    " Data object with current value
            exp                  = tcl_resolved=>resolution    " Data object with expected type
        ).

      catch zcx_promise_rejected.

        cl_abap_unit_assert=>fail( 'Must be no exception' ).

    endtry.

  endmethod.

  method test_await_rejected.

    try.

        data(lr_result) = await( new tcl_rejected( ) ).

        cl_abap_unit_assert=>fail( 'Exception is not raised' ).

      catch zcx_promise_rejected into data(lo_cx).

        data(result) = cast string( lo_cx->with ).

        cl_abap_unit_assert=>assert_equals(
          exporting
            act                  = result->*    " Data object with current value
            exp                  = tcl_rejected=>resolution    " Data object with expected type
        ).

    endtry.

  endmethod.

  method test_any_other_cx.

    try.
        await( new tcl_other_cx( ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_promise_rejected.
        cl_abap_unit_assert=>fail( ).
      catch lcx_other_cx.
        return.
    endtry.



  endmethod.

  method test_no_resolution.

    try.
        await( new tcl_dummy_resolver( ) ).
        cl_abap_unit_assert=>fail( 'Should not be resolved' ).
      catch zcx_promise_not_resolved.
      catch zcx_promise_rejected.
        cl_abap_unit_assert=>fail( 'Should not be rejected' ).
    endtry.

  endmethod.

  method test_no_async.

    try.

      cl_abap_refdescr=>get_ref_to_data( ).

        data(result) = cast abap_bool( await( abap_true ) ).

        " should proxy the values - if it's not async
        cl_abap_unit_assert=>assert_true( result->* ).

      catch zcx_promise_rejected.
        cl_abap_unit_assert=>fail( ).
    endtry.

  endmethod.
endclass.
