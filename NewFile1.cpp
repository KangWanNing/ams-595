#include <iostream>
#include <vector>
using namespace std;

// Problem 1: Conditional Statements 
 
void problem1() {
    int n; // Declare an integer variable n.
    cout << "Enter a number: ";
    cin >> n;

    switch (n) {
        case -1:
            cout << "negative one" << endl;
            break;
        case 0:
            cout << "zero" << endl;
            break;
        case 1:
            cout << "positive one" << endl;
            break;
        default:
            cout << "other value" << endl;
            break;
    }
}

// Problem 2: Printing a Vector 

 
void print_vector(vector<int> v) {
    cout << "[";
    for (int i = 0; i < v.size(); i++) {
        cout << v[i];
        if (i != v.size() - 1)
            cout << ", ";
    }
    cout << "]" << endl;
}

// Problem 3: While Loops – Fibonacci 
 
void problem3() {
    long long a = 1, b = 2;

    cout << "Fibonacci numbers <= 4,000,000:" << endl;
    cout << a << ", " << b;

    while (true) {
        long long c = a + b;
        if (c > 4000000) break;

        cout << ", " << c;
        a = b;
        b = c;
    }
    cout << endl;
}

//Problem 4.1: Return true if n is a prime number.

bool isprime(int n) {
    if (n <= 1) return false;

    // Check divisors from 2 to sqrt(n)
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0)
            return false;
    }
    return true;
}

void test_isprime() {
    cout << "isprime(2) = " << isprime(2) << '\n';
    cout << "isprime(10) = " << isprime(10) << '\n';
    cout << "isprime(17) = " << isprime(17) << '\n';
}

//Problem 4.2 Return ALL factors of a number (not prime factors).

vector<int> factorize(int n) {
    vector<int> answer;

    for (int i = 1; i <= n; i++) {
        if (n % i == 0)
            answer.push_back(i);
    }
    return answer;
}

void test_factorize() {
    print_vector(factorize(2));
    print_vector(factorize(72));
    print_vector(factorize(196));
}

// Problem 4.3
vector<int> prime_factorize(int n) {
    vector<int> answer;

    int d = 2;
    while (n > 1) {
        while (n % d == 0) {
            answer.push_back(d);
            n /= d;
        }
        d++;
    }
    return answer;
}

void test_prime_factorize() {
    print_vector(prime_factorize(2));
    print_vector(prime_factorize(72));
    print_vector(prime_factorize(196));
}

//Problem 5: Pascal Triangle 
 
vector<int> next_row(vector<int> prev) {
    vector<int> row;
    row.push_back(1);

    for (int i = 0; i < prev.size() - 1; i++)
        row.push_back(prev[i] + prev[i + 1]);

    row.push_back(1);
    return row;
}

void pascal_triangle(int n) {
    vector<int> row = {1};

    cout << "Pascal Triangle (" << n << " rows):" << endl;
    print_vector(row);

    for (int i = 2; i <= n; i++) {
        row = next_row(row);// mathematical expression
        print_vector(row);
    }
}

//Choose which problem to test.
 
int main() {

    cout << "Select a problem to run:" << endl;
    cout << "1 - Conditional Statements" << endl;
    cout << "2 - Print Vector" << endl;
    cout << "3 - Fibonacci <= 4,000,000" << endl;
    cout << "4 - Test isprime()" << endl;
    cout << "5 - Test factorize()" << endl;
    cout << "6 - Test prime_factorize()" << endl;
    cout << "7 - Pascal Triangle" << endl;

    int choice;
    cin >> choice;

    if (choice == 1) problem1();
    else if (choice == 2) print_vector({1, 2, 3, 4});
    else if (choice == 3) problem3();
    else if (choice == 4) test_isprime();
    else if (choice == 5) test_factorize();
    else if (choice == 6) test_prime_factorize();
    else if (choice == 7) {
        int n;
        cout << "Enter n: ";
        cin >> n;
        pascal_triangle(n);
    } 
    else cout << "Invalid choice." << endl;

    return 0;
}
