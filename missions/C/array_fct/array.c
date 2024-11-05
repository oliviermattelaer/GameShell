#include <stdio.h>

// you do not need to change this function which is defined at the end of the file.
float average(float myarray[], int size);
//we could have write float average(float* myarray, int size);
 

int main () {

  float n[10]; /* n is an array of 10 float */
  int i,j;
 
  /* initialize elements of array n to 0 */         
  for ( i = 0; i < 10; i++ ) {
    n[ i ] = i + 100; 
  }
  
  int nb_element = 10;
  // This compute the (full) average)
  // You need to change this line to compute the average of the last five elements.
  float output = average(n,nb_element);    
  printf( "average of #%d element is %f\n", nb_element, output);
 
  return 0;
}



// DO NOT CHANGE THE FUNCTION
float average(float myarray[], int size){
    
  float average =0.;
  for (int i =0; i<size; i++){
    //printf("Element[%d] = %f\n", i, myarray[i] );
    average += myarray[i];
    myarray[i]=0;
  }
  average /= size;
  return average;
} 
 
