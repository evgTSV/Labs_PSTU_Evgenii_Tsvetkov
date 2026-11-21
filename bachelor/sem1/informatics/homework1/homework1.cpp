#include <iostream>
#include <utility>
#include <vector>

using Array = std::vector<int>;

void bubbleSort(Array& a) {
    for (int end = static_cast<int>(a.size()) - 1; end > 0; --end) {
        bool changed = false;
        for (int j = 0; j < end; ++j) {
            if (a[j] > a[j + 1]) {
                std::swap(a[j], a[j + 1]);
                changed = true;
            }
        }
        if (!changed) break;
    }
}

void insertionSort(Array& a) {
    for (int i = 1; i < static_cast<int>(a.size()); ++i) {
        int key = a[i];
        int j = i;
        while (j > 0 && a[j - 1] > key) {
            a[j] = a[j - 1];
            --j;
        }
        a[j] = key;
    }
}

void selectionSort(Array& a) {
    int n = static_cast<int>(a.size());
    for (int i = 0; i < n - 1; ++i) {
        int smallest = i;
        for (int j = i + 1; j < n; ++j) {
            if (a[j] < a[smallest]) smallest = j;
        }
        if (smallest != i) std::swap(a[i], a[smallest]);
    }
}

void print(const char* label, const Array& a) {
    std::cout << label << ':';
    for (int x : a) std::cout << ' ' << x;
    std::cout << '\n';
}

int main() {
    int n;
    std::cout << "Number of elements: " << std::endl;
    if (!(std::cin >> n) || n < 0) {
        std::cerr << "Expected a nonnegative size.\n";
        return 1;
    }
    Array original(n);
    std::cout << "Enter the elements:" << std::endl;
    for (int& x : original) {
        if (!(std::cin >> x)) {
            std::cerr << "Expected an integer.\n";
            return 1;
        }
    }
    print("Input", original);
    Array a = original;
    bubbleSort(a);
    print("Bubble", a);
    a = original;
    insertionSort(a);
    print("Insertion", a);
    a = original;
    selectionSort(a);
    print("Selection", a);
    return 0;
}
