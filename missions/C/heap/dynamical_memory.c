#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main() {


  int* vector;
  vector = malloc(3 * sizeof(int));
    
  if( vector == NULL ) {
    fprintf(stderr, "Error - unable to allocate required memory\n");
    return 1;
  }
  vector[0] = 1;
  vector[1] = 2;
  vector[2] = 3;
    
  //Now increase the size of the array
  vector = realloc( vector, 4 * sizeof(char) );
  if( vector == NULL ) {
      fprintf(stderr, "Error - unable to allocate required memory\n");
      return 1;
    }
  vector[3] = 4;
  
  // print the content
  for(int j=0; j<4; j++){
    printf("%d ", vector[j]);
        
  }
  printf("\n");

  //make the memory available to another program
  free(vector);

}
