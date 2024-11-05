#include <stdio.h>
#include <string.h>

// Define the structure
struct Person {
    char name[50];
    int age;
    float height;
};


int main() {
    // Create a variable of type struct Person
    struct Person person1;

    // Assign values to the fields
    strcpy(person1.name, "Alice");
    person1.age = 30;
    // set the height to the person to 1.98

    // Print the values
    printf("Name: %s\n", person1.name);
    printf("Age: %d\n", person1.age);
    // add a printout for the height

    return 0;
}


