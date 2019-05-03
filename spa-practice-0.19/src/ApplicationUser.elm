module ApplicationUser exposing (ApplicationUser, anon, authenticated, isAuthenticated)


type ApplicationUser
    = Authenticated String
    | Anonymous


authenticated : String -> ApplicationUser
authenticated fakeToken =
    Authenticated fakeToken


anon : ApplicationUser
anon =
    Anonymous


isAuthenticated : ApplicationUser -> Bool
isAuthenticated applicationUser =
    case applicationUser of
        Authenticated _ ->
            True

        Anonymous ->
            False
