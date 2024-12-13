// C code for dot product for any 2 arrays of size i:

// #include <stdio.h>
int dot(int*, int*, int);
int main()
{
    // int i;
    // int A[] = {1,2,3,4,6,7,8,9}; // array A that can be extended
    // int B[] = {4,5,6,7,1,2,2,17}; // array B that can be extended
    int A[17], B[17];
    
    // Assign each element individually
    A[0] = 1;
    A[1] = 2;
    A[2] = 3;
    A[3] = 4;
    A[4] = 6;
    A[5] = 7;
    A[6] = 8;
    A[7] = 9;
    A[8] = 1;
    A[9] = 2;
    A[10] = 3;
    A[11] = 4;
    A[12] = 5;
    A[13] = 0;
    A[14] = 2;
    A[15] = 3;
    A[16] = 4;

    B[0] = 1;
    B[1] = 2;
    B[2] = 3;
    B[3] = 4;
    B[4] = 6;
    B[5] = 7;
    B[6] = 8;
    B[7] = 9;
    B[8] = 1;
    B[9] = 2;
    B[10] = 3;
    B[11] = 4;
    B[12] = 5;
    B[13] = 0;
    B[14] = 2;
    B[15] = 3;
    B[16] = 4;


    int length = sizeof(A) / sizeof(A[0]);
    

    int dp = dot(A, B, length);
    // printf("the dot product of both vectors is: %i",dp);
    while(1);
    return 0;
}

int dot(int* A, int* B, int length){
    int dp = 0; // dot product (dp) integer
    int i;
    for(i = 0; i < length; i++)
    {
    
    int dot =  A[i] * B[i];
    
    dp = dp + dot;
    }

    return dp;
}
