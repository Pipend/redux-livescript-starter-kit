require! \assert
{find} = require \prelude-ls
{is-equal-to-object} = require \prelude-extension
routes = (require '../routes.ls')!
{dispatch, get-state} = require \../public/store.ls

describe 'express routes', ->
    specify '/api/add must return the sum of 2 numbers', (done) ->
        [..., handler] = routes |> find (.0 == \addition)
        handler do 
            {
                query: 
                    a: \2
                    b: \3
            }
            {
                send: ({result}) ->
                    assert result == 5
                    done!
            }


describe 'redux store', ->

    initial-state = get-state!

    specify 'INCREMENT action must increment the count by 1', ->
        before = get-state!.counter-route.count
        dispatch type: \INCREMENT
        assert 1 == get-state!.counter-route.count - before 

    specify 'DECREMENT action must descrement the count by 1', ->
        before = get-state!.counter-route.count
        dispatch type: \DECREMENT
        assert 1 == before - get-state!.counter-route.count

    specify 'A_CHANGED action must update a', ->
        dispatch type: \A_CHANGED, a: \5
        assert \5 == get-state!.add-route.a

    specify 'B_CHANGED action must update b', ->
        dispatch type: \B_CHANGED, b: \5
        assert \5 == get-state!.add-route.b

    specify 'REQUEST_START must set loading to true', ->
        dispatch type: \ADD_REQUEST_START
        assert true == get-state!.add-route.loading

    specify 'ADD_REQUEST_SUCCESS must update state with the result & clear loading flag', ->
        dispatch type: \ADD_REQUEST_SUCCESS, result: 10
        {error, loading, result} = get-state!.add-route
        assert null == error
        assert false == loading
        assert 10 == result

    specify 'ADD_REQUEST_FAIL must clear the loading flag and update the state with the error', ->
        dispatch type: \ADD_REQUEST_FAIL, error: \Error
        {error, loading} = get-state!.add-route
        assert \Error == error
        assert false == loading

    specify 'RESET must rollback to initial-state', ->
        dispatch type: \RESET
        assert initial-state `is-equal-to-object` get-state!