interface ZIF_PROMISE_HANDLER
  public .


  methods ON_FULFILLED
    importing
      !WITH type ref to DATA .
  methods ON_REJECTED
    importing
      !WITH type ref to DATA .
endinterface.
