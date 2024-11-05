 #include <stdio.h>

// DEFINE THE FUNCTION print_table here
// It should CHANGE the value of the input 
// such that the next call does print another table
int print_table(  ARGUMENTS){

  // make sure i is defined (via arguments or something else)

  for(int j = 1; j<=10; j++){
    printf(" %d * %d = %d\n", i, j, i*j);
  }

  //Change the value of i for the next call

}


// Note that you will need to change the main!
 int main(){
   int i = 4;
   //do not add any line between the next two.
   print_table(i);
   print_table(i);
 }





