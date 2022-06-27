interface ZIF_PROMISE
  public .


  types:
    PROMISES TYPE table of REF TO ZIF_PROMISE WITH EMPTY KEY .

  methods THEN
    importing
      !HANDLER type ref to ZIF_PROMISE_HANDLER
    returning
      value(RESULT) type ref to ZIF_PROMISE .
endinterface.
