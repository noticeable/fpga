#include <stdio.h>

// declearation of functions
int fastExpMod(int b, int e, int m);
int extendedGCD(int a, int b);
int selectE(int fn, int halfkeyLength);
int computeD(int fn, int e);
int computeFn(int p, int q);


int main(int argc, char *agrv[]) {
    puts("TEST OF RSA");
    return 0;
}

int computeFn(int p, int q) {
    return (p - 1)*(q - 1);
}

int selectE(int fn, int halfkeyLength) {
    return 65537;
}

int computeD(int fn, int e) {
    int d = 0;
    return d;
}

int fastExpMod(int b, int e, int m) {
    int result = 1;
    while(e != 0) {
        if((e & 1) == 1) {
            result = (result * b) % m;
        }
        e >>= 1;
        b = (b * b) % m;
    }
    return result;
}

int extendedGCD(int a, int b) {
    if(b == 0) {
        return ;
    }
}