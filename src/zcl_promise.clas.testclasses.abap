*"* use this source file for your ABAP unit test classes
class tcl_main definition inheriting from zcl_abap_async
   for testing risk level harmless duration short.
  public section.
    interfaces: zif_promise_handler.
  private section.
    methods test_resolved for testing.
    methods test_rejected for testing.
    methods test_no_resolution for testing.
    methods test_promise_all_true for testing.
    methods test_promise_all_false for testing.
    methods test_ref for testing.
    data on_fulfilled type abap_bool.
    data on_rejected type abap_bool.
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

  method test_resolved.

    " this code will start a new session
    data(promise) = new zcl_promise( new tcl_resolved( ) )->then( me ).

    " however result is not yet here
    " it should not be processed yet
    cl_abap_unit_assert=>assert_false( on_fulfilled ).
    cl_abap_unit_assert=>assert_false( on_rejected ).

    " now we await for promise execution + validate result
    try.
        cl_abap_unit_assert=>assert_equals(
          act = cast string( await( promise ) )->*
          exp = tcl_resolved=>resolution ).
      catch zcx_promise_rejected.
        cl_abap_unit_assert=>fail( ).
    endtry.

    " and now we expect that is resolved
    cl_abap_unit_assert=>assert_true( on_fulfilled ).
    cl_abap_unit_assert=>assert_false( on_rejected ).

  endmethod.

  method test_rejected.
    " this code will start a new session
    data(promise) = new zcl_promise( new tcl_rejected( ) )->then( me ).

    " however result is not yet here
    " it should not be processed yet
    cl_abap_unit_assert=>assert_false( on_fulfilled ).
    cl_abap_unit_assert=>assert_false( on_rejected ).

    " now we await for promise execution + validate result
    try.
        await( promise ).
        cl_abap_unit_assert=>fail( ).
      catch zcx_promise_rejected into data(lo_cx).

        cl_abap_unit_assert=>assert_equals(
          act = cast string( lo_cx->with )->*
          exp = tcl_rejected=>resolution ).

    endtry.

    " and now we expect that is resolved
    cl_abap_unit_assert=>assert_false( on_fulfilled ).
    cl_abap_unit_assert=>assert_true( on_rejected ).


  endmethod.

  method zif_promise_handler~on_fulfilled.

    check with is bound.

    assign with->* to field-symbol(<lv_with>).

    cl_abap_unit_assert=>assert_equals(
      exporting
        act                  = <lv_with>     " Data object with current value
        exp                  = tcl_resolved=>resolution    " Data object with expected type
    ).

    on_fulfilled = abap_true.

  endmethod.

  method zif_promise_handler~on_rejected.

    check with is bound.

    assign with->* to field-symbol(<lv_with>).

    cl_abap_unit_assert=>assert_equals(
      exporting
        act                  = <lv_with>     " Data object with current value
        exp                  = tcl_rejected=>resolution    " Data object with expected type
    ).

    on_rejected = abap_true.

  endmethod.

  method test_no_resolution.

    try.
        new zcl_promise( new tcl_dummy_resolver( ) )->then( me ).
        cl_abap_unit_assert=>assert_false( on_fulfilled ).
        cl_abap_unit_assert=>assert_false( on_rejected ).
      catch zcx_promise_not_resolved.
    endtry.

  endmethod.

  method test_promise_all_true.

    " two resolved promises
    data(lo_promise) = zcl_promise=>all( value #(
      ( new #( new tcl_resolved( ) ) )
      ( new #( new tcl_resolved( ) ) )
    ) ).

    " await
    try.
        data(lr_results) = cast zcl_promise=>results( await( lo_promise ) ).
      catch zcx_promise_rejected.
        cl_abap_unit_assert=>fail( ).
    endtry.

    cl_abap_unit_assert=>assert_equals(
      act = lines( lr_results->* )
      exp = 2
    ).

    " every line must be OK
    loop at lr_results->* into data(lr_result).
      cl_abap_unit_assert=>assert_equals(
        exporting
          act                  = cast string( lr_result )->*     " Data object with current value
          exp                  = tcl_resolved=>resolution    " Data object with expected type
      ).
    endloop.

  endmethod.

  method test_promise_all_false.

    " two resolved promises
    data(lo_promise) = zcl_promise=>all( value #(
      ( new #( new tcl_resolved( ) ) )
      ( new #( new tcl_rejected( ) ) )
    ) ).

    " await
    try.
        data(lr_result) = cast string( await( lo_promise ) ).
        cl_abap_unit_assert=>fail( ).
      catch zcx_promise_rejected into data(lo_cx).

        cl_abap_unit_assert=>assert_equals(
        exporting
          act                  = cast string( lo_cx->with )->*     " Data object with current value
          exp                  = tcl_rejected=>resolution    " Data object with expected type
      ).

    endtry.

  endmethod.

  method test_ref.

    cl_abap_unit_assert=>assert_true( cast abap_bool( ref=>from( abap_true ) )->* ).
    cl_abap_unit_assert=>assert_true( cast abap_bool( ref=>from( ref #( abap_true ) ) )->* ).

  endmethod.

endclass.
