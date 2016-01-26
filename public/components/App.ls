require! \../../config.ls
{clone-element, create-class, create-factory, DOM:{button, div}}:React = require \react
{render} = require \react-dom
require! \react-router
Router = create-factory react-router.Router
Route = create-factory react-router.Route
IndexRoute = create-factory react-router.IndexRoute
Link = create-factory react-router.Link
{dispatch} = require \../store.ls

App = create-class do

    display-name: \App

    # render :: a -> ReactElement
    render: ->
        div null,

            # RESET
            button do
                on-click: ~> dispatch type: \RESET
                'Reset All'

            # MENU
            div do
                class-name: \menu
                Link to: \/count, \count
                Link to: \/add, \add

            # ROUTES
            div do 
                class-name: \route
                @props.children

            div {class-name: \building}, \Building... if @state.building

    # get-initial-state :: a -> UIState
    get-initial-state: -> building: false

    # component-did-mount :: a -> Void
    component-will-mount: !->
        if !!config?.gulp?.reload-port
            (require \socket.io-client) "http://localhost:#{config.gulp.reload-port}"
                ..on \build-start, ~> @set-state building: true
                ..on \build-complete, -> window.location.reload!

render do 
    Router do 
        history: react-router.browser-history
        Route do 
            name: \app
            path: \/
            component: App
            # IndexRoute component: (require \./...ls)
            Route name: \count, path: \/count component: (require \./CounterRoute.ls)
            Route name: \add, path: \/add component: (require \./AddRoute.ls)
    document.get-element-by-id \mount-node