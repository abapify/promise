*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_async_task definition deferred.

class lcl_async_task definition CREATE PRIVATE FRIENDS zcl_abap_async_task.
  public section.

    types task_id_type type sysuuid_c32.
    methods constructor importing thenable type ref to zif_abap_thenable.
    methods await importing p_task type task_id_type.

  private section.
    data: task_id type task_id_type.
    data state type ref to zcl_promise_state.


endclass.

class lcl_async_task implementation.

  method constructor.

    try.

        call transformation id
          source object = thenable
          result xml data(lv_thenable_xml).

        me->task_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( ).
        me->state = new zcl_promise_state( ).

        call function 'ZABAP_ASYNC_AWAIT' starting new task me->task_id
          calling await on end of task
          exporting
            for = lv_thenable_xml.

      catch cx_uuid_error.    "
    endtry.

  endmethod.

  method await.

    data await_xml type xstring.
    data await_state type string.

    receive results from function 'ZABAP_ASYNC_AWAIT'
     importing
       with = await_xml
       state = await_state
       exceptions
         others = 4.

    case sy-subrc.
      when 0.

        if await_xml is not initial.
          data with type ref to data.
          call transformation id
            source xml await_xml
            result data = with.
        endif.

        case await_state.
          when zif_promise_state=>fulfilled.
            state->resolve( with ).
          when zif_promise_state=>rejected.
            state->reject( with ).
        endcase.

      when others.
        message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into data(lv_message).
        state->reject( new string( lv_message ) ).
    endcase.

  endmethod.

endclass.
