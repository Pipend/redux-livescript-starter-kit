{map, sum} = require \prelude-ls

# inject mockable dependencies here:
# ExpressRoute :: [Name :: String, Method :: String, Path :: String, Handler :: (Req -> Res -> Void)]
# () -> [ExpressRoute]
module.exports = ->
    static-routes = <[/ /add /count]> |> map (path) -> 
        [path, \get, path, (req, res) -> res.render 'public/index.html']

    static-routes ++ [
        * \addition, \get, \/api/add, (req, res) -> 
            {a, b} = req.query
            <- set-timeout _, 300
            res.send do 
                result: [a, b] 
                    |> map parse-int
                    |> sum
    ]