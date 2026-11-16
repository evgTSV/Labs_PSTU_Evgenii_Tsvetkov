#include <iostream>
#include <cmath>
#include <cstdarg>

const int MAXV = 20;

double length(double x1, double y1, double x2, double y2) {
    return std::sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
}

double square(double x1, double y1, double x2, double y2,
              double x3, double y3) {
    double a = length(x1, y1, x2, y2);
    double b = length(x2, y2, x3, y3);
    double c = length(x3, y3, x1, y1);
    double p = (a + b + c) / 2;
    double s = p * (p - a) * (p - b) * (p - c);
    if (s < 0)
        s = 0;
    return std::sqrt(s);
}

void longestDiagonal(const double x[], const double y[], int k,
                     int &di, int &dj) {
    double dmax = 0;
    for (int i = 0; i < k; i++)
        for (int j = i + 2; j < k; j++) {
            if (i == 0 && j == k - 1)
                continue;
            double d = length(x[i], y[i], x[j], y[j]);
            if (d > dmax) {
                dmax = d;
                di = i;
                dj = j;
            }
        }
}

double maxTriangle(const double x[], const double y[], int k,
                   int di, int dj) {
    double smax = 0;
    for (int t = 0; t < k; t++) {
        if (t == di || t == dj)
            continue;
        double s = square(x[di], y[di], x[dj], y[dj], x[t], y[t]);
        if (s > smax)
            smax = s;
    }
    return smax;
}

double square1(int k, ...) {
    double x[MAXV], y[MAXV];
    if (k < 4 || k > MAXV)
        return 0;
    va_list args;
    va_start(args, k);
    for (int i = 0; i < k; i++) {
        x[i] = va_arg(args, double);
        y[i] = va_arg(args, double);
    }
    va_end(args);
    int di = 0, dj = 2;
    longestDiagonal(x, y, k, di, dj);
    return maxTriangle(x, y, k, di, dj);
}

int main() {
    double r;
    r = length(0, 0, 3, 4);
    std::cout << "length (0,0)-(3,4) = " << r << std::endl;

    r = square(0, 0, 4, 0, 0, 3);
    std::cout << "square (0,0),(4,0),(0,3) = " << r << std::endl;

    r = square1(4, 0.0, 0.0, 4.0, 0.0, 4.0, 2.0, 0.0, 2.0);
    std::cout << "Rectangle 4x2: square1 = " << r << std::endl;

    r = square1(5, 0.0, 0.0, 6.0, 0.0, 7.0, 3.0,
                3.0, 5.0, -1.0, 3.0);
    std::cout << "Pentagon: square1 = " << r << std::endl;

    r = square1(6, 2.0, 0.0, 6.0, 0.0, 8.0, 3.0,
                6.0, 6.0, 2.0, 6.0, 0.0, 3.0);
    std::cout << "Hexagon: square1 = " << r << std::endl;
    return 0;
}
