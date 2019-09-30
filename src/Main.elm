module Main exposing (main)

import Angle exposing (Angle)
import Arc2d exposing (Arc2d)
import Browser
import Color
import Geometry.Svg as Svg
import Html exposing (Html)
import Pixels exposing (Pixels)
import Point2d exposing (Point2d)
import Random
import Time
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes exposing (..)
import TypedSvg.Core exposing (Attribute)
import TypedSvg.Types exposing (..)



--- MODEL ----


type TopLeftCoordinates
    = TopLeftCoordinates


type alias Model =
    List (Arc2d Pixels TopLeftCoordinates)


init : ( Model, Cmd Msg )
init =
    ( [], newArcs )



---- UPDATE ----


type Msg
    = NewArcs Model
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewArcs list ->
            ( list, Cmd.none )

        Tick _ ->
            ( model, newArcs )



---- RANDOM ----


pair : Random.Generator ( Float, Float )
pair =
    Random.pair (Random.float 200 800) (Random.float 100 700)


point : Random.Generator (Point2d Pixels TopLeftCoordinates)
point =
    Random.map (Point2d.fromTuple Pixels.pixels) pair


angle : Random.Generator Angle
angle =
    Random.map
        Angle.degrees
        (Random.float 30 90)


arc : Random.Generator (Arc2d Pixels TopLeftCoordinates)
arc =
    Random.map3
        Arc2d.from
        point
        point
        angle


arcs : Random.Generator Model
arcs =
    Random.list 50 arc


newArcs : Cmd Msg
newArcs =
    Random.generate NewArcs arcs



---- VIEW ----


rootAttributes : List (Attribute msg)
rootAttributes =
    [ height <| px 1000
    , width <| px 1000
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



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 100 Tick



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
