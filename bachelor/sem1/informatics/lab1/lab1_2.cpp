#include <iostream>
#include <format>

void first(int m, int n) {
    int res = --m - ++n;
    std::cout << std::format("1) --m - ++n = {}  (now m = {}, n = {})",
                             res, m, n) << std::endl;
}

void second(int m, int n) {
    // m * n < n++ reads and modifies n without a sequence point
    // (undefined behavior), so n++ is applied after the comparison
    bool res = m * n < n;
    n++;
    std::cout << std::format("2) m * n < n++ = {}  (now m = {}, n = {})",
                             res, m, n) << std::endl;
}

void third(int m, int n) {
    bool res = n-- > m++;
    std::cout << std::format("3) n-- > m++ = {}  (now m = {}, n = {})",
                             res, m, n) << std::endl;
}

int main() {
    int m = 0, n = 0;

    std::cout << "Enter the two integers m and n: m <space> n"
              << std::endl;
    std::cin >> m >> n;

    std::cout << std::format("Accepted: m = {}  n = {}", m, n)
              << std::endl;

    first(m, n);
    second(m, n);
    third(m, n);

    std::cout << "Lab 1, Task 2: Completed successfully!" << std::endl;

    return 0;
}
