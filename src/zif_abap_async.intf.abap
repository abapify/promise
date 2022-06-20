interface ZIF_ABAP_ASYNC
  public .


  class-methods AWAIT
    importing
      !FOR type ANY
    returning
      value(RESULT) type ref to DATA
    raising
      ZCX_PROMISE_REJECTED .
endinterface.
