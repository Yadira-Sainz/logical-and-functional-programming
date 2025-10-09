-- 1. Declaración de Valores
-- Declara tres valores a, b y c y calcula su suma total.
a = 10
b = 20
c = 30
sumaTotal = a + b + c

-- Define una constante piAprox y calcula el área de un círculo con radio 5.
piAprox = 3.14
radio = 5
areaCirculo = piAprox * radio^2

-- Crea un valor 'nombre' y otro 'mensaje' que concatene "Hola " con 'nombre'.
nombre = "Yadira"
mensaje = "Hola " ++ nombre

-- 2. Funciones
-- Define una función 'triple' que multiplique un número por 3.
triple x = x * 3

-- Crea una función 'hipotenusa' para calcular la raíz cuadrada de a^2 + b^2.
hipotenusa a b = sqrt (a^2 + b^2)

-- Escribe una función 'mayorDeDos' que reciba dos números y devuelva el mayor.
mayorDeDos x y = if x > y then x else y

-- 3. Tipos de datos
-- Declara un valor de tipo Bool.
estoyInscrito = True

-- Escribe un valor de tipo Char que contenga tu inicial.
miInicial = 'Y'

-- Crea una función 'esVocal' que determine si un Char es una vocal.
esVocal c = c `elem` "aeiouAEIOU"

-- 4. Listas
-- Crea una lista con los números del 1 al 20.
numerosDel1Al20 = [1..20]

-- Genera una lista con los cuadrados de los primeros 10 números.
cuadradosDiez = [x^2 | x <- [1..10]]

-- Escribe una función 'longitud' que calcule cuántos elementos tiene una lista.
longitud [] = 0
longitud (_:xs) = 1 + longitud xs

-- 5. Recursividad
-- Define una función recursiva 'sumaLista' que sume los elementos de una lista.
sumaLista [] = 0
sumaLista (x:xs) = x + sumaLista xs

-- Crea una función recursiva 'potencia' que calcule a^b.
potencia a 0 = 1
potencia a b = a * potencia a (b-1)

-- Escribe una función 'fibonacci' recursiva que devuelva el enésimo número.
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)

-- 6. Funciones de orden superior
-- Usa 'map' para duplicar todos los elementos de una lista.
duplicarElementos xs = map (*2) xs

-- Usa 'filter' para obtener solo los números mayores a 10.
mayoresDeDiez xs = filter (>10) xs

-- Combina 'map' y 'filter' para calcular el cuadrado de los números pares.
cuadradoDePares xs = map (^2) (filter even xs)

-- 7. Ejercicio Reto (integrador)
-- Genera una lista del 1 al 100.
listaDel1Al100 = [1..100]

-- Filtra los múltiplos de 3 y 5.
multiplosDe3y5 xs = filter (\x -> x `mod` 3 == 0 || x `mod` 5 == 0) xs

-- Calcula la suma de esos múltiplos.
sumaMultiplos xs = sum xs

main = do
    putStrLn "\n-- Declaración de valores --"
    putStrLn $ "sumaTotal: " ++ show sumaTotal
    putStrLn $ "areaCirculo: " ++ show areaCirculo
    putStrLn mensaje

    putStrLn "\n-- Funciones --"
    putStrLn $ "triple 4: " ++ show (triple 4)
    putStrLn $ "hipotenusa 3 4: " ++ show (hipotenusa 3 4)
    putStrLn $ "mayorDeDos 7 9: " ++ show (mayorDeDos 7 9)

    putStrLn "\n-- Tipos de datos --"
    putStrLn $ "estoyInscrito: " ++ show estoyInscrito
    putStrLn $ "miInicial: " ++ show miInicial
    putStrLn $ "esVocal 'a': " ++ show (esVocal 'a')

    putStrLn "\n-- Listas --"
    putStrLn $ "numerosDel1Al20: " ++ show numerosDel1Al20
    putStrLn $ "cuadradosDiez: " ++ show cuadradosDiez
    putStrLn $ "longitud [1,2,3,4]: " ++ show (longitud [1,2,3,4])

    putStrLn "\n-- Recursividad --"
    putStrLn $ "sumaLista [1,2,3,4]: " ++ show (sumaLista [1,2,3,4])
    putStrLn $ "potencia 2 5: " ++ show (potencia 2 5)
    putStrLn $ "fibonacci 10: " ++ show (fibonacci 10)

    putStrLn "\n-- Funciones de orden superior --"
    putStrLn $ "duplicarElementos [1,2,3]: " ++ show (duplicarElementos [1,2,3])
    putStrLn $ "mayoresDeDiez [5,15,20]: " ++ show (mayoresDeDiez [5,15,20])
    putStrLn $ "cuadradoDePares [1..10]: " ++ show (cuadradoDePares [1..10])

    putStrLn "\n-- Ejercicio Reto (integrador) --"
    let lista = listaDel1Al100
    let multiplos = multiplosDe3y5 lista
    putStrLn $ "Múltiplos de 3 y 5 del 1 al 100: " ++ show multiplos
    let suma = sumaMultiplos multiplos
    putStrLn $ "Suma de múltiplos de 3 y 5 del 1 al 100: " ++ show suma