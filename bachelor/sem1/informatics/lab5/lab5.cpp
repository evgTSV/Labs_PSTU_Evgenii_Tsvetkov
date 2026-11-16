#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <ctime>

const int MAX = 10;

void shuffle(int p[], int k) {
    for (int i = 0; i < k; i++)
        p[i] = i;
    for (int i = k - 1; i > 0; i--) {
        int r = std::rand() % (i + 1);
        int t = p[i];
        p[i] = p[r];
        p[r] = t;
    }
}

void makeMatrix(int a[][MAX], int n, int m) {
    int p[MAX * MAX];
    shuffle(p, n * m);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            a[i][j] = 10 + p[i * m + j];
}

int buildLine(int a[][MAX], int n, int m, int b[]) {
    int p[MAX];
    int k = 0;
    shuffle(p, n);
    for (int t = 0; t < n; t++)
        for (int j = 0; j < m; j++) {
            b[k] = a[p[t]][j];
            k++;
        }
    shuffle(p, m);
    for (int t = 0; t < m; t++)
        for (int i = 0; i < n; i++) {
            b[k] = a[i][p[t]];
            k++;
        }
    return k;
}

int rowIndex(const int b[], int n, int m, int x) {
    for (int k = 0; k < m * n; k++)
        if (b[n * m + k] == x)
            return k % n;
    return -1;
}

void restore(const int b[], int n, int m, int c[][MAX]) {
    for (int r = 0; r < n; r++) {
        int i = rowIndex(b, n, m, b[r * m]);
        for (int j = 0; j < m; j++)
            c[i][j] = b[r * m + j];
    }
}

void printMatrix(int a[][MAX], int n, int m) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++)
            std::cout << std::setw(4) << a[i][j];
        std::cout << std::endl;
    }
}

bool isEqual(int a[][MAX], int c[][MAX], int n, int m) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (a[i][j] != c[i][j])
                return false;
    return true;
}

int main() {
    int a[MAX][MAX], c[MAX][MAX];
    int b[2 * MAX * MAX];
    int n, m;
    std::srand(std::time(nullptr));

    std::cout << "Enter n and m (1.." << MAX << "): ";
    std::cin >> n >> m;
    while (n < 1 || n > MAX || m < 1 || m > MAX) {
        std::cout << "Wrong size, enter again: ";
        std::cin >> n >> m;
    }

    makeMatrix(a, n, m);
    std::cout << "Source matrix:" << std::endl;
    printMatrix(a, n, m);

    int len = buildLine(a, n, m, b);
    std::cout << "One-dimensional array (rows, then columns):"
              << std::endl;
    for (int k = 0; k < len; k++) {
        std::cout << b[k] << " ";
        if (k == n * m - 1)
            std::cout << std::endl;
    }
    std::cout << std::endl;

    restore(b, n, m, c);
    std::cout << "Restored matrix:" << std::endl;
    printMatrix(c, n, m);

    if (isEqual(a, c, n, m))
        std::cout << "Restored matrix matches the source" << std::endl;
    else
        std::cout << "Restored matrix differs" << std::endl;
    return 0;
}
