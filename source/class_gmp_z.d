 // gmp_wrapper.d
module gmp_z;

extern (C) {
// GMP integer type
    struct Mpz
    {
        int _mp_alloc;
        int _mp_size;
        void* _mp_d;
    }
}
// GMP function declarations
pragma(lib, "libgmp.a");
extern (C) {
    void mpz_init(Mpz * integer);
    void mpz_clear(Mpz* integer);
    void mpz_add(Mpz* rop, const Mpz* op1, const Mpz* op2);
    int mpz_set_str(Mpz* rop, const char* str, int base);
    char* mpz_get_str(char* buf, int base, const Mpz* integer);
}

// D wrapper class
class GmpInt
{
    private Mpz _z;

    this()
    {
        mpz_init(&_z);
    }

    ~this()
    {
        mpz_clear(&_z);
    }

    void opAssign( ref string str)
    {
        mpz_set_str( &_z, str.ptr, 10);
        return;
    }

    GmpInt opAdd(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        mpz_add(&result._z, &_z, &rhs._z);
        return result;
    }
}