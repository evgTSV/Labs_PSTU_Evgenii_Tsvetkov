#include <iostream>
#include <format>

void first(int m, int n) {  
    int res1 = --m - ++n;
    std::cout << "The result of expr(--m - ++n) is " << res1 << std::endl;
}

void second(int m, int n) {
    int m_i = m, n_i = n;
    if (m * n < n++)
        std::cout << std::format("m * n is lower than n++ ({} < {})", m_i * n_i, n_i++) << std::endl;
    else
        std::cout << std::format("m * n is greater or equal than n++ ({} >= {})", m_i * n_i, n_i++) << std::endl;
}

void third(int m, int n) {
    int m_i = m, n_i = n;
    if (n-- > m++) 
        std::cout << std::format("n-- is greater than m++ ({} > {})", n_i--, m_i++) << std::endl;
    else
        std::cout << std::format("n-- is lower or equal than m++ ({} <= {})", n_i--, m_i++) << std::endl;
}

int main() {
    int m = 0, n = 0;
    
    std::cout << "Enter the two integers m and n: m <space> n" << std::endl;
    std::cin >> m >> n;

    std::cout << std::format("Accepted: m = {}  n = {}", m, n) << std::endl;

    first(m, n);
    second(m, n);
    third(m, n);

    std::cout << "Lab 1, Task 2: Completed successfully!" << std::endl;

    return 0;
}
