#include "string_stack.h"
#include "stdlib.h"
#include "string.h"
#include "stdio.h"

#define INITIAL_CAPACITY 16
#define MINIMUM_CAPACITY 16

struct _Stack {
    char** elements;
    int top;
    int capacity;
};

stack_response create() {
    //initialize a stack, set its top to 0, and return it

    //Initialize the stack and check for out of memory
    stack s = malloc(sizeof(struct _Stack));
    if (s == NULL) {
        return (stack_response){out_of_memory, NULL};
    }
    //Initialize elements and check for out of memory
    s->elements = malloc(INITIAL_CAPACITY * sizeof(char*));
    if (s->elements == NULL) {
        return (stack_response){out_of_memory, NULL};
    }
    //Initialize capacity and top
    s->capacity = INITIAL_CAPACITY;
    s->top = 0;

    return (stack_response){success, s};
}

int size(const stack s) {
    return s->top;
}

bool is_empty(const stack s) {
    return s->top == 0;
}

bool is_full(const stack s) {
    return s->top == MAX_CAPACITY;
} 

response_code push(stack s, char* item) {
    if (is_full(s)){ return stack_full; }

    if (s->top == s->capacity){
        //Resize case

        //Double capacity
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) {
            new_capacity = MAX_CAPACITY;
        }

        //Make new array
        char** new_elements = realloc(s->elements, new_capacity * sizeof(char*));
        if (new_elements == NULL) {
            return out_of_memory;
        }

        //Assign new values
        s->elements = new_elements;
        s->capacity = new_capacity;
    }
    if (strlen(item) > MAX_ELEMENT_BYTE_SIZE) {
            //Check size of input item
            return stack_element_too_large;
    }

    //Push and return success
    s->elements[s->top++] = strdup(item);
    return success;
} 

string_response pop(stack s) {
    if(is_empty(s)) {
        //Empty case
        return (string_response){stack_empty, NULL};
    }
    //Grab the popped string
    char* popped = s->elements[--s->top];

    //Resize case
    if (s->top == s->capacity/4) {
        int new_capacity = s->capacity / 2;
        if (new_capacity < MINIMUM_CAPACITY) {
            //Ensure the capacity never falls below 16
            new_capacity = MINIMUM_CAPACITY;
        }
        //Create and set new elements and capacity
        char** new_elements = realloc(s->elements, new_capacity * sizeof(char*));
        if(new_elements == NULL) {
            return (string_response){out_of_memory, NULL};
        }
        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    return (string_response){success, popped};
}

void destroy(stack* s) {
    free(*s);
    *s = NULL;
}