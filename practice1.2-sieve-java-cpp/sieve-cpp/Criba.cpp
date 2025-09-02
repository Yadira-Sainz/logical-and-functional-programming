#include "Criba.h"
#include <iostream>

/**
 * Constructor de la clase Criba.
 * @param n El límite superior hasta donde se buscarán números primos.
 */
Criba::Criba(int n) : n(n)
{
    // Constructor vacío
}

/**
 * Método que ejecuta el algoritmo de la criba para encontrar números primos.
 */
void Criba::ejecutarCriba()
{
    std::vector<bool> esPrimo(n + 1, true);
    for (int i = 2; i <= n; ++i)
    {
        esPrimo[i] = true;
    }
    for (int p = 2; p * p <= n; ++p)
    {
        if (esPrimo[p])
        {
            for (int i = p * p; i <= n; i += p)
            {
                esPrimo[i] = false;
            }
        }
    }
    primos.clear();
    for (int i = 2; i <= n; ++i)
    {
        if (esPrimo[i])
        {
            primos.push_back(i);
        }
    }
}

/**
 * Método que imprime los números primos encontrados hasta el límite superior n.
 */
void Criba::imprimirPrimos() const
{
    std::cout << "Números primos hasta " << n << ":" << std::endl;
    for (int primo : primos)
    {
        std::cout << primo << " ";
    }
    std::cout << std::endl;
}

/**
 * Método que devuelve el vector de números primos encontrados.
 * @return Un vector que contiene los números primos encontrados.
 */
std::vector<int> Criba::getPrimos() const
{
    return primos;
}