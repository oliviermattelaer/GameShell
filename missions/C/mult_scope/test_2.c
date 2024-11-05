#include <stdio.h>


void print_table(int tableof, int length){

  // NOTE THIS LINE
  length = length + 1;

  for(int j = 1; j<length; j++){
    printf(" %d * %d = %d \n", tableof, j, tableof*j);
  }

}


int main(){
  
  int table = 5;
  int length = 10;
  print_table(table, length);
  printf("lenght=%d\n", length);
  return 0;

}

