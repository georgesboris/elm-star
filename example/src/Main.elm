module Main exposing (main)

import Browser
import Html as H
import Http
import Json.Decode as D
import Store



-- Post Store


type alias Post =
    { id : String, title : String }


postDecoder : D.Decoder Post
postDecoder =
    D.map2 Post
        (D.field "id" D.string)
        (D.field "title" D.string)


postStore : Store.Store Post String Effect
postStore =
    Store.new .id GetPost



-- Application


type alias Flags =
    ()


type alias Model =
    { posts : Store.StoreModel Post }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { posts = Store.init postStore }
    , Cmd.none
    )


type Msg
    = Noop
    | GetPostResponse (Result Http.Error Post)


type Effect
    = None
    | GetPost String
    | GetPostList (List String)


update : Msg -> Model -> ( Model, Effect )
update _ model =
    ( model
    , None
    )


handleEffects : ( model, Effect ) -> ( model, Cmd Msg )
handleEffects ( model, effect ) =
    case effect of
        None ->
            ( model, Cmd.none )

        GetPost id ->
            ( model
            , Http.get
                { url = "https://my-json-server.typicode.com/typicode/demo/posts"
                , expect = Http.expectJson GetPostResponse postDecoder
                }
            )

        GetPostList id ->
            ( model
            , Cmd.none
            )


view : Model -> H.Html msg
view model =
    H.text "Hello"



-- Main


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update =
            \msg model ->
                update msg model
                    |> handleEffects
        , subscriptions = \_ -> Sub.none
        , view = view
        }
