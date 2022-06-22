function zabap_async_await.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FOR) TYPE  XSTRING
*"  EXPORTING
*"     VALUE(WITH) TYPE  XSTRING
*"     VALUE(STATE) TYPE  STRING
*"----------------------------------------------------------------------

  data resolver type ref to zif_abap_thenable.

  " deserialize request
  call transformation id
    source xml for
    result object = resolver.

  try.
      data(result) = zcl_abap_sync=>await( for = resolver ).

      state = zif_promise_state=>fulfilled.

    catch zcx_promise_rejected into data(lo_cx_rejected).  "

      result = lo_cx_rejected->with.

      state = zif_promise_state=>rejected.

    catch cx_no_check into data(lo_cx).

      call transformation id
        source cx_no_check = lo_cx
        result xml with
        options data_refs = 'heap-or-create'.

      state = zif_promise_state=>rejected.

  endtry.

  if result is bound.

    call transformation id
        source data = result
        result xml with
        options data_refs = 'heap-or-create'.

  endif.







endfunction.
