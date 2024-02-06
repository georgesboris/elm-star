module Store exposing
    ( Store
    , StoreModel
    , init
    , new
    , newCustom
    , withDelete
    , withDeleteList
    , withGet
    , withGetList
    )

import Dict exposing (Dict)
import Html as H



-- Status


type Status resource
    = NotAsked
    | Loading
    | Success resource



-- Builders


type StoreModel resource
    = StoreModel (Dict String (Status resource))


type Store resource id effect
    = Store
        { id : resource -> id
        , fromString : String -> id
        , toString : id -> String
        , init : StoreModel resource
        , get : Maybe (id -> effect)
        , getList : Maybe (List id -> effect)
        , delete : Maybe (id -> effect)
        , deleteList : Maybe (List id -> effect)
        , onInsert : Maybe (id -> effect)
        , onDelete : Maybe (id -> effect)

        -- , viewNotAsked : H.Html msg
        -- , viewLoading : H.Html msg
        -- , view : resource -> H.Html msg
        }


new : (resource -> String) -> (String -> effect) -> Store resource String effect
new id get =
    Store
        { id = id
        , toString = identity
        , fromString = identity
        , init = StoreModel Dict.empty
        , get = Just get
        , getList = Nothing
        , delete = Nothing
        , deleteList = Nothing
        , onInsert = Nothing
        , onDelete = Nothing

        -- , viewNotAsked = H.text ""
        -- , viewLoading = H.text "…"
        -- , view = \resource -> H.text (id resource)
        }


newCustom :
    { id : resource -> id
    , toString : id -> String
    , fromString : String -> id
    , get : id -> effect
    }
    -> Store resource id effect
newCustom props =
    Store
        { id = props.id
        , toString = props.toString
        , fromString = props.fromString
        , init = StoreModel Dict.empty
        , get = Nothing
        , getList = Nothing
        , delete = Nothing
        , deleteList = Nothing
        , onInsert = Nothing
        , onDelete = Nothing

        -- , viewNotAsked = H.text ""
        -- , viewLoading = H.text "…"
        -- , view = \resource -> H.text (props.toString (props.id resource))
        }



-- Customizing


withGet :
    (id -> effect)
    -> Store resource id effect
    -> Store resource id effect
withGet fn (Store store) =
    Store { store | get = Just fn }


withGetList :
    (List id -> effect)
    -> Store resource id effect
    -> Store resource id effect
withGetList fn (Store store) =
    Store { store | getList = Just fn }


withDelete :
    (id -> effect)
    -> Store resource id effect
    -> Store resource id effect
withDelete fn (Store store) =
    Store { store | delete = Just fn }


withDeleteList :
    (List id -> effect)
    -> Store resource id effect
    -> Store resource id effect
withDeleteList fn (Store store) =
    Store { store | deleteList = Just fn }



-- Access


init : Store resource id effect -> StoreModel resource
init (Store store) =
    store.init
