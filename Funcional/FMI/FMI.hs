-- PUNTO 1 --

--- a)

data Pais = Pais{
    ingreso :: Float,
    sectorPublico :: Float,
    sectorPrivado :: Float,
    recursos :: [String],
    deuda :: Float
}

--- b)

namibia :: Pais
namibia = Pais 4140 400000 650000 ["Minería", "Ecoturismo"] 50

-- PUNTO 2 --

type Estrategia = Pais -> Pais

cambiarDeuda :: (Float -> Float) -> Estrategia
cambiarDeuda unaFuncion unPais = unPais{deuda = unaFuncion . deuda $ unPais}

reducirSectorPublico :: Float -> Estrategia
reducirSectorPublico unaPorcion unPais =
    unPais{sectorPublico = (subtract unaPorcion . sectorPublico) unPais}

disminuirIngreso :: Float -> Estrategia
disminuirIngreso unaCifra unPais = 
    unPais{ingreso = ingreso unPais - unaCifra}

cambiarRecursos :: ([String] -> [String]) -> Estrategia
cambiarRecursos unaFuncion unPais =
    unPais{recursos = unaFuncion . recursos $ unPais}

--- a)

prestar :: Float -> Estrategia
prestar unosMillones = cambiarDeuda (subtract (unosMillones * 1.5)) 

--- b) 

bajarSectorPublico :: Float -> Estrategia
bajarSectorPublico unaCantidad  = 
   bajarPbiSegun . reducirSectorPublico unaCantidad

bajarPbiSegun :: Pais -> Pais
bajarPbiSegun unPais 
    | sectorPublico unPais >= 100 = disminuirIngreso (ingreso unPais * 0.2) unPais
    | otherwise = disminuirIngreso (ingreso unPais * 0.15) unPais

--- c)

type Recurso = String

efectoSacar :: Recurso -> Estrategia
efectoSacar unRecurso  = 
    cambiarDeuda (subtract 2) . cambiarRecursos (filter (unRecurso /=)) 

--- d) 

establecerBlindaje :: Estrategia
establecerBlindaje  unPais =
    reducirSectorPublico 500 . prestar (pbiSegun unPais / 2) $ unPais

pbiSegun :: Pais -> Float
pbiSegun unPais =  ingreso unPais * poblacionTotal unPais

poblacionTotal :: Pais -> Float
poblacionTotal unPais = sectorPrivado unPais + sectorPublico unPais

-- PUNTO 3 --

--- a)

type Receta = [Estrategia]

receta1 :: Receta
receta1 = [prestar 200 , efectoSacar "Minería"]

--- b) 

aplicarRecetaA :: Pais-> Receta ->  Pais
aplicarRecetaA unPais = foldr ($) unPais 

nambiaConReceta :: Pais
nambiaConReceta = aplicarRecetaA namibia receta1 

-- PUNTO 4 --

--- a)

puedenZafar :: [Pais] -> [Pais]
puedenZafar = filter (tiene "Petroleo") 

tiene :: Recurso -> Pais -> Bool
tiene unRecurso = elem unRecurso . recursos 

--- b)

deudaTotal :: [Pais] -> Float
deudaTotal = sum . map deuda

-- PUNTO 5 --

estaOrdenada :: [Receta] -> Pais -> Bool
estaOrdenada [unaReceta] _ = True
estaOrdenada (receta1 : receta2 : otrasRecetas) unPais =
     (( pbiSegun . flip aplicarRecetaA receta1 $ unPais) < ( pbiSegun .flip aplicarRecetaA receta2 $ unPais)) 
     && estaOrdenada (receta2 : otrasRecetas) unPais 
