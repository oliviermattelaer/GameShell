 #include <stdio.h>

 int main(){

   int i = 5;
   int stopat = 10;
   int j=1;
   while(j<=stopat){
       printf("%d * %d = %d\n",i , j, i*j);
       j++;
   }
   return 0;
 }
