 #include <stdio.h>

 int main(){

   int i = 5;
   int j = 0;
   for(int j = 1; j<=10; j++){
     printf(" %d * %d = %d \n", i, j, i*j);
   }

   printf("after the loop j=%d\n", j);
   // Note that HERE the for loop does not redefine j
   // compare "int j=1;" with just "j=1;"
   for (j=1;j<=10;j++){
     printf(" %d * %d = %d \n", i, j, i*j);
   }
   printf("after the loop j=%d\n (here no redefinition of j inside the loop-> so not a local variable!)\n", j);

   return 0;
 }
