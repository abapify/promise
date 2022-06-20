*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_async_task definition deferred.

class lcl_state definition friends lcl_async_task.

  public section.

    interfaces:
      zif_promise_state.
    aliases state for zif_promise_state~state.
    aliases with for zif_promise_state~with.
    aliases pending for zif_promise_state~pending.
    aliases resolved for zif_promise_state~resolved.
    aliases unhandled_rejection for zif_promise_state~unhandled_rejection.
    aliases rejected for zif_promise_state~rejected.
endclass.

class lcl_async_task definition.
  public section.
    types task_id_type type sysuuid_c32.
    methods constructor importing thenable type ref to zif_abap_thenable.
    methods await importing p_task type task_id_type.
    data state type ref to lcl_state read-only.
  private section.
    data: task_id type task_id_type.


endclass.

class lcl_async_task implementation.

  method constructor.

    try.

        call transformation id
          source object = thenable
          result xml data(lv_thenable_xml).

        me->task_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( ).
        me->state = new lcl_state( ).

        call function 'ZABAP_ASYNC_AWAIT' starting new task me->task_id
          calling await on end of task
          exporting
            for = lv_thenable_xml.

      catch cx_uuid_error.    "
    endtry.

  endmethod.

  method await.

    data await_xml type xstring.
    data await_state type i.

    receive results from function 'ZABAP_ASYNC_AWAIT'
     importing
       with = await_xml
       state = await_state
       exceptions
         others = 4.

    case sy-subrc.
      when 0.

        state->state = await_state.

        case state->state.
          when state->resolved or state->rejected.

            if await_xml is not initial.
              call transformation id
                source xml await_xml
                result data = state->with.
            endif.
            state->state = await_state.

          when state->unhandled_rejection.

            TYPES cx_no_check_ref TYPE REF TO cx_no_check.

            data lo_cx type ref to cx_no_check.

            call transformation id
                source xml await_xml
                result cx_no_check = lo_cx.

            state->with = new cx_no_check_ref( lo_cx ).

            "raise exception lo_cx.

        endcase.

      when others.
        state->state = zif_promise_state=>unhandled_rejection.
        message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into data(lv_message).
        state->with = new string( lv_message ).

    endcase.

  endmethod.

endclass.
