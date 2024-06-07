import Data.List(genericLength)
import Text.Show.Functions()

-- PARTE 1 --

data Simpson = Simpson {
    nombre :: String,
    dinero :: Float,
    felicidad :: Float
}

cambiarFelicidad :: Float -> Simpson -> Simpson
cambiarFelicidad nuevaFelicidad unPersonaje =
    unPersonaje{ felicidad = max 0 (felicidad unPersonaje + nuevaFelicidad)}

cambiarDinero :: Float -> Simpson -> Simpson
cambiarDinero nuevoMonto unPersonaje =
    unPersonaje{ dinero = dinero unPersonaje + nuevoMonto}

irALaEscuela :: Actividad
irALaEscuela unPersonaje
    | nombre unPersonaje == "Lisa" = cambiarFelicidad 20 unPersonaje
    | otherwise = cambiarFelicidad (-20) unPersonaje

comerNDonnas :: Float -> Actividad
comerNDonnas cantidad  = 
   cambiarDinero (10*cantidad) . cambiarFelicidad (10* cantidad) 

irATrabajar :: String -> Actividad
irATrabajar unLugar unPersonaje
    | unLugar == "Planta de Energía Nuclear" = cambiarDinero 14 unPersonaje
    | unLugar == "Escuela" = irALaEscuela unPersonaje

mirarTV :: Simpson -> Simpson
mirarTV = cambiarFelicidad 50

homero :: Simpson 
homero = Simpson "Homero" 200 90

homeroConDonas :: Simpson
homeroConDonas = comerNDonnas 12 homero

skinner :: Simpson
skinner = Simpson "Skinner" 90 30

skinnerTrabajando :: Simpson
skinnerTrabajando = irATrabajar "Escuela" skinner

lisa :: Simpson
lisa = Simpson "Lisa" 100 60

lisaConActividades :: Simpson
lisaConActividades = mirarTV . irALaEscuela $ lisa

srBurns :: Simpson
srBurns = Simpson "Sr Burns" 1000 20

-- PUNTO 2 --

type Logro = Simpson -> Bool

serMillonario :: Logro
serMillonario = (>= dinero srBurns). dinero 

alegrarse :: Float -> Logro
alegrarse felicidadDeseada = (felicidadDeseada >=) . felicidad

verAKrosti :: Logro
verAKrosti = (10<=) . dinero

comprarMansion :: Logro
comprarMansion unPersonaje = 
    serMillonario unPersonaje && ((70>=) . felicidad $ unPersonaje)

--- A)

type Actividad = Simpson -> Simpson

esActividadDecisiva :: Logro -> Actividad -> Simpson -> Bool
esActividadDecisiva unLogro unaAccion = unLogro . unaAccion

--- B) 

hacerActividadDecisiva :: Logro -> [Actividad] -> Simpson -> Simpson
hacerActividadDecisiva unLogro [] unPersonaje = unPersonaje
hacerActividadDecisiva unLogro (unaActividad:otrasActividades) unPersonaje
    | esActividadDecisiva unLogro unaActividad unPersonaje = unaActividad unPersonaje
    | otherwise = hacerActividadDecisiva unLogro otrasActividades unPersonaje

--- C) 

actividadesInfinitas :: [Actividad]
actividadesInfinitas = map comerNDonnas [1..]

actividadesInfinitas' :: [Actividad]
actividadesInfinitas'= repeat (irATrabajar "Escuela")