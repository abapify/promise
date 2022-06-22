class ZCL_ABAP_ASYNC_TASK definition
  public
  final
  create private

  global friends ZCL_ABAP_ASYNC
                 ZCL_PROMISE .

public section.

  data STATE type ref to Zcl_PROMISE_STATE read-only .

  methods CONSTRUCTOR
    importing
      !THENABLE type ref to ZIF_ABAP_THENABLE .
  protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP_ASYNC_TASK IMPLEMENTATION.


  method constructor.

    me->state = new lcl_async_task( thenable )->state.

  endmethod.
ENDCLASS.
