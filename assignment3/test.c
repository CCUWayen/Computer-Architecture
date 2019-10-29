void main(){
	int N = 10,i,sum=0;
	for(i=1;i<=N;i=i+1)
		sum = sum +i;
	printInt(sum) ;
}
void printInt(int result){
	volatile char* tx = (volatile char*) 0x40002000;
 	int dict[9] ={1,10,100,1000,10000,100000,1000000,10000000,100000000};
 	int mx = 900000000,i,j,isprint=0;
	if(result >> 31){
		*tx = '-';
		result = -result;
	} 
	for(i=8;i>=0;i=i-1){
		int print = -1;
		for(j=9;j>=1;j--){
			if ( result >= mx){
				isprint =1;
				print = j;
				result = result - mx;
			}
			mx = (j!=1)? (mx - dict[i]):(mx-dict[i-1]);
		}
		if(print!=-1) *tx = (print+48);
		else if (isprint) *tx = 48;
	}
}
