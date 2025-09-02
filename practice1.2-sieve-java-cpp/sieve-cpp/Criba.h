#ifndef CRIBA_H
#define CRIBA_H

#include <vector>

/**
 * @brief Clase que implementa el algoritmo de la Criba de Eratóstenes para encontrar números primos hasta un límite dado.
 *
 */
class Criba
{
private:
    int n;                   ///< Límite superior para buscar números primos.
    std::vector<int> primos; ///< Vector que almacena los números primos encontrados.

public:
    /**
     * @brief Constructor de la clase Criba.
     * @param n Límite superior para buscar números primos.
     */
    Criba(int n);

    /**
     * @brief Ejecuta el algoritmo de la Criba de Eratóstenes y almacena los números primos encontrados.
     */
    void ejecutarCriba();

    /**
     * @brief Imprime la lista de números primos encontrados.
     */
    void imprimirPrimos() const;

    /**
     * @brief Devuelve la lista de números primos encontrados.
     * @return Vector de números primos.
     */
    std::vector<int> getPrimos() const;
};

#endif // CRIBA_H
