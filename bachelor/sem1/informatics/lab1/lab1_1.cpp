#include <iostream>
#include <cmath>

int main() {
    double res = 0;
    double a = 1000;
    double b = 0.0001;

    double sq_a = pow(a, 2), cb_a = pow(a, 3);
    double sq_b = pow(b, 2), cb_b = pow(b, 3);

    res += pow(a - b, 3);
    res -= cb_a - 3 * sq_a * b;
    res /= cb_b - 3 * a * sq_b;

    std::cout << std::fixed << "Lab 1, Task 1: " << res << std::endl;
}
