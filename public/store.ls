{create-store, combine-reducers} = require \redux

# Reducer :: State -> Action -> State
# counter-route :: Reducer
counter-route = (state = {count: 0}, {type}) ->
    match type
        | \INCREMENT => {} <<< state <<< count: state.count + 1
        | \DECREMENT => {} <<< state <<< count: state.count - 1
        | \RESET => {count: 0}
        | _ => state

# add-route :: Reducer
add-route = (state = {a: \0, b: \0, result: 0, loading: false, error: null}, {type, a, b, result, error}?) ->
    match type
        | \A_CHANGED => {} <<< state <<< {a}
        | \B_CHANGED => {} <<< state <<< {b}

        | \ADD_REQUEST_START => 
            {} <<< state <<< 
                loading: true
                error: null

        | \ADD_REQUEST_SUCCESS => 
            {} <<< state <<< 
                loading: false
                error: null
                result: result

        | \ADD_REQUEST_FAIL => 
            {} <<< state <<< 
                loading: false
                error: error
                result: null

        | \RESET =>  a: \0, b: \0, result: 0, loading: false, error: null
        | _ => state

module.exports = create-store combine-reducers {add-route, counter-route}

'''
combine-reducers {add-route, counter-route}, returns the following reducer:
(state = {}, action) ->
    counter-route: counter-route state.counter-route, action
    add-route: add-route state.add-route, action

# gist of the inner implemention of create-store function
# create-store :: Reducer -> Store
create-store = (reducer) ->

    state = undefined
    listeners = []

    # get-state :: () -> State
    get-state: -> state

    # Action :: {type :: String, ...}
    # dispatch :: Action -> Void
    dispatch: (action) !->
        state := reducer state, action
        listeners |> each (listener) -> listener!

    # subscribe :: (() -> Void) -> (() -> Void)
    subscribe: (listener) ->
        listeners.push listener

        # subscribe returns a function to unsubscribe
        -> listeners |> reject (== listener)
'''