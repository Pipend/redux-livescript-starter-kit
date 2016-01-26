{create-class, create-factory, DOM:{div, button, input}}:React = require \react
{find-DOM-node} = require \react-dom
{dispatch, get-state, subscribe} = require \../store.ls

module.exports = create-class do

    display-name: \CounterRoute

    # render :: a -> ReactElement
    render: ->
        div null, 

            # +
            input do 
                type: \button
                value: \+
                on-click: ~> dispatch type: \INCREMENT

            # -
            input do 
                type: \button
                value: \-
                on-click: ~> dispatch type: \DECREMENT

            # RESULT
            div null, @state.count

    # get-initial-state :: () -> UIState
    get-initial-state: ->
        # count :: Number
        {}

    # component-will-mount :: () -> Void
    component-will-mount: !->
        @unsubscribe = subscribe ~> @set-state get-state!.counter-route
        @set-state get-state!.counter-route

    # component-will-unmount :: () -> Void
    component-will-unmount: !-> @unsubscribe!