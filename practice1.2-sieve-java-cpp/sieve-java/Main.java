import java.util.Scanner;

/**
 * Clase principal para ejecutar el programa de la Criba de Eratóstenes.
 * Permite al usuario ingresar un número y muestra los primos hasta ese número.
 * 
 * @author [Yadira Sainz]
 */
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingrese el valor de N: ");
        int n = scanner.nextInt();
        Criba criba = new Criba(n);
        criba.ejecutarCriba();
        criba.imprimirPrimos();
        scanner.close();
    }
}
