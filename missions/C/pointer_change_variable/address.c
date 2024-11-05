// my first program in C with adress
#include <stdio.h>

int main()
{

  int i = 5;
  // DEFINE A POINTER NAMED P_i
  // and put has value the address of i
  int* p_i = &i;  
  // PRINT IT
  printf("i is store in ram at address %p \n", p_i);

  // PRINT THE VALUE STORE AT THAT ADDRESS
  printf("the value stored at the address %p is %d\n", p_i, *p_i);
  // ADD the LINE to change (using the pointer) the value to 55
  //


  //print statement to check
  printf("the value stored at the address %p is %d\n", p_i, *p_i);
  printf("the value of the variable i is %d\n", i);
}
