 // gmp_wrapper.d
module gmp_z;

extern (C) {
// GMP integer type
    struct Z
    {
        int _mp_alloc;
        int _mp_size;
        void* _mp_d;
    }
}
// GMP function declarations
extern (C) {
    void mpz_init(Z* integer);
    void mpz_clear(Z* integer);
    void mpz_add(Z* rop, const Z* op1, const Z* op2);
    void mpz_sub(Z* rop, const Z* op1, const Z* op2);
    int mpz_set_str(Z* rop, const char* str, int base);
    int mpz_set(Z* rop, Z* rhs );
    int mpz_cmp(Z* rop, Z* rhs);
    char* mpz_get_str(char* buf, int base, const Z* integer);
    alias _mpn_rshift_(void * rp, const void * sp, size_t n, uint count) = __gmpn_rshift(
        void * rp,
        const void * sp,
        size_t n, uint count);
    uint _mpn_rshift_(void* rp, const void* sp, size_t n, uint count);
}
pragma(lib, "./sorce/libgmp.a114");
// D wrapper class
class GmpInt
{
    private Z _z;

    this()
    {
        mpz_init(&_z);
    }

    ~this()
    {
        mpz_clear(&_z);
    }

    void opAssign(string op)( string str) if (op == "=")
    {
        mpz_set_str( &_z, str.ptr, 10);
        return;
    }
    void opAssign(string op)(GmpInt rhs) if (op == "=")
    {
        mpz_set(&_z, &rhs );
        return;
    }
    void opAssign(string op)(int rhs) if (op == "=")
    {
        mpz_set_iu(&_z, &rhs);
        return;
    }
    void opAssign(string op)(uint rhs) if (op == "=")
    {
        mpz_set_iu(&_z, &rhs);
        return;
    }
    void opAssign(string op)(uint shift) if (op == ">>=")
    {
        _mpn_rshift_ (_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    GmpInt opAdd(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        mpz_add(&result._z, &_z, &rhs._z);
        return result;
    }
    GmpInt opSub(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        mpz_sub(&result._z, &_z, &rhs._z);
        return result;
    }
    bool opEquals(R)(const R other) const
    {
        return mpz_cmp (&_z, &other);
    }
}
unittest
{
    GmpInt a = 2;
    a >>= 1;
    assert(a == 1, true);

}