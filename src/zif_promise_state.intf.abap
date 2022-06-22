interface zif_promise_state
  public .


  types state_type type string .

  constants pending type state_type value 'pending' ##NO_TEXT.
  constants rejected type state_type value 'rejected' ##NO_TEXT.
  constants fulfilled type state_type value 'fulfilled'  ##NO_TEXT.

  data state type state_type read-only .
  data result type ref to data read-only .
endinterface.
