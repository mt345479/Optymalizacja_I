//     Zadanie:  Problem HETMANÓW
//       autor:  Mateusz Tokarski
//   nr albumu:  345479

#include <iostream>
#include <fstream>
#include <map>

using namespace std;


void Maximize(fstream &file, int n){
	file<<"\\* Problem: Hetman, plansza:"<<n<<" *\\"<<endl<<endl;
	file<<"Maximize"<<endl;
	
	file<<"x1";
	for(int i=2; i<=n*n; i++){
		file<<" + x"<<i;
	}
	file<<endl<<endl;
}

void Subject(fstream &file, int n){
	file<<"Subject to"<<endl;
	file<<"cap:"<<endl;

//-----KOLUMNY
	for(int i=0; i<n; i++){
		for(int j=1; j<=n; j++){
			file<<" + x"<<n*i+j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;

//-----WIERSZE
	for(int i=1; i<=n; i++){
		for(int j=0; j<n; j++){
			file<<" + x"<<i+n*j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;

//-----PRZEK¥TNE
	for(int i=1; i<=n-1; i++){
		for(int j=0; j<=n-i; j++){
			file<<" + x"<<i+(n+1)*j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;
	
	for(int i=1; i<=n-2; i++){
		for(int j=0; j<=n-i-1; j++){
			file<<" + x"<<1+n*i+(n+1)*j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;	
	
	
	for(int i=2; i<=n; i++){
		for(int j=0; j<=i-1; j++){
			file<<" + x"<<i+(n-1)*j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;
	
	for(int i=1; i<=n-2; i++){
		for(int j=0; j<=n-i-1; j++){
			file<<" + x"<<n+n*i+(n-1)*j;
		}
		file<<" <= 1"<<endl;
	}
	file<<endl;	
	
}

void Bounds(fstream &file, int n){
	file<<"Bounds"<<endl;
	
	for(int i=1; i<=n*2; i++){
		file<<"0 <= x"<<i<<" <= 1"<<endl;
	}
	file<<endl<<endl;
}


void Generals(fstream &file, int n){
	file<<"Generals"<<endl;
	
	for(int i=1; i<=n*n; i++){
		file<<"x"<<i<<endl;
	}
}

void wypisz(fstream &file, int n){
	map<int, int> m;
	char c;
	int i=1;
	while(!file.eof()){
		file>>c;
		if(c==':'){
			int a; file>>a;
			if(a==1) m[i]=1;
			i++;
		}
	}
	
	cout<<endl<<endl<<endl<<"   ";
	for(int i=1; i<=n; i++){
		cout<<"+---";
	}cout<<"+"<<endl<<"   ";
	
	int suma=0;
	for(int i=0; i<n; i++){
		for(int j=1; j<=n; j++){
			cout<<"| ";
			if(m[n*i+j]==1){
				cout<<"O ";
				suma++;
			}
			else cout<<"  ";			
		}
		cout<<"|"<<endl<<"   ";
		for(int i=1; i<=n; i++){
			cout<<"+---";
		}cout<<"+"<<endl<<"   ";

	}
cout<<endl<<endl<<"   Na planszy o boku "<<n<<" mozna ustawic "<<suma<<" hetmanow."<<endl<<endl;
}

int main(){
	
	cout << "Podaj dlugosc boku szachownicy: ";
	int n; cin >> n;
		
	fstream file;
    file.open("hetmany.txt", ios::out);
	
	Maximize(file, n);
	Subject(file, n);
	Bounds(file, n);
	Generals(file, n);
	
	file.close();

	cout << "Czy chcesz zobaczyc wynik solvera? (t/n) ";
	char c; cin>>c;
	if(c=='t'){
		cout << endl<<"Rozwiaz program liniowy, ktory pojawil sie w pliku hetmany.txt, przy pomocy solvera (http://hgourvest.github.io/glpk.js/)"<<endl;
		cout << "Otrzymany wynik (wektor zmiennych x) umiesc w pliku wynik.txt w biezacym katalogu"<<endl<<endl;
		cout << "Czy wciagnac juz wynik solvera? (t/n) ";

		cin>>c;
		if(c=='t'){
			file.open("wynik.txt", ios::in);
			wypisz(file, n);
			file.close();
		}
	}
	return 0;
}
