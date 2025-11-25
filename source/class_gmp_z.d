 // gmp_wrapper.d
module gmp_z;
import std.stdio;
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
    int __gmpz_set_ui(Z* rop, uint rhs);
    int __gmpz_set_si(Z* rop, int rhs);
    int __gmpz_cmp(Z* rop, Z* rhs);
    int __gmpz_cmp_si(Z* rop, int rhs);
    char* __gmpz_get_str(char* buf, int base, const Z* integer);
    //alias  void _mpn_rshift_(void * rp, const void * sp, size_t n, uint count) = 
    void __gmpn_rshift(
        void * rp,
        const void * sp,
        size_t n, uint count);
    void __gmpn_lshift(
        void* rp,
        const void* sp,
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
    this(return scope GmpInt x)
    {
        __gmpz_init(&_z);
        __gmpz_set(&_z, x.ptr()  );
    }
    ~this()
    {
        __gmpz_clear(&_z);
    }
    Z val () {
        return _z;
    }
    Z* ptr()
    {
        return &_z;
    }
    GmpInt dup () {
        return new GmpInt ( this );
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
        //__gmpz_init (&_z);
        __gmpz_set_ui(&_z, rhs);
    }
    GmpInt opAssign(string op)(int rhs) if (op == "=")
    {
        writeln("void opAssign(string op)(int rhs) if (op == \" = \")");
        //__gmpz_init (&_z);
        __gmpz_set_ui(&_z, rhs);
        return this;
    }
    static GmpInt opCall(int rhs)    {
        writeln("static gmp opcall(string op)(int rhs) if (op == \" = \")");
        
        return new GmpInt ( rhs );
    }
    void opAssign(string op)(uint rhs) if (op == "=")
    {
        writeln("void opAssign(string op)(uint rhs) if (op == \" = \")");
        __gmpz_set_ui(&_z, rhs);
        return;
    }
    void opAssign(string op)(uint shift) if (op == ">>=")
    {
        writeln(">>=");
        __gmpn_rshift (_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    void opOpAssign(string op)(uint shift) if (op == ">>")
    {
        writeln(">>");
        __gmpn_rshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    void opOpAssign(string op)(uint shift) if (op == "<<")
    {
        writeln ("<<=");
        __gmpn_lshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }

    void opBinary(string op)(uint shift) if (op == "<<")
    {
        __gmpn_lshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
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
    bool opEquals(int x )
    {
       // auto g = new GmpInt(x);
        return __gmpz_cmp_si (&_z, x ) == 0;
    }
    bool opEquals(Z* x)
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(&_z, x ) == 0;
    }
}
alias zz = GmpInt;
mixin template gmp_zz () {
    
}

unittest
{
    
    auto a = new GmpInt(9);
    auto b = a.dup;
    //auto c = GmpInt (101);
    auto c = b;
    auto d = 101.zz;
    a >>= 1;
    auto e = 1.zz;
    e <<= 100;//_000_000; 
    assert(a == 4);
    assert(a != b);
    assert(c == b);
    assert(d == 101);
    writeln ("size of e ", e._z._mp_size);

}