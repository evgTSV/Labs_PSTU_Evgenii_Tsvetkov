#include <array>
#include <iostream>
#include <string>
#include <vector>

using Towers = std::array<std::vector<int>, 3>;

void draw(const Towers& towers, int height) {
    int width = 2 * height + 1;
    for (int row = height - 1; row >= 0; --row) {
        for (const auto& tower : towers) {
            int disk = 0;
            if (row < static_cast<int>(tower.size())) disk = tower[row];
            int padding = height - disk;
            std::cout << std::string(padding, ' ');
            if (disk == 0) std::cout << '|';
            else std::cout << std::string(2 * disk + 1, '=');
            std::cout << std::string(padding, ' ') << "  ";
        }
        std::cout << '\n';
    }
    for (int i = 0; i < 3; ++i)
        std::cout << std::string(width, '-') << "  ";
    std::cout << '\n';
    for (char label : std::string("ABC"))
        std::cout << std::string(height, ' ') << label
                  << std::string(height, ' ') << "  ";
    std::cout << "\n\n";
}

void solve(int n, int from, int to, int spare, Towers& towers,
           int height, int& step) {
    if (n == 0) return;
    solve(n - 1, from, spare, to, towers, height, step);
    int disk = towers[from].back();
    towers[from].pop_back();
    towers[to].push_back(disk);
    ++step;
    std::cout << "Move " << step << ": disk " << disk << ", "
              << "ABC"[from] << " -> " << "ABC"[to] << '\n';
    draw(towers, height);
    solve(n - 1, spare, to, from, towers, height, step);
}

int main() {
    int n;
    std::cout << "Number of disks (1..10): " << std::endl;
    if (!(std::cin >> n) || n < 1 || n > 10) {
        std::cerr << "Enter an integer from 1 to 10.\n";
        return 1;
    }
    Towers towers;
    for (int disk = n; disk >= 1; --disk) towers[0].push_back(disk);
    int step = 0;
    std::cout << "Initial state:\n";
    draw(towers, n);
    solve(n, 0, 2, 1, towers, n, step);
    std::cout << "Total moves: " << step << '\n';
    return 0;
}
