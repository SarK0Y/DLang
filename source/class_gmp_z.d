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
    void __gmpz_init(Z* integer);
    void __gmpz_clear(Z* integer);
    void __gmpz_add(Z* rop, const Z* op1, const Z* op2);
    void __gmpz_sub(Z* rop, const Z* op1, const Z* op2);
    int __gmpz_set_str(Z* rop, const char* str, int base);
    int __gmpz_set(Z* rop, Z* rhs );
    int __gmpz_set_ui(Z* rop, int rhs);
    int __gmpz_cmp(Z* rop, Z* rhs);
    char* __gmpz_get_str(char* buf, int base, const Z* integer);
    //alias  void _mpn_rshift_(void * rp, const void * sp, size_t n, uint count) = 
    void __gmpn_rshift(
        void * rp,
        const void * sp,
        size_t n, uint count);
    //uint _mpn_rshift_(void* rp, const void* sp, size_t n, uint count);
}
pragma(lib, "gmp0");
// D wrapper class
class GmpInt
{
    private Z _z;

    this()
    {
        __gmpz_init(&_z);
    }
    this(return scope int x)
    {
        __gmpz_set_ui(&_z, x);
    }
    ~this()
    {
        __gmpz_clear(&_z);
    }

    void opAssign(string op)( string str) if (op == "=")
    {
        writeln ("void opAssign(string op)( string str) if (op ==  = )");
        __gmpz_set_str( &_z, str.ptr, 10);
        return;
    }
    void opAssign(string op)(GmpInt rhs) if (op == "=")
    {
        writeln("void opAssign(string op)(GmpInt rhs) if (op == \" = \")");
        __gmpz_set(&_z, &rhs );
        return;
    }
    void opAssign(string op)(int rhs) if (op == "=")
    {   
        writeln ("void opAssign(string op)(int rhs) if (op == \" = \")");
        __gmpz_set_ui(&_z, rhs);
        return;
    }
    void opAssign(string op)(uint rhs) if (op == "=")
    {
        writeln("void opAssign(string op)(uint rhs) if (op == \" = \")");
        __gmpz_set_ui(&_z, rhs);
        return;
    }
    void opAssign(string op)(uint shift) if (op == ">>=")
    {
        __gmpn_rshift (_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    void opOpAssign(string op)(uint shift) if (op == ">>")
    {
        __gmpn_rshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    GmpInt opAdd(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        __gmpz_add(&result._z, &_z, &rhs._z);
        return result;
    }
    GmpInt opSub(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        __gmpz_sub(&result._z, &_z, &rhs._z);
        return result;
    }
    bool opEquals(R)(const R other) const
    {
        return __gmpz_cmp (&_z, &other);
    }
}
unittest
{
    auto a = new GmpInt(2);
    a >>= 1;
    assert(a == 1, true);

}