#include <iostream>
#include <map>
#include <vector>
#include <fstream>

using namespace std;

int N;
void wczytaj(fstream& data, fstream& test){
	data >> N;
	test << "//###########################################"<<endl<<endl;
	test << "N = "<<N<<";"<<endl<<endl;
	
	test<<"for(int i=0 ; i < N; i++){"<<endl;
	test<<"	Wsa[i] = new Node(i);"<<endl;
	test<<"	Union[i] = new Node(i);"<<endl;
	test<<"	}"<<endl;
	
	
	for(int i=0 ; i < N; i++){
		int Bw, Bu, Rw, Ru;
		data >> Bw;
		data >> Bu;
		data >> Rw;
		data >> Ru;
		
		test << "Wsa["<<i<<"]->dodaj("<<Bw<<","<<Rw<<",Wsa);"<<endl;
		test << "Union["<<i<<"]->dodaj("<<Bu<<","<<Ru<<",Union);"<<endl<<endl;
	}
	test << "WSA = deepcopy(Wsa);"<<endl;
	test << "UNION = deepcopy(Union);"<<endl;
	test <<endl<< "//###########################################";
}


int main(){
	
	fstream data;
    data.open("data.txt");
    if(data.good()) cout<<"Uzyskano dostep do pliku!"<<endl<<endl;
	else cout<<"Dostep do pliku zabroniony!"<<endl<<endl;
	
	fstream test;
    test.open("test.txt", ios::out);
    if(test.good()) cout<<"Stworzono plik odpowiedzi!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku odpowiedzi!"<<endl<<endl;
	
	wczytaj(data,test);
	
	data.close();
	test.close();
	return 0;
}
