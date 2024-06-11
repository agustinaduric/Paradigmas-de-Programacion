import Data.List()
import Text.Show.Functions()

-- PUNTO 1 --

data Nave = Nave {
    nombre :: String,
    durabilidad :: Float,
    escudo :: Float,
    ataque :: Float,
    poderEspecial :: Poder
}

modificarAtaque :: (Float -> Float) -> Nave -> Nave
modificarAtaque unModificador unaNave =
    unaNave{ataque = max 0 . unModificador . ataque $ unaNave}

cambiarDurabilidad :: (Float -> Float) -> Nave -> Nave
cambiarDurabilidad unModificador unaNave =
    unaNave{durabilidad = (max 0 . unModificador . durabilidad) unaNave }


modificarEscudos :: (Float -> Float) -> Nave -> Nave
modificarEscudos unModificador unaNave =
    unaNave{escudo = (max 0 . unModificador . escudo) unaNave }

type Poder = Nave -> Nave

efectoTurbo :: Poder
efectoTurbo = modificarAtaque (+25)

efectoReparacion :: Poder
efectoReparacion = modificarAtaque (subtract 30) . cambiarDurabilidad (+50)

efectoSuperTurbo :: Poder
efectoSuperTurbo = 
    cambiarDurabilidad (subtract 50) . efectoTurbo . efectoTurbo . efectoTurbo

efectoMillennium :: Poder
efectoMillennium = modificarEscudos (+100) . efectoReparacion

tieFighter :: Nave
tieFighter =
    Nave "TIE Fighter" 200 100 50 efectoTurbo

xWing :: Nave
xWing =
    Nave "X Wing" 300 150 100 efectoReparacion

naveDarthVader :: Nave
naveDarthVader =
    Nave "Nave de Darth Vader" 500 300 200 efectoSuperTurbo

millenniumFalcon :: Nave
millenniumFalcon =
    Nave "Millennium Falcon" 1000 50 50 efectoMillennium

naveInventada :: Nave
naveInventada =
    Nave "Nave inventada" 500 100 200 (efectoMillennium . efectoSuperTurbo)

-- PUNTO 2 --

type Flota = [Nave]

type DurabilidadTotal = Float

durabilidadTotal :: [Nave] -> DurabilidadTotal
durabilidadTotal = sum . map durabilidad 

-- PUNTO 3 --

type AtaqueRecibido = Float

puedeDefenderse :: AtaqueRecibido -> Defensor -> Bool
puedeDefenderse unAtaque = 
   ( > unAtaque) . escudo 

ataqueDe :: Atacante -> Defensor -> Defensor
ataqueDe naveAtacante naveAtacada 
    | puedeDefenderse (ataque naveAtacante) naveAtacada = 
        cambiarDurabilidad (subtract . danioRecibido naveAtacante $ naveAtacada) naveAtacada
    | otherwise = naveAtacada

danioRecibido :: Atacante -> Defensor -> AtaqueRecibido
danioRecibido naveAtacante =
    subtract (ataque naveAtacante) . escudo

-- PUNTO 4 --

estaFuera :: Nave -> Bool
estaFuera  = (==0) . durabilidad

-- PUNTO 5 --

type Estrategia = Nave -> Bool

type Mision = [Estrategia]

navesDebiles :: Estrategia
navesDebiles = (<200) . escudo

type Peligrosidad = Float

navesConPeligrosidad :: Peligrosidad -> Estrategia
navesConPeligrosidad unaPeligrosidad = 
    (> unaPeligrosidad) . ataque

type Atacante = Nave

type Defensor = Nave

navesFuera :: Atacante -> Estrategia
navesFuera naveAtacante = estaFuera . ataqueDe naveAtacante 

-- PUNTO 6 --

hacerMision :: Nave -> Estrategia -> Flota -> Flota
hacerMision naveConMision unaEstrategia = map (aplicarEstrategia unaEstrategia naveConMision)

aplicarEstrategia :: Estrategia -> Nave -> Nave -> Nave
aplicarEstrategia estrategia naveConMision otraNave
                | estrategia otraNave = ataqueDe naveConMision otraNave
                | otherwise = otraNave

estrategiaMasPotente :: Nave -> Flota -> Estrategia -> Estrategia -> Flota
estrategiaMasPotente unaNave unaFlota unaEstrategia otraEstrategia
    | durabilidadTotal (navesAtacadasSegun unaEstrategia unaFlota) < durabilidadTotal (navesAtacadasSegun otraEstrategia unaFlota) = hacerMision unaNave unaEstrategia unaFlota
    | otherwise = hacerMision unaNave otraEstrategia unaFlota

navesAtacadasSegun :: Estrategia -> Flota -> Flota
navesAtacadasSegun unaEstrategia = filter unaEstrategia

-- PUNTO 7 --

flotaInfinita :: Flota
flotaInfinita = cycle [tieFighter, xWing, naveDarthVader]