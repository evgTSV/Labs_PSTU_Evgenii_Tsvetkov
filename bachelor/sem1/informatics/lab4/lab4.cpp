#include <iostream>
#include <cstdlib>
#include <ctime>

void printRing(const int a[], int n, int k) {
    int i = k - 1;
    for (int c = 0; c < n; c++) {
        std::cout << a[i] << " ";
        if (i == 0)
            i = n - 1;
        else
            i--;
    }
    std::cout << std::endl;
}

void sortDesc(int a[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (a[j] < a[j + 1]) {
                int t = a[j];
                a[j] = a[j + 1];
                a[j + 1] = t;
            }
        }
    }
}

int removeOdd(int a[], int n) {
    int m = 0;
    for (int i = 0; i < n; i++) {
        if (a[i] % 2 == 0) {
            a[m] = a[i];
            m++;
        }
    }
    return m;
}

int main() {
    const int N = 100;
    int a[N];
    int n, k;
    std::srand(std::time(nullptr));

    std::cout << "Enter ring length (1.." << N << "): ";
    std::cin >> n;
    while (n < 1 || n > N) {
        std::cout << "Wrong length, enter again: ";
        std::cin >> n;
    }
    for (int i = 0; i < n; i++)
        a[i] = std::rand() % 100;

    std::cout << "Enter K (1.." << n << "): ";
    std::cin >> k;
    while (k < 1 || k > n) {
        std::cout << "Wrong K, enter again: ";
        std::cin >> k;
    }

    std::cout << "Ring from K-th to (K+1)-th, right to left:" << std::endl;
    printRing(a, n, k);

    sortDesc(a, n);
    std::cout << "Sorted in descending order (a[1]..a[n]):" << std::endl;
    for (int i = 0; i < n; i++)
        std::cout << a[i] << " ";
    std::cout << std::endl;

    n = removeOdd(a, n);
    if (n == 0) {
        std::cout << "All elements were odd, the ring is empty"
                  << std::endl;
    } else {
        k = (k - 1) % n + 1;
        std::cout << "Odd elements removed, K = " << k
                  << ", ring from K-th to (K+1)-th:" << std::endl;
        printRing(a, n, k);
    }

    return 0;
}
