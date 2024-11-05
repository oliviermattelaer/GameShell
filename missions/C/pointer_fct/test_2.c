#include <stdio.h>


void MYFCT(int* p_i){


  printf("address of i is %p\n", p_i);
  printf("value of i is %d\n", *p_i);
}
int main(){
  
  int i = 0;  
  printf("address of i is %p\n", &i);
  printf("value of i is %d\n", i);
  MYFCT(&i);
  return 0;



}



