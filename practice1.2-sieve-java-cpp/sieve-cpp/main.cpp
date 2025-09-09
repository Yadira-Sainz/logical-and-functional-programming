#include <iostream>
#include "Criba.h"

/**
 * @brief Función principal. Permite al usuario ingresar un número y muestra los primos hasta ese número.
 * Correr el programa
 * g++ main.cpp Criba.cpp -o main
 * ./main 
 */
int main()
{
    int n;
    std::cout << "Ingrese el valor de N: ";
    std::cin >> n;
    Criba criba(n);
    criba.ejecutarCriba();
    criba.imprimirPrimos();
    return 0;
}
