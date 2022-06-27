interface ZIF_PROMISE_STATE
  public .


  types STATE_TYPE type STRING .

  constants PENDING type STATE_TYPE value 'pending' ##NO_TEXT.
  constants REJECTED type STATE_TYPE value 'rejected' ##NO_TEXT.
  constants FULFILLED type STATE_TYPE value 'fulfilled' ##NO_TEXT.
  data STATE type STATE_TYPE read-only .
  data RESULT type ref to DATA read-only .

  events STATE_CHANGED .
endinterface.
