# add :: String -> String -> Store -> (Store -> ())
export add = (a, b, {dispatch}) !-->
    dispatch type: \ADD_REQUEST_START
    fetch "/api/add?a=#{a}&b=#{b}"
        .then (response) ~> 

            # SUCCESS (200 - 299)
            if response.ok
                response.json! .then ({result}) ->
                    dispatch type: \ADD_REQUEST_SUCCESS, result: result

            # FAIL
            else
                dispatch type: \ADD_REQUEST_FAIL, error: response.status

        .catch (error) ~> dispatch type: \ADD_REQUEST_FAIL, error: error