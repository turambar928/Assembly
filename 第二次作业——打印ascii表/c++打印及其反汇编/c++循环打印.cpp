#include<iostream>
using namespace std;

int main() {
	char ch = 'a';
	for (int i = 0;i < 2;i++) {
		for (int j = 0;j < 13;j++) {
			cout << ch;
			ch++;
		}
		cout << "\n";
	}

	return 0;
}