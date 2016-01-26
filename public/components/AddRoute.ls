{create-class, create-factory, DOM:{div, button, input}}:React = require \react
{find-DOM-node} = require \react-dom
{dispatch, get-state, subscribe} = require \../store.ls

module.exports = create-class do

    display-name: \AddRoute

    # render :: a -> ReactElement
    render: ->
        div null, 

            # INPUT (A)
            input do 
                type: \number
                value: @state.a
                on-change: ({target:{value}}) ~> 
                    dispatch type: \A_CHANGED, a: value

            # INPUT (B)
            input do 
                type: \number
                value: @state.b
                on-change: ({target:{value}}) ~> 
                    dispatch type: \B_CHANGED, b: value

            # BUTTON (Add)
            button do
                on-click: ~> 
                    dispatch type: \REQUEST_START
                    fetch "/api/add?a=#{@state.a}&b=#{@state.b}"
                        .then (response) ~> 

                            # SUCCESS (200 - 299)
                            if response.ok
                                response.json! .then ({result}) ->
                                    dispatch type: \REQUEST_SUCCESS, result: result

                            # FAIL
                            else
                                dispatch type: \REQUEST_FAIL, error: response.status

                        .catch (error) ~> dispatch type: \REQUEST_FAIL, error: error
                \add

            # RESULT
            div do 
                style: 
                    color: switch 
                        | @state.error => \red
                        | @state.loading => \blue
                        | _ => \green
                
                switch
                    | @state.error => "Error: #{@state.error}" 
                    | @state.loading => \Loading
                    | _ => @state.result

    # get-initial-state :: () -> UIState
    get-initial-state: ->
        # a :: String
        # b :: String
        # loading :: Boolean
        # error :: String?
        # result :: Number
        {}

    # component-will-mount :: () -> Void
    component-will-mount: !->
        @unsubscribe = subscribe ~> @set-state get-state!.add-route
        @set-state get-state!.add-route

    # component-will-unmount :: () -> Void
    component-will-unmount: !-> @unsubscribe!