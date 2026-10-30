#include <iostream>
#include <cmath>
#include <format>

double sumN(double x, int N) {
    double a = x;
    double s = 0;
    for (int n = 0; n <= N; n++) {
        s += a;
        a *= x * x / ((2 * n + 2) * (2 * n + 3));
    }
    return s;
}

double sumEps(double x, double eps) {
    double a = x;
    double s = 0;
    int n = 0;
    while (std::fabs(a) >= eps) {
        s += a;
        a *= x * x / ((2 * n + 2) * (2 * n + 3));
        n++;
    }
    return s;
}

int main() {
    const double A = 0.1, B = 1.0;
    const int K = 10;
    const int N = 20;
    const double EPS = 0.0001;
    double step = (B - A) / K;

    std::cout << "Lab 3, Variant 25: y = (e^x - e^(-x)) / 2, "
              << "S = x + x^3/3! + ... + x^(2n+1)/(2n+1)!" << std::endl;
    std::cout << std::format("n = {}, eps = {:.4f}", N, EPS) << std::endl;

    for (int i = 0; i <= K; i++) {
        double x = A + i * step;
        double sn = sumN(x, N);
        double se = sumEps(x, EPS);
        double y = (std::exp(x) - std::exp(-x)) / 2;
        std::cout << std::format("X={:.2f}  SN={:.6f}  ", x, sn)
                  << std::format("SE={:.6f}  Y={:.6f}", se, y)
                  << std::endl;
    }

    return 0;
}
