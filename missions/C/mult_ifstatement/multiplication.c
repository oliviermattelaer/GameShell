 #include <stdio.h>

 int main(){

   int i = 5;
   int stopat = 10;
   int j=1;
   for(i=1; i<= stopat; i++){
       for(j = 1; j<=stopat; j++){

           //ADD CONDITION HERE
           printf(" %d * %d = %d\n", i, j, i*j);
       }
   }

   return 0;
 }
