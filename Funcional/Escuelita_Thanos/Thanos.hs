import Data.List()
import Text.Show.Functions()

-- PUNTO 1 --

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    planeta :: String, 
    habilidades :: [String]
}

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
}

iroMan :: Personaje
iroMan = Personaje "Iron Man" 35 95 "s" ["s"]

drStrange :: Personaje
drStrange = Personaje "drStrange" 45 100 "" []

groot :: Personaje
groot = Personaje "Groot" 22 61 "" []

wolverine :: Personaje 
wolverine = Personaje "wolverine" 29 55 "" []

viudaNegra :: Personaje
viudaNegra = Personaje "Viuda Negra" 40 68 "" []

type Universo = [Personaje]
universo :: Universo
universo = [iroMan, drStrange,groot, wolverine,viudaNegra]

esPosibleChasquear :: Guantelete -> Bool
esPosibleChasquear unGuantelete = 
    esGuanteCompleto unGuantelete && esDeMaterial "uru" unGuantelete

esGuanteCompleto :: Guantelete -> Bool
esGuanteCompleto  = (6==) . length . gemas 

type Material = String

esDeMaterial :: Material -> Guantelete -> Bool
esDeMaterial unMaterial  = (== unMaterial) . material

chasquearUniverso :: Guantelete -> Universo 
chasquearUniverso unGuantelete 
    | esPosibleChasquear unGuantelete = efectoChasquido universo
    | otherwise = universo

efectoChasquido :: Universo -> Universo
efectoChasquido unUniverso = 
     drop (flip div 2 $ length unUniverso) unUniverso

-- PUNTO 2 --

-- A) 
esUniversoAptoPendex :: Universo -> Bool
esUniversoAptoPendex = esUniversoApto 45 

esUniversoApto :: Int -> Universo -> Bool
esUniversoApto unaEdad = any ((<45).edad) 

-- B) 

energiaTotalDelUniverso :: Universo -> Int
energiaTotalDelUniverso  = sum . map energia 

-- PUNTO 3 --

type Gema = Personaje -> Personaje

modificarCaracteristicaPersonaje :: Personaje-> (b -> b) -> (Personaje -> b) -> b
modificarCaracteristicaPersonaje unPersonaje unModificador unAaspecto =
    unModificador . unAaspecto $ unPersonaje

modificarunPersonaje :: (Personaje -> a) -> (a -> a) -> (a -> Personaje -> Personaje) -> Personaje -> Personaje
modificarunPersonaje unaCaracteristica unModificador aplicadorModificacion unPersonaje = 
  aplicadorModificacion (unModificador . unaCaracteristica $ unPersonaje) unPersonaje

mente :: Int -> Gema 
mente valor  = modificarunPersonaje energia (subtract valor) modificadorEnergia 

modificadorEnergia :: Int -> Personaje -> Personaje
modificadorEnergia nuevaEnergia unPersonaje = unPersonaje {energia = nuevaEnergia}

alma :: String -> Gema
alma unaHabilidad unPersonaje = 
    (mente 10 unPersonaje){habilidades = eliminarHabilidad unaHabilidad unPersonaje}

eliminarHabilidad :: String -> Personaje -> [String]
eliminarHabilidad unaHabilidad  unPersonaje= 
    filter (/=unaHabilidad ) ( habilidades unPersonaje)

espacio :: String -> Gema
espacio unPlaneta unPersonaje =  nuevoPlaneta (mente 20 unPersonaje) unPlaneta

nuevoPlaneta :: Personaje -> String -> Personaje
nuevoPlaneta unPersonaje unPlaneta = unPersonaje {planeta = unPlaneta}

poder :: Gema
poder unPersonaje = eliminarNhabilidades 2 (modificadorEnergia 0 unPersonaje )

eliminarNhabilidades :: Int -> Personaje -> Personaje
eliminarNhabilidades unNumero unPersonaje 
    | unNumero <= (length . habilidades $ unPersonaje ) = unPersonaje{habilidades = []}
    | otherwise = unPersonaje

tiempo :: Gema 
tiempo unPersonaje = (mente 50 unPersonaje){edad = reductorEdad . edad $ unPersonaje}

reductorEdad :: (Integral a, Ord a ) => a -> a
reductorEdad unaEdad
    | ((>= 18) . div unaEdad ) 2 = div unaEdad 2
    | otherwise = 18

loca :: Gema -> Gema
loca unaGema = unaGema . unaGema 

-- PUNTO 4 --

guanteleteEjemplo :: String -> Guantelete
guanteleteEjemplo "usar Mjolnir" = 
    Guantelete  "" [tiempo, alma "usar Mjolnir" , loca . alma $ "Programacion en Haskell"] 

-- PUNTO 5 --

ejecutarPoder ::  [Gema] -> Personaje -> Personaje
ejecutarPoder unasGemas unPersonaje = foldl (flip ($)) unPersonaje unasGemas

-- PUNTO 6 --

{-
Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete
 y una persona obtiene la gema del infinito que produce la pérdida más grande de energía 
 sobre la víctima. 
-}
-- gemaMasPoderosa :: Guantelete -> Personaje -> Gema