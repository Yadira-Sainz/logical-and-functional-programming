
import java.util.ArrayList;
import java.util.List;

/**
 * Clase que implementa el algoritmo de la Criba de Eratóstenes para encontrar
 * números primos hasta un límite dado.
 *
 * @author [Yadira Sainz]
 */
public class Criba {

    private int n;
    private List<Integer> primos;

    /**
     * Constructor de la clase Criba.
     *
     * @param n Límite superior para buscar números primos.
     */
    public Criba(int n) {
        this.n = n;
        this.primos = new ArrayList<>();
    }

    /**
     * Ejecuta el algoritmo de la Criba de Eratóstenes y almacena los números
     * primos encontrados.
     */
    public void ejecutarCriba() {
        int[] esPrimo = new int[n + 1];
        for (int i = 2; i <= n; i++) {
            esPrimo[i] = i;
        }
        for (int p = 2; p * p <= n; p++) {
            if (esPrimo[p] != 0) {
                for (int i = p * p; i <= n; i += p) {
                    esPrimo[i] = 0;
                }
            }
        }
        primos.clear();
        for (int i = 2; i <= n; i++) {
            if (esPrimo[i] != 0) {
                primos.add(i);
            }
        }
    }

    /**
     * Imprime la lista de números primos encontrados.
     */
    public void imprimirPrimos() {
        System.out.println("Números primos hasta " + n + ":");
        for (int primo : primos) {
            System.out.print(primo + " ");
        }
        System.out.println();
    }

    /**
     * Devuelve la lista de números primos encontrados.
     *
     * @return Lista de números primos.
     */
    public List<Integer> getPrimos() {
        return new ArrayList<>(primos);
    }
}
