import Data.List()
import Text.Show()
import Data.Char(isUpper)

-- PUNTO 1 --
data Plomero = Plomero {
    nombre :: String,
    cajaHerramientas :: [Herramienta],
    historialReparaciones :: [Reparacion],
    dinero :: Float
}
data Herramienta = Herramienta {
    denominacion :: String,
    empuniadura :: Material,
    precio :: Float
} deriving (Show,Eq)

data Material = Hierro | Madera | Goma | Plastico deriving (Show,Eq)

mario :: Plomero
mario = Plomero "Mario" [llaveInglesa, martillo] [] 1200

llaveInglesa :: Herramienta
llaveInglesa = Herramienta "Llave Inglesa" Hierro 200 

martillo :: Herramienta
martillo = Herramienta "Martillo" Madera 20

wario :: Plomero
wario = Plomero "Wario" infinitasLlavesFrancesas [] 0.5

llaveFrancesa :: Herramienta
llaveFrancesa = Herramienta "Llave Francesa" Hierro 1

infinitasLlavesFrancesas :: [Herramienta]
infinitasLlavesFrancesas = map (Herramienta "Llave Francesa" Hierro ) [1..]

-- PUNTO 2 --

tieneHerramientaDe :: (Herramienta -> Bool) -> Plomero -> Bool
tieneHerramientaDe unMaterial  = any unMaterial . cajaHerramientas

esUnPlomeroMalvado :: Plomero -> Bool
esUnPlomeroMalvado  = (== "wa") . take 2 . nombre

puedeComprarHerramienta :: Herramienta -> Plomero -> Bool
puedeComprarHerramienta unaHerramienta unPlomero = 
    (<=) (precio unaHerramienta) (dinero unPlomero)

-- PUNTO 3 --

esUnaHerramientaBuena :: Herramienta -> Bool
esUnaHerramientaBuena unaHerramienta = 
    tieneMangoDe Madera martillo || tieneMangoDe Goma martillo 
esUnaHerramientaBuena unaHerramienta = 
    tieneMangoDe Hierro unaHerramienta && ( (>1000) . precio) unaHerramienta

tieneMangoDe :: Material -> Herramienta -> Bool
tieneMangoDe unMaterial = (== unMaterial) . empuniadura   

-- PUNTO 4 --

modificarUnPlomero :: (Plomero -> a) -> (a -> a) -> (a -> Plomero -> Plomero) -> Plomero -> Plomero
modificarUnPlomero unaCaracteristica unModificador aplicadorModificacion unPlomero = 
  aplicadorModificacion (unModificador . unaCaracteristica $ unPlomero) unPlomero

actualizarDinero :: Float -> Plomero -> Plomero
actualizarDinero nuevoDinero unPlomero = unPlomero { dinero = nuevoDinero }

pagarHerramienta :: Herramienta -> Plomero -> Plomero
pagarHerramienta unaHerramienta =
    modificarUnPlomero dinero (subtract . precio $ unaHerramienta) actualizarDinero

actualizarHerramientas :: [Herramienta] -> Plomero -> Plomero
actualizarHerramientas nuevasHerramientas unPlomero = unPlomero {cajaHerramientas = nuevasHerramientas}

agregarHerramienta :: Herramienta -> Plomero -> Plomero
agregarHerramienta unaHerramienta =
    modificarUnPlomero cajaHerramientas (unaHerramienta :) actualizarHerramientas

puedePagar :: Herramienta -> Plomero -> Bool
puedePagar unaHerramienta unPlomero = precio unaHerramienta <= dinero unPlomero

comprarHerramienta :: Plomero -> Herramienta -> Plomero
comprarHerramienta unPlomero unaHerramienta
    | puedePagar unaHerramienta unPlomero =  
        (agregarHerramienta unaHerramienta . pagarHerramienta unaHerramienta) unPlomero
    | otherwise = unPlomero

-- PUNTO 5 --

--- A)

data Reparacion = Reparacion {
    descripcion :: [Char],
    requerimiento :: Plomero -> Bool
} 

filtracionDeAgua :: Reparacion
filtracionDeAgua = Reparacion "" tieneLlaveInglesa

tieneHerramienta :: Herramienta -> Plomero -> Bool
tieneHerramienta unaHerramienta unPlomero = elem unaHerramienta (cajaHerramientas unPlomero)

tieneLlaveInglesa :: Plomero -> Bool
tieneLlaveInglesa = tieneHerramienta llaveInglesa

--- B)

esUnaReparacionUrgente :: Reparacion -> Bool
esUnaReparacionUrgente = isUpper . head . descripcion 

esReparacionDificil :: Reparacion -> Bool 
esReparacionDificil  unaReparacion =  
    ((> 100) . length . descripcion) unaReparacion && esUnaReparacionUrgente unaReparacion

--- C)

presupuestoDeUnaReparacion :: Reparacion -> Int
presupuestoDeUnaReparacion  = (*3) . length . descripcion

-- PUNTO 6 --

destornillador :: Herramienta
destornillador = Herramienta "Destornillador" Plastico 0

agregarReparacion :: Plomero -> Reparacion -> Plomero
agregarReparacion unPlomero unaReparacion =
    modificarUnPlomero historialReparaciones (unaReparacion :) actualizarReparaciones unPlomero

actualizarReparaciones :: [Reparacion] -> Plomero -> Plomero
actualizarReparaciones unasReparaciones unPlomero= unPlomero { historialReparaciones = unasReparaciones}

plomeroConPlata :: Plomero -> Reparacion -> Plomero
plomeroConPlata unPlomero unaReparacion =
    actualizarDinero (dinero unPlomero + fromIntegral (presupuestoDeUnaReparacion unaReparacion)) unPlomero

herramientaSegun :: Plomero -> Reparacion -> Plomero
herramientaSegun unPlomero unaReparacion 
    | esUnPlomeroMalvado unPlomero =
        agregarHerramienta destornillador unPlomero
    | esReparacionDificil unaReparacion =
        actualizarHerramientas (herramientasMalas . cajaHerramientas $ unPlomero) unPlomero
    | not . esReparacionDificil $ unaReparacion =
        actualizarHerramientas (olvidarPrimerHerramienta unPlomero) unPlomero
    | otherwise = unPlomero

herramientasMalas :: [Herramienta] -> [Herramienta]
herramientasMalas  = filter (not . esUnaHerramientaBuena )

olvidarPrimerHerramienta :: Plomero -> [Herramienta]
olvidarPrimerHerramienta unPlomero = drop 1 (cajaHerramientas unPlomero)

hacerReparacion :: Plomero -> Reparacion -> Plomero
hacerReparacion unPlomero unaReparacion
    | requerimiento unaReparacion unPlomero =
        herramientaSegun . plomeroConPlata . agregarReparacion unPlomero $ unaReparacion $ unaReparacion $ unaReparacion
    | otherwise =
        herramientaSegun . actualizarDinero . (+100) . dinero $ unPlomero $ unPlomero $ unaReparacion

-- PUNTO 7 --

jornadaDeTrabajo :: Plomero -> [Reparacion] -> Plomero
jornadaDeTrabajo = foldr (flip hacerReparacion )  

-- PUNTO 8 --

--obtenerPlomeroMaxSegun :: (Plomero -> b) -> [Plomero] -> Plomero
--obtenerPlomeroMaxSegun unCriterio unosPlomeros = 

--- A)