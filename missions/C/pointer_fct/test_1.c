#include <stdio.h>


void MYFCT(int i){


  printf("address of i is %p\n", &i);
}
int main(){
  
  int i = 0;  
  printf("address of i is %p\n", &i);
  MYFCT(i);
  return 0;



}



