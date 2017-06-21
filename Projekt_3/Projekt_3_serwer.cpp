#include <iostream>
#include <map>
#include <vector>
#include <fstream>

using namespace std;

class Node{
	int Id;
	Node* szef;
	vector<Node*> pracownicy;
	int wymog;
	int l_pracownikow=0;
	
	public:
		Node(int id): Id(id){};
		void dodaj(int, int, map<int, Node*>);
		friend ostream& operator << (ostream&, Node*);
		friend ostream& operator << (ostream&, vector<Node*>);
		
		friend map<int, Node*> wyrzuc(map<int, Node*>,int);
		friend map<int, Node*> deepcopy(map<int, Node*>);
		friend vector<Node*> droga(map<int, Node*>,int,int);
		friend void Zwolnij(map<int, Node*>,int);
		friend Node* zwolnij(map<int, Node*>,Node*,int,bool&);
		//friend void awans(map<int, Node*>,int);
		friend void departament(vector<Node*>);
		
		friend void dobre(map<int, Node*>,int);
		friend int Dobre(map<int, Node*>,int);
		friend bool DOBRE(map<int, Node*>);
};
map<int, Node*> Wsa, Union, WSA, UNION;

map<int, Node*> deepcopy(map<int, Node*>Map1){
	map<int, Node*> Map2;
	
	for(typename map<int, Node*>::const_iterator it=Map1.begin(); it!=Map1.end(); it++){
		int i = it->second->Id;
        Map2[i] = new Node(i);
    }
    for(typename map<int, Node*>::const_iterator it=Map1.begin(); it!=Map1.end(); it++){
		int i = it->second->Id;
        Map2[i]->dodaj(it->second->szef->Id, it->second->wymog ,Map2);
    }
    return Map2;
}


void Node:: dodaj(int szef_id, int Wymog, map<int, Node*> Pracownicy){
	wymog = Wymog;
	szef = Pracownicy[szef_id];
	szef->l_pracownikow++;
	szef->pracownicy.push_back(this);
}
ostream& operator << (ostream& wyjscie, vector<Node*>);

ostream& operator << (ostream& wyjscie, Node* node){
	wyjscie << node->Id <<"["<<node->wymog<<"]" <<"("<<node->l_pracownikow<<")" << ": "/*<<node->pracownicy*/;
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
		data >> Bu;
		data >> Rw;
		data >> Ru;
		Wsa[i]->dodaj(Bw,Rw,Wsa);
		Union[i]->dodaj(Bu,Ru,Union);
	}
	WSA = deepcopy(Wsa);
	UNION = deepcopy(Union);
}
ostream& operator << (ostream&, map<int, Node*> );

map<int, Node*> wyrzuc(map<int, Node*> Map, int id){
	//cout << "wyrzucam "<< id << endl;
	map<int, Node*> Pracownicy = Map;
	for(int i=0; i<Pracownicy[id]->szef->l_pracownikow; i++){
		if(Pracownicy[id]->szef->pracownicy[i]->Id == id)
			Pracownicy[id]->szef->pracownicy.erase(Pracownicy[id]->szef->pracownicy.begin()+i);
	}
	Pracownicy[id]->szef->l_pracownikow--;
	
	for(int i=0; i<Pracownicy[id]->l_pracownikow; i++){
		Pracownicy[id]->pracownicy[i]->szef = Pracownicy[id]->szef;
		Pracownicy[id]->szef->l_pracownikow++;
		Pracownicy[id]->szef->pracownicy.push_back(Pracownicy[id]->pracownicy[i]);
		
		Pracownicy[id]->pracownicy.erase(Pracownicy[id]->pracownicy.begin()+i);
	}
	Pracownicy.erase(id);
	return Pracownicy;
}

vector<Node*> inverse(vector<Node*> v){
	vector<Node*> w;
	int s = v.size();
	for(int i=0; i<s; i++){
		w.push_back(v[s-i-1]);
	}
	return w;
}

vector<Node*> droga(map<int, Node*> Map, int Pocz, int Koniec){
	vector<Node*> droga;
	Node* pocz = Map[Pocz];
	Node* koniec=Map[Koniec];
	do{
		droga.push_back(koniec);
		koniec = koniec->szef;
	}while(koniec->Id != pocz->Id);
	droga.push_back(koniec);
	return inverse(droga);
}

Node* zwolnij(map<int, Node*> Pracownicy, Node* ostatni, int pocz, bool& KONIEC){
	//cout<<pocz<<" ";
	for(int i=0; i<Pracownicy[pocz]->l_pracownikow && !KONIEC; i++)if(Pracownicy[pocz]->pracownicy[i]->Id != pocz){
		Node* koniec = Pracownicy[pocz]->pracownicy[i];
		ostatni = koniec;
		if(koniec->wymog == 0) {
			//koniec->wymog = 100;
			KONIEC = true;
		}
		else ostatni = zwolnij(Pracownicy,ostatni,koniec->Id,KONIEC);
	}
	return ostatni;
}

void departament(vector<Node*> droga){
	droga = inverse(droga);
	for(int i=0; i<droga.size()-1; i++){
		droga[i]->wymog = droga[i+1]->wymog;
		for(int j=0; j<droga[i+1]->l_pracownikow; j++)if(droga[i+1]->pracownicy[j]->Id != droga[i]->Id){
			/*if(droga[i+1]->pracownicy[j]->Id == droga[i+1]->Id) droga[i]->pracownicy.push_back(droga[i]);
			else*/ droga[i]->pracownicy.push_back(droga[i+1]->pracownicy[j]);
			droga[i+1]->pracownicy[j]->szef = droga[i];
			droga[i]->l_pracownikow++;
		}
		droga[i+1]->l_pracownikow = 1;
		vector<Node*> v; v.push_back(droga[i]);
		droga[i+1]->pracownicy = v;
	}
}

ostream& operator << (ostream& wyjscie, map<int, Node*> Pracownicy){
	for(typename map<int, Node*>::const_iterator it=Pracownicy.begin(); it!=Pracownicy.end(); it++){
        wyjscie << it->second << endl;
    }
	return wyjscie;
}

ostream& operator << (ostream& wyjscie, vector<Node*> droga){
	for(int i=0; i<droga.size(); i++){
        wyjscie << droga[i]->Id <<"["<<droga[i]->wymog<<"] ";
    }
    wyjscie<<endl;
	return wyjscie;
}



ostream& operator << (ostream& wyjscie, vector< map<int, Node*> > VECTOR){
	for(int i=0; i<VECTOR.size(); i++){
        wyjscie << "Usuniecie z drzewa nr "<<i+1<<endl<<VECTOR[i]<<endl<<endl;
    }
    wyjscie<<endl;
	return wyjscie;
}

void dobre(map<int, Node*>,int,int);
int Dobre(map<int, Node*>,int);
bool DOBRE(map<int, Node*>);

vector< map<int, Node*> > VECTOR;
void Zwolnij(map<int, Node*> Map, int id){
	bool koniec = false;
	//for(int k=0; k<v.size(); k++){
	//	int id = v[k];
		//cout<<endl<<"Zwalniam "<<Map[id]->Id<<endl;
		if(Map[id]->wymog==0){
			
			Map = wyrzuc(Map,id);
			if(DOBRE(Map))VECTOR.push_back(Map);
			//cout<<"Dopisuje do VECTORa drzewo z \"POCZATKIEM\": "<<id<<" z \"KONCEM\": "<<id<<endl<<Map<<endl<<endl;
			koniec = true;
		}
		
		//(Map[id]->l_pracownikow != 0){cout<<endl<<Map[id]->Id<<" ma pracowników"<<endl;
			if(!koniec)for(int i=0; i<Map[id]->l_pracownikow; i++)if(Map[id]->Id == Map[id]->pracownicy[i]->Id){
				//cout<<endl<<Map[id]->Id<<" to korzeñ!!!"<<endl;
				Map[id]->pracownicy.erase(Map[id]->pracownicy.begin()+i);
				Map[id]->l_pracownikow--;
				bool a= false; 
				int cos = zwolnij(Map,Map[id],id,a)->Id;
				
				//###################################### NIE UDA£O SIE USUN¥Æ Map[id] !!! ######################################
				if(Map[cos]->wymog != 0){
					//cout<<"Nie usunalem "<<endl;
					koniec = true;
				}
				//###################################### NIE UDA£O SIE USUN¥Æ Map[id] !!! ######################################
				
				if(!koniec){
					map<int, Node*> Map2 = deepcopy(Map);
					Map2[cos]->wymog = -1;
					//cout<<"wpadlem tutaj"<<endl;
					Zwolnij(Map2,id);
					//Zwolnij(Map,id);//############
					
					departament(droga(Map, id, cos));
					Map[id]->pracownicy[0]->szef = Map[id]->pracownicy[0];
					Map[id]->pracownicy[0]->pracownicy.push_back(Map[id]->pracownicy[0]);
					Map[id]->pracownicy[0]->l_pracownikow++;
					//cout<<endl<<"szef "<<Map[id]->pracownicy[0]->Id<<" to: "<<Map[id]->pracownicy[0]->szef->Id<<endl;
					//Map = wyrzuc(Map,id);
					Map.erase(id);
					
					//cout<<"Dopisuje do VECTORa drzewo z \"POCZATKIEM\": "<<id<<" z \"KONCEM\": "<<cos<<endl<<Map<<endl<<endl;
					
					if(DOBRE(Map))VECTOR.push_back(Map);//#############
					koniec = true;
					break;
					}
			}
		//}
		if(!koniec){
			bool a= false; 
			int cos = zwolnij(Map,Map[id],id,a)->Id;
			//###################################### NIE UDA£O SIE USUN¥Æ Map[id] !!! ######################################
			if(Map[cos]->wymog != 0) koniec = true;
			//###################################### NIE UDA£O SIE USUN¥Æ Map[id] !!! ######################################
			else {map<int, Node*> Map2 = deepcopy(Map);
			Map2[cos]->wymog = -1;
			Zwolnij(Map2,id);
			//Zwolnij(Map,id);//############
			departament(droga(Map, id, cos));
			Map = wyrzuc(Map,id);
			//cout<<"Dopisuje do VECTORa drzewo z \"POCZATKIEM\": "<<id<<" z \"KONCEM\": "<<cos<<endl<<Map<<endl<<endl;
			if(DOBRE(Map))VECTOR.push_back(Map);//#############
			koniec = true;}
		}
//	}
}

void ZWOLNIJ(map<int, Node*> MAP, vector<int> v){
	
	vector< map<int, Node*> > w;
	w.push_back(MAP);
	for(int i=0; i<v.size(); i++){
		for(int j=0; j<w.size(); j++){
			map<int, Node*> Map = deepcopy(MAP);
			Zwolnij(w[j],v[i]);
		}
		if(VECTOR.size() != 0){
			
			w = VECTOR;
			VECTOR.clear();	
		}
	}
	VECTOR = w;
}


int spr;
void dobre(map<int, Node*> Map, int id){
	spr++;
	for(int i=0; i<Map[id]->l_pracownikow; i++)if(id!=Map[id]->pracownicy[i]->Id){
		
		dobre(Map, Map[id]->pracownicy[i]->Id);
	}
}

int Dobre(map<int, Node*> Map, int id){
	spr=0; dobre(Map, id);
	return spr;
}

bool DOBRE(map<int, Node*> Map){
	for(typename map<int, Node*>::const_iterator it=Map.begin(); it!=Map.end(); it++){
        if(Dobre(Map,it->second->Id) < it->second->wymog)return false;
    }return true;
}

int potega2(int n){
	int a=1;
	for(int i=0; i<n; i++)
		a*=2;
	return a;
}

vector<int> bin(int n){
	vector<int> v;
	while(n){
		v.push_back(n%2);
		n/=2;
	}
	return v;
}
ostream& operator << (ostream& wyjscie, vector<int> v){
	for(int i=0; i<v.size(); i++){
        wyjscie <<v[i]<<" ";
    }
    wyjscie<<endl;
	return wyjscie;
}

int main()
{
//###########################################

N = 5;

for(int i=0 ; i < N; i++){
	Wsa[i] = new Node(i);
	Union[i] = new Node(i);
	}
Wsa[0]->dodaj(1,1,Wsa);
Union[0]->dodaj(0,2,Union);

Wsa[1]->dodaj(2,1,Wsa);
Union[1]->dodaj(0,2,Union);

Wsa[2]->dodaj(2,2,Wsa);
Union[2]->dodaj(1,0,Union);

Wsa[3]->dodaj(2,0,Wsa);
Union[3]->dodaj(1,1,Union);

Wsa[4]->dodaj(1,0,Wsa);
Union[4]->dodaj(3,0,Union);

WSA = deepcopy(Wsa);
UNION = deepcopy(Union);

//###########################################
	
	cout << "UNION tree: " <<endl<<endl << UNION <<endl<<endl;
	vector<int> v;
	vector<int> w;
	map<int,Node*> ROZ;
	v.clear();
	for(int i=1; i<potega2(N);i++){
		for(int j=0; j<bin(i).size(); j++){
			if(bin(i)[j])v.push_back(j);
			
		}
		map<int,Node*> MAP = deepcopy(UNION);
		ZWOLNIJ(MAP, v);
		
		for(int j=0; j<VECTOR.size(); j++){
	        if(VECTOR[j].size() == MAP.size()-v.size() && v.size()>w.size()){
	        	w = v;
	        	ROZ = deepcopy(VECTOR[j]);
	        	break;
	        }
    	}
		VECTOR.clear();
		v.clear();
	}cout << "Maksymalnie mozna usunac "<<w.size()<<" pracownikow: " <<endl<<w<<endl<<ROZ<<endl<<endl;
	
	
	return 0;
}
