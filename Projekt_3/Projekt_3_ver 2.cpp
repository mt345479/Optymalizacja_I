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

int MAX(map<int,Node*> Map){
	int MAX=0;
	for(int i=0; i<N; i++) if(Map[i]->wymog == 0) MAX++;
	
	return MAX;
}

int min_max(map<int,Node*> Map1, map<int,Node*> Map2){
	int MAX_Map1 = MAX(Map1), MAX_Map2 = MAX(Map2);
	if(MAX_Map1 > MAX_Map2) return MAX_Map2;
	
	return MAX_Map1;
}

void solver(fstream& file){
	file<<"\\* Problem: SPY UNION*\\"<<endl<<endl;
	file<<"Maximize"<<endl;
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


int main()
{
    fstream data;
    data.open("1in.txt");
    if(data.good()) cout<<"Uzyskano dostep do pliku!"<<endl<<endl;
	else cout<<"Dostep do pliku zabroniony!"<<endl<<endl;
	
	fstream file;
    file.open("file.txt", ios::out);
    if(file.good()) cout<<"Stworzono plik odpowiedzi!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku odpowiedzi!"<<endl<<endl;
	
	fstream solv;
    solv.open("solver_glpk.txt", ios::out);
    if(solv.good()) cout<<"Stworzono plik solvera!"<<endl<<endl;
	else cout<<"Nie mozna stworzyc pliku solvera!"<<endl<<endl;
	
	wczytaj(data);
	solver(solv);
	
	cout<<Union;
	
	cout<<endl<<"Minimum z liczb departamentow zerowych = "<<min_max(Wsa,Union)<<endl<<endl;
	bool koniec = false;
	for(int K = N-1 ; K>0 && !koniec; K--){
		K--;
	    int p=K, tab[K], wagi[N];
	    for(int i =0; i <= K; i++)
		    tab[i]=i;
		
	    while(p>=0 && !koniec)
	    {
	    	
	        for(int i=0; i < N; i++)
		    	wagi[i]=0;
		    
		    bool koniec2=false;
			for(int i=0; i<=K; i++){
				wagi[tab[i]] = 1;
				if((Wsa[tab[i]]->l_pracownikow == 0 && Wsa[tab[i]]->wymog != 0) || (Union[tab[i]]->l_pracownikow == 0 && Union[tab[i]]->wymog != 0) ) koniec2 = true;
			}if(koniec2)break;
		    
		    if(DOBRE(Wsa,wagi) && DOBRE(Union,wagi)){
		    	cout<<K+1<<endl<<wagi;
		    	koniec=true;
		    }
		    
	        if(tab[K]==N-1) p=p-1;
	        else p=K;
	 
	        if(p>=0)
	            for(int i=K; i>=p; i--)
		            tab[i] = tab[p] + i - p + 1;
	    }
	}
	data.close();
	file.close();
	solv.close();
	return 0;
}
