 #include <stdio.h>

 int main(){

   int i = 5;
   int j = 0;
   for(int j = 1; j<=10; j++){
     printf(" %d * %d = %d \n", i, j, i*j);
   }
   printf("after the loop j=%d\n", j);
   return 0;
 }
