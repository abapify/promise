interface ZIF_PROMISE_STATE
  public .


  types STATE_TYPE type I .

  constants PENDING type STATE_TYPE value 0 ##NO_TEXT.
  constants REJECTED type STATE_TYPE value 2 ##NO_TEXT.
  constants RESOLVED type STATE_TYPE value 1 ##NO_TEXT.
  constants UNHANDLED_REJECTION type STATE_TYPE value 3 ##NO_TEXT.
  data STATE type STATE_TYPE read-only .
  data WITH type ref to DATA read-only .
endinterface.
