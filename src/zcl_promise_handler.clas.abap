class ZCL_PROMISE_HANDLER definition
  public
  create public .

public section.

  interfaces ZIF_PROMISE_HANDLER .

  aliases ON_FULFILLED
    for ZIF_PROMISE_HANDLER~ON_FULFILLED .
  aliases ON_REJECTED
    for ZIF_PROMISE_HANDLER~ON_REJECTED .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PROMISE_HANDLER IMPLEMENTATION.


  method ZIF_PROMISE_HANDLER~ON_FULFILLED.
  endmethod.


  method ZIF_PROMISE_HANDLER~ON_REJECTED.
  endmethod.
ENDCLASS.
