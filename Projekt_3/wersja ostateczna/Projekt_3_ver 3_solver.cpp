#include <iostream>
#include <map>
#include <vector>
#include <fstream>

using namespace std;

class Node{
	int Id;
	Node* szef;
	vector<Node*> pracownicy, poddrzewo;
	int wymog;
	int l_pracownikow;
	
	public:
		
		Node(int id): Id(id), l_pracownikow(0){};
		
		void dodaj(int, int, map<int, Node*>);
		int Pracownicy();
		void Poddrzewo();
		
		friend ostream& operator << (ostream&, Node*);
		friend ostream& operator << (ostream&, vector<Node*>);
		
		friend void solver(fstream&);
		friend int main();
		friend int MAX(map<int, Node*>);
		friend bool DOBRE(map<int, Node*>,int[]);
};
map<int, Node*> Wsa, Union;
Node *Wsa_root, *Union_root;

void Node:: dodaj(int szef_id, int Wymog, map<int, Node*> Pracownicy){
	wymog = Wymog;
	szef = Pracownicy[szef_id];
	if(this->Id != szef_id){
		szef->l_pracownikow++;
		szef->pracownicy.push_back(this);
	}		
}

int Node::Pracownicy(){
	for(int i=0; i<pracownicy.size(); i++)
		l_pracownikow += pracownicy[i]->Pracownicy();
	return l_pracownikow++;
}

void Node::Poddrzewo(){
	poddrzewo.push_back(this);
	for(int i=0; i<pracownicy.size(); i++){
		pracownicy[i]->Poddrzewo();
		for(int j=0; j<pracownicy[i]->poddrzewo.size(); j++)
			poddrzewo.push_back(pracownicy[i]->poddrzewo[j]);
	}
}

ostream& operator << (ostream& wyjscie, vector<Node*>);

ostream& operator << (ostream& wyjscie, Node* node){
	wyjscie << node->Id <<"["<<node->wymog<<"]" <<"("<<node->l_pracownikow<<")" << ": ";
	for(int i=0; i<node->pracownicy.size(); i++)
		wyjscie << node->pracownicy[i]->Id << " ";
	return wyjscie;
}

int N;
void wczytaj(fstream& data){
	data >> N;
	for(int i=0 ; i < N; i++){
		Wsa[i] = new Node(i);
		Union[i] = new Node(i);
	}
	
	
	for(int i=0 ; i < N; i++){
		int Bw, Bu, Rw, Ru;
		data >> Bw;
		if(Bw == i) Wsa_root = Wsa[i];
		data >> Bu;
		data >> Rw;
		if(Bu == i) Union_root = Union[i];
		data >> Ru;
		Wsa[i]->dodaj(Bw,Rw,Wsa);
		Union[i]->dodaj(Bu,Ru,Union);
	}
	Wsa_root->Pracownicy();
	Wsa_root->Poddrzewo();
	Union_root->Pracownicy();
	Union_root->Poddrzewo();
}

ostream& operator << (ostream& wyjscie, map<int, Node*> Pracownicy){
	for(typename map<int, Node*>::const_iterator it=Pracownicy.begin(); it!=Pracownicy.end(); it++){
        wyjscie << it->second << endl;
    }
	return wyjscie;
}

bool DOBRE(map<int, Node*> Map, int wagi[]){
	for(int i=0; i < N; i++){
		int war=0;
		for(int j=0; j<Map[i]->poddrzewo.size(); j++){
			if(wagi[Map[i]->poddrzewo[j]->Id] == 0) war++;
		}
			
        if(war < Map[i]->wymog)return false;
    }return true;
}

ostream& operator << (ostream& wyjscie, int v[]){
	for(int i=0; i<N; i++)
       if(v[i]) wyjscie<<i<<" ";
    wyjscie<<endl;
	return wyjscie;
}

void solver(fstream& file){
	file<<"\\* Problem: SPY UNION*\\"<<endl<<endl;
	file<<"Minimize"<<endl;
	for(int i=0; i<N; i++)
		file<<" + x"<<i;
		
	file<<endl<<endl<<"Subject To"<<endl;
	for(int i=0; i<N; i++){
		for(int j=0; j<Wsa[i]->poddrzewo.size(); j++)
			file<<" + x"<<Wsa[i]->poddrzewo[j]->Id;
		file<<" >= "<<Wsa[i]->wymog<<endl;
	}
	for(int i=0; i<N; i++){
		for(int j=0; j<Union[i]->poddrzewo.size(); j++)
			file<<"+ x"<<Union[i]->poddrzewo[j]->Id;
		file<<" >= "<<Union[i]->wymog<<endl;
	}
	
	file<<endl<<endl<<"Bounds"<<endl;
	for(int i=0; i<N; i++)
		file<<"0 <= x"<<i<<" <= 1"<<endl;
		
	file<<endl<<endl<<"Generals"<<endl;
	for(int i=0; i<N; i++)
		file<<"x"<<i<<endl;
}

void wypisz(fstream &file, fstream &out){
	vector<int> v;
	char c;
	int i=0;
	while(!file.eof()){
		file>>c;
		if(c==':'){
			int a; file>>a;
			if(a==0) v.push_back(i);
			i++;
		}
	}
	
	int n=v.size();
	//cout<<n<<endl;
	out<<n<<endl;
	for(int i=0; i<n; i++){
		//cout<<v[i]<<" ";
		out<<v[i]<<" ";
	}
}
	
int main()
{
    fstream data;
    data.open("9in.txt");
    if(data.good()) cout<<"Uzyskano dostep do pliku!"<<endl<<endl;
	else cout<<"Dostep do pliku zabroniony!"<<endl<<endl;
	/*
	fstream out;
    out.open("3out.txt", ios::out);
    if(out.good()) cout<<"Stworzono plik \"out\"!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku \"out\"!"<<endl<<endl;	
	
	fstream file;
    file.open("wynik3.txt", ios::out);
    if(file.good()) cout<<"Stworzono plik wyniku solvera!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku z wynikiem solvera!"<<endl<<endl;
*/
	fstream solv;
    solv.open("solver_glpk_9.txt", ios::out);
    if(solv.good()) cout<<"Stworzono plik solvera!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku solvera!"<<endl<<endl;

	
	wczytaj(data);
	solver(solv);
	/*
	cout<<"Union tree:"<<endl<<Union<<endl<<"Wsa tree:"<<endl<<Wsa<<endl<<endl;
	
	cout << "Czy chcesz zobaczyc wynik solvera? (t/n) ";
	char c; cin>>c;
	if(c=='t'){
		cout << endl<<"Rozwiaz program liniowy, ktory pojawil sie w pliku solver_glpk.txt, przy pomocy solvera (http://hgourvest.github.io/glpk.js/)"<<endl;
		cout << "Otrzymany wynik (wektor zmiennych x) umiesc w pliku wynik.txt w biezacym katalogu"<<endl<<endl;
		cout << "Czy wciagnac juz wynik solvera? (t/n) ";

		cin>>c;
		if(c=='t'){
			wypisz(file,out);
			file.close();
		}
	}
	
	out.close();*/
	data.close();
	solv.close();
	return 0;
}
