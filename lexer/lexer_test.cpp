#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include <algorithm>
#include <dirent.h>

using namespace std;

int main() {
// za citanje sadrzaja direktorija
	DIR* dir;
	struct dirent* ent;
// vektor sa imenima datoteka	
	vector<string> files;
// stringovi za obradu imena datotkea	
	string filename, filename_results, comm;
// za trazenje tocke	
	size_t pos;
	
// brisem i ponovo stvaram poddirektorij results	
	system("rm -r ./test_files/results");
	system("mkdir ./test_files/results");
// ako postoji folder test_files ulazim u njega	
	if ((dir = opendir ("test_files")) != NULL) {
// petlja koja prolazi kroz sve datoteke iz foldera	
		while ((ent = readdir (dir)) != NULL) {
			filename = string(ent->d_name);
// filtriram ono sta nisu datoteke			
			pos = filename.find(".");
			if(pos != string::npos && pos!=0) {
				filename = filename.substr(0,pos);
				if(find(files.begin(), files.end(), filename) == files.end()) { 
					files.push_back(filename);
				}
			}
		}
		closedir (dir);
	} else {
		/* could not open directory */
		perror ("");
		return EXIT_FAILURE;
	}
	
	int nofiles=1;
	int nok=0;
	cout << endl << "ERRORS IN:" << endl;
// za svaku testnu datoteku	
	for(auto it : files) {
		nofiles++;
// ime testne datoteke		
		filename = ".//test_files//" + it;
// ime izlazne datoteke u folderu results		
		filename_results = ".//test_files//results//" + it;
// string sa naredbom za leksiranje		
		comm = "./lexer "+filename+".cl >"+filename_results+".cool.myout";
		system(comm.c_str());
// otvaram za usporedbu datoteku sa ispravnim izlazom i sa izlazom koji je gornja naredba stvorila
		ifstream out(filename+".cool.out");
		ifstream myout(filename_results+".cool.myout");
// otvaram datoteku u kojoj cu spremiti razlike		
		ofstream diff(filename_results+".diff");
		if( !out || !myout || !diff ) {
			cout << "Error opening test files" << endl;
			return EXIT_FAILURE;
		}

// zapocinjem sa usporedbom		
		string mystr, str;
		int lineno=1;
// preskacem prvu liniju
		getline(myout, mystr);
		getline(out, str);
		getline(myout, mystr);
		getline(out, str);
// je li datoteka ispravna		
		bool ok = true;
		while(myout) {
// micem redne brojeve
			pos = mystr.find(" ");
			if(pos != string::npos && pos!=0) {
				mystr = mystr.substr(pos,mystr.length());
			}
			pos = str.find(" ");
			if(pos != string::npos && pos!=0) {
				str = str.substr(pos,str.length());
			}
// usporedjujem			
			if(mystr!=str) {
				ok = false;
				diff << "error in line# " << lineno << endl;
				diff << "     lexed as: " << mystr << endl;
				diff << "    should be: " << str << endl;
			}
			lineno++;
			getline(myout, mystr);
			getline(out, str);
		}
// je li izlazna datoteka ispravna		
		if(ok) {
			nok++;
		} else {
// ispisi redni broj i ime datoteke	
			cout << "    test file #"<< nofiles <<" : " << it << endl;
		}
		myout.close();
		out.close();
		diff.close();
	}	
	cout << "_____________________________" << endl << "Grade: " << nok << "/" << --nofiles << endl;
	return 0;
}
