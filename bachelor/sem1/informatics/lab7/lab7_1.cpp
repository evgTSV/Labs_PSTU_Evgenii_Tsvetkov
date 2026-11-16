#include <iostream>
#include <iomanip>

const int MAX = 10;

int del(int a[][MAX], int n, int m) {
    int k = 0;
    for (int i = 0; i < n; i += 2) {
        for (int j = 0; j < m; j++)
            a[k][j] = a[i][j];
        k++;
    }
    return k;
}

int del(int a[], int n) {
    int f = -1, l = -1;
    for (int i = 0; i < n; i++)
        if (a[i] == 0) {
            if (f == -1)
                f = i;
            l = i;
        }
    int k = 0;
    for (int i = 0; i < n; i++)
        if (i <= f || i >= l || a[i] == 0) {
            a[k] = a[i];
            k++;
        }
    return k;
}

int main() {
    int a[MAX][MAX];
    int v[MAX * MAX];
    int n, m, len;

    std::cout << "Enter rows and columns (1.." << MAX << "): ";
    std::cin >> n >> m;
    while (n < 1 || n > MAX || m < 1 || m > MAX) {
        std::cout << "Wrong size, enter again: ";
        std::cin >> n >> m;
    }
    std::cout << "Enter the matrix:" << std::endl;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            std::cin >> a[i][j];

    n = del(a, n, m);
    std::cout << "Even rows removed:" << std::endl;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++)
            std::cout << std::setw(4) << a[i][j];
        std::cout << std::endl;
    }

    std::cout << "Enter array length (1.." << MAX * MAX << "): ";
    std::cin >> len;
    while (len < 1 || len > MAX * MAX) {
        std::cout << "Wrong length, enter again: ";
        std::cin >> len;
    }
    std::cout << "Enter the array:" << std::endl;
    for (int i = 0; i < len; i++)
        std::cin >> v[i];

    len = del(v, len);
    std::cout << "Elements between zeros removed:" << std::endl;
    for (int i = 0; i < len; i++)
        std::cout << v[i] << " ";
    std::cout << std::endl;
    return 0;
}
