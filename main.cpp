#include <iostream>
#include <regex>
#include <fstream>
#include <vector>
#include <string>

using namespace std;


bool getValue(string str, int* val);
void setValue(string str, int val);

int registers[5];
int memory[1000];
int pc = 0;


int main(int argv, char* argc[])
{
	///////////

	ifstream file("H7"/*argc[1]*/);
	if(!file.is_open())
		exit(1); // couldnt open file

	vector<string> lines;
	string line;
	while(!file.eof())
	{
		getline(file, line);
		lines.push_back(line);
	}

	////////////

	ofstream outfile("tmp.txt");

	struct L
	{
		vector<int> linenum;
		vector<string> name;
	};
	L labels;

	for(unsigned int i = 0; i < lines.size(); i++)
	{
		for(unsigned int j = 0; j < lines[i].length(); j++)
		{
			lines[i][j] = tolower(lines[i][j]);
		}

		// find labels
		tr1::cmatch res;
		tr1::regex pattern("^(.*):");
		if(tr1::regex_search(lines[i].c_str(), res, pattern))
		{
			// add label and linenum to vector
			string tmp = res[0];
			tmp = tmp.substr(0, tmp.length()-1);
			labels.name.push_back(tmp);
			labels.linenum.push_back(i);

			// remove label from code
			tmp = res[0];
			lines[i] = lines[i].substr(tmp.length(), lines[i].length());
		}


		pattern = "[[:s:]]+";
		string replace = "";
		// if string starts with whitespace
		if(regex_search(lines[i], tr1::regex("^[[:s:]]")))
		{
			// replace whitespaces
			lines[i] = tr1::regex_replace(lines[i], pattern, replace, tr1::regex_constants::format_first_only);
		}
		replace = " ";
		lines[i] = tr1::regex_replace(lines[i], pattern, replace);

		cout << lines[i] << endl;
		outfile << lines[i] << endl;
	}


	// =======================================================
	// tick function
	string cmd;
	while(pc < lines.size())
	{
		size_t pos = lines[pc].find(' ');
		cmd = lines[pc].substr(0, pos);
		string args = tr1::regex_replace(lines[pc].substr(pos+1), tr1::regex("[[:s:]]"), string(""));

		if(cmd == "read")
		{
			int input;
			cout << "\nInput: ";
			cin >> input;
			setValue(lines[pc].substr(pos+1), input);
			pc++;
		}

		else if(cmd == "add")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1, args.substr(pos+1).find(","));
			string arg3 = args.substr(args.find(",", pos+1)+1);

			int sum;
			int tmp;
			if(!getValue(arg1, &sum))
			{
				sum = atoi(arg1.c_str());
			}

			if(!getValue(arg2, &tmp))
			{
				sum += atoi(arg2.c_str());
			}
			else
				sum += tmp;

			setValue(arg3, sum);
			pc++;
		}

		else if(cmd == "sub")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1, args.substr(pos+1).find(","));
			string arg3 = args.substr(args.find(",", pos+1)+1);

			int sum;
			int tmp;
			if(!getValue(arg1, &sum))
			{
				sum = atoi(arg1.c_str());
			}

			if(!getValue(arg2, &tmp))
			{
				sum -= atoi(arg2.c_str());
			}
			else
				sum -= tmp;

			setValue(arg3, sum);
			pc++;
		}

		else if(cmd == "mul")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1, args.substr(pos+1).find(","));
			string arg3 = args.substr(args.find(",", pos+1)+1);

			int sum;
			int tmp;
			if(!getValue(arg1, &sum))
			{
				sum = atoi(arg1.c_str());
			}

			if(!getValue(arg2, &tmp))
			{
				sum *= atoi(arg2.c_str());
			}
			else
				sum *= tmp;

			setValue(arg3, sum);
			pc++;
		}

		else if(cmd == "div")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1, args.substr(pos+1).find(","));
			string arg3 = args.substr(args.find(",", pos+1)+1);

			int sum;
			int tmp;
			if(!getValue(arg1, &sum))
			{
				sum = atoi(arg1.c_str());
			}

			if(!getValue(arg2, &tmp))
			{
				sum /= atoi(arg2.c_str());
			}
			else
				sum /= tmp;

			setValue(arg3, sum);
			pc++;
		}

		else if(cmd == "move")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1);

			int tmp;
			if(!getValue(arg1, &tmp))
			{
				tmp = atoi(arg1.c_str());
			}

			setValue(arg2, tmp);
			pc++;
		}

		else if(cmd == "jpos")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1);

			int tmp;
			if(!getValue(arg1, &tmp))
			{
				tmp = atoi(arg1.c_str());
			}

			if(tmp >= 0)
			{
				bool b = false;
				for(int i = 0; i < labels.name.size(); i++)
				{
					if(labels.name[i] == arg2)
					{
						pc = labels.linenum[i];
						b = true;
					}
				}
				if(!b)
				{
					exit(777);
				}
			}
			else
			{
				pc++;
			}
		}

		else if(cmd == "jneg")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1);

			int tmp;
			if(!getValue(arg1, &tmp))
			{
				tmp = atoi(arg1.c_str());
			}

			if(tmp < 0)
			{
				bool b = false;
				for(int i = 0; i < labels.name.size(); i++)
				{
					if(labels.name[i] == arg2)
					{
						pc = labels.linenum[i];
						b = true;
					}
				}
				if(!b)
				{
					exit(777);
				}
			}
			else
			{
				pc++;
			}
		}

		else if(cmd == "jnz")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1);

			int tmp;
			if(!getValue(arg1, &tmp))
			{
				tmp = atoi(arg1.c_str());
			}

			if(tmp)
			{
				bool b = false;
				for(int i = 0; i < labels.name.size(); i++)
				{
					if(labels.name[i] == arg2)
					{
						pc = labels.linenum[i];
						b = true;
					}
				}
				if(!b)
				{
					exit(777);
				}
			}
			else
			{
				pc++;
			}
		}

		else if(cmd == "jz")
		{
			pos = args.find(",");
			string arg1 = args.substr(0, pos);
			string arg2 = args.substr(pos+1);

			int tmp;
			if(!getValue(arg1, &tmp))
			{
				tmp = atoi(arg1.c_str());
			}

			if(!tmp)
			{
				bool b = false;
				for(int i = 0; i < labels.name.size(); i++)
				{
					if(labels.name[i] == arg2)
					{
						pc = labels.linenum[i];
						b = true;
					}
				}
				if(!b)
				{
					exit(777);
				}
			}
			else
			{
				pc++;
			}
		}

		else if(cmd == "jump")
		{
			bool b = false;
			for(int i = 0; i < labels.name.size(); i++)
			{
				if(labels.name[i] == args)
				{
					pc = labels.linenum[i];
					b = true;
				}
			}
			if(!b)
			{
				exit(777);
			}
		}

		else if(cmd == "print")
		{
			int tmp;
			getValue(args, &tmp);
			cout << tmp << endl;
			pc++;
		}	

		else if(cmd == "\n" || cmd == "")
		{
			pc++;
		}

		else if(cmd == "stop")
		{
			exit(0);
		}

		else
		{
			exit(666);
		}
	}
	// =======================================================

	// test
	/*setValue("r1", 7);
	setValue("m(7)", 50);
	setValue("m(r1)", 40);
	cout << getValue("r1") << endl;
	cout << getValue("m(7)") << endl;
	cout << getValue("m(r1)") << endl;
	*/


	// stop
	cin.get();
}

//==================================

bool getValue(string str, int* val)
{
	tr1::cmatch res;
	string tmp;

	if(tr1::regex_search(str.c_str(), res, tr1::regex("^r([1-5])")))
	{
		tmp = res[1];
		*val = registers[atoi(tmp.c_str())-1];
		return true;
	}

	else if(tr1::regex_search(str.c_str(), res, tr1::regex("m\\(r([1-5])\\)")))
	{
		tmp = res[1];
		*val = memory[registers[atoi(tmp.c_str())-1]];
		return true;
	}

	else if(tr1::regex_search(str.c_str(), res, tr1::regex("m\\(([\\d])\\)")))
	{
		tmp = res[1];
		*val = memory[atoi(tmp.c_str())];
		return true;
	}

	else
	{
		return false;
	}
}

void setValue(string str, int val)
{
	tr1::cmatch res;
	string tmp;

	if(tr1::regex_search(str.c_str(), res, tr1::regex("^r([1-5])")))
	{
		tmp = res[1];
		registers[atoi(tmp.c_str())-1] = val;
	}

	else if(tr1::regex_search(str.c_str(), res, tr1::regex("m\\(r([1-5])\\)")))
	{
		tmp = res[1];
		memory[registers[atoi(tmp.c_str())-1]] = val;
	}

	else if(tr1::regex_search(str.c_str(), res, tr1::regex("m\\(([\\d])\\)")))
	{
		tmp = res[1];
		memory[atoi(tmp.c_str())] = val;
	}

	else
	{
		cout << "error";
	}
}