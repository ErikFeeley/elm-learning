module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl str =
    "https://world-cup-json.herokuapp.com" ++ str
