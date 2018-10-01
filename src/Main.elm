module Main exposing (..)

import Browser
import Random
import Color
import Arc2d exposing (Arc2d)
import Point2d exposing (Point2d)
import Geometry.Svg as Svg
import TypedSvg.Attributes exposing (..)
import TypedSvg.Types exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (src)
import TypedSvg exposing (svg, g)
import TypedSvg.Core exposing (Svg, Attribute)


--- MODEL ----


type alias Model =
    List Arc2d


init : ( Model, Cmd Msg )
init =
    ( [], newArcs )



---- UPDATE ----


type Msg
    = NewArcs (List Arc2d)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewArcs list ->
            ( list, Cmd.none )



---- RANDOM ----


pair : Random.Generator ( Float, Float )
pair =
    Random.pair (Random.float 0 500) (Random.float 0 500)


point : Random.Generator Point2d
point =
    Random.map Point2d.fromCoordinates pair


angle : Random.Generator Float
angle =
    Random.float 30 120


arc : Random.Generator Arc2d
arc =
    Random.map3
        (\point1 point2 angle1 ->
            Arc2d.from point1 point2 (degrees angle1)
        )
        point
        point
        angle


arcs : Random.Generator (List Arc2d)
arcs =
    Random.list 100 arc


newArcs : Cmd Msg
newArcs =
    Random.generate NewArcs arcs



---- VIEW ----


rootAttributes : List (Attribute msg)
rootAttributes =
    [ height <| px 500
    , width <| percent 100
    ]


arcAttributes : List (Attribute msg)
arcAttributes =
    [ fill FillNone
    , stroke Color.darkRed
    ]


view : Model -> Html Msg
view model =
    svg rootAttributes <|
        List.singleton <|
            g arcAttributes <|
                List.map
                    (Svg.arc2d [])
                    model



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
