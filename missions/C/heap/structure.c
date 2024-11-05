#include <stdio.h>
#include <string.h>

// Define the structure
struct Person {
    char name[50];
    int age;
    float height;
};

void print_Person(struct Person* person){
//define the printout here

    //OLDER CODE
    //printf("Name: %s\n", person1.name);
    //printf("Age: %d\n", person1.age);
    //printf("Height: %f\n",person1.height);
}



int main() {
    // Create a variable of type struct Person
    struct Person person1;

    // Assign values to the fields
    strcpy(person1.name, "Alice");
    person1.age = 30;
    person1.height = 1.98;
    
    print_Person( &person1 );

    return 0;
}


