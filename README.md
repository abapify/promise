# Let's make ABAP async!

To understand how this class work use this as a reference:
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## How to use

### Promise

what runs in js

```js
new Promise( ( resolve, reject ) => { resolve( 'OK' ) } ).then( ( value ) => console.log( value )  ) // OK
```

now runs in ABAP ( with a bit more lines of course )
```abap
REPORT ZTEST_PROMISE_OK.

" Promise Resolver
" Must implement then method with mandatory resolve or reject method calls from inside
CLASS lcl_ok DEFINITION INHERITING FROM zcl_promise_resolver.
  PUBLIC SECTION.
    METHODS then REDEFINITION.
ENDCLASS.

CLASS lcl_ok IMPLEMENTATION.
  METHOD then.
    " resolve is declared in zcl_promise_resolver
    resolve( |OK| ).
  ENDMETHOD.
ENDCLASS.

" Promise handler
" has on_fulfilled and on_rejected callbacks with default empty implementation
CLASS lcl_ok_handler DEFINITION INHERITING FROM zcl_promise_handler.
  PUBLIC SECTION.
    METHODS ON_FULFILLED REDEFINITION.
ENDCLASS.

CLASS lcl_ok_handler IMPLEMENTATION.
  METHOD on_fulfilled.
    " ideally resolver needs to know which type it expects to have as a result
    write cast string( with )->*.
  ENDMETHOD.
endclass.

START-OF-SELECTION.
    
  new zcl_promise( new lcl_ok( ) )->then( new lcl_ok_handler( ) ).
```

### So what's the purpose? 

You probably think, why we wouldn't just run `write 'OK'`

The answer is in the following sequence diagram

![zcl_promise](https://user-images.githubusercontent.com/6381507/175093547-7f5cd10e-3b64-400d-8f93-60a4e8de6328.svg)

What promise class does during inititalization - is creating an asyncronous task with serialized resolver instance.
Asyncronous task deserialises resolver and executes it. It may be time consuming operation, for example some calculation, query, or http request. So why won't let the rest of abap code work for something else?
So when your code decides that it's time to get data from promise and only then actually triggers for wait statement. Once an asynctronous task is done by triggering resolve/reject method in your resolver instance  - it will serialize again the response and send back to your main session. 

You may not see the desired effect for single operations - but for promise=>all call the effect can be huge!

