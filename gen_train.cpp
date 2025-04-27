#include<iostream>
#include<math.h>

using namespace std;

double line_func(double x)
{
	double m,c,y;
	m=4444;
	c=333;
	y=m*x+c;
	return y;
}

int main()
{
	int n=94;
	double ms,V1,V2;
	double err,sum,rmsd;
	sum=0.0;


	for(int i=0;i<n;i++)
	{
		cin>>ms>>V1;
		V2=line_func(ms);
		err=V2-V1;
		sum=sum+(err*err);
		cout<<ms<<"\t"<<V1<<"\t"<<V2<<"\t"<<err<<"\n";
	}

	rmsd=sqrt(sum/n);

	cout<<"\nRMSD= "<<rmsd; 


}
