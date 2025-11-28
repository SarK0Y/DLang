 // gmp_wrapper.d
module gmp_z;
import std.stdio;
import core.stdc.stdlib : malloc, free;
const int BIG_WORD_1ST = 1;
const int LEAST_WORD_1ST = -1;
const int HOST_ENDIAN = 0;
const int BIG_BYTE_1ST = 1;
const int LEAST_BYTE_1ST = -1;
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
//    import std.c.stdlib;
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
    void __gmpz_pow_ui (Z* rop, Z* rhs, uint shift );
    int __gmpz_realloc2 (Z* rop, uint new_sise);
    uint __gmpz_size (Z* rop );
    char* __gmpz_get_str(char* buf, int base, Z* integer);
    void __gmp_init ();
    void __gmp_printf (const (char* ) format, ...);
    void __gmpz_import(
        Z* rop,
        size_t count, //how many words to read
        int order, // endian of words
        size_t size, // size of word
        int endian, // endian within word
        size_t nails, // skip n most bits of word
        const void * buf 
    );
    immutable (char*) __gmp_version;
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
    this (void* buf, size_t buf_size) {
        __gmpz_init(&_z);
        __gmpz_import (
            &_z,
            (buf_size / 8) + 1,
            LEAST_WORD_1ST,
            1,
            LEAST_BYTE_1ST,
            0,
            buf
        );
    }
   void _import (void* buf, ulong buf_size)
    {
        ulong count = (buf_size/ 8) + 1;
        __gmpz_import(
            &_z,
            count,
            LEAST_WORD_1ST,
            1,
            LEAST_BYTE_1ST,
            0,
            buf
        );
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
    void GMP_ver () {
        //__gmp_init ();
        __gmp_printf ("GMP ver: %s", __gmp_version );
    }
    GmpInt dup () {
        return new GmpInt ( this );
    }
    void opAssign(string op)( string str) if (op == "=")
    {
        writeln ("void opAssign(string op)( string str) if (op ==  = )");
        __gmpz_set_str( this.ptr, str.ptr, 10);
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
    void opOpAssign(string op: "+")(zz y) {
        __gmpz_add (&_z, &_z, y.ptr);
    }
    void opOpAssign(string op)(uint shift) if (op == "<<")
    {
        writeln ("<<=");
        uint size = (shift / 8) + 1;
        auto old_size = __gmpz_size (this.ptr);
        writefln("<<=, old soze: %d", old_size);
        if (old_size >= size) {
            __gmpn_lshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
            return;
        }
        //__gmpz_realloc2( & _z, size);
        auto more_bytes = malloc (size);
        if (more_bytes == null )  {
            writefln ("no space to realloc mpz" );
            return;
        }
       /* byte* ch = cast (byte*)more_bytes;
        ch[0] = 1; */
        this._import (more_bytes, size); 
       // __gmpz_pow_ui (&_z, &_z, shift);
      writefln("<<=: last, size: %d, old size: %d", size, old_size);
       __gmpn_lshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
       writeln ("End lshift");
    }
    void prnt () {
        __gmp_printf ("GmpInt: %Zd %p", this.ptr, this.ptr );
    }
    void opBinary(string op)(uint shift) if (op == "<<")
    {
        __gmpn_lshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    GmpInt opBinary(string op: "+")(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        __gmpz_add(result.ptr, this.ptr, rhs.ptr);
        return result;
    }
    GmpInt opBinary(string op : "-")(GmpInt rhs)
    {
        GmpInt result = new GmpInt();
        __gmpz_sub(result.ptr, this.ptr, rhs.ptr);
        return result;
    }
    bool opEquals(int x )
    {
       // auto g = new GmpInt(x);
        return __gmpz_cmp_si (this.ptr, x ) == 0;
    }
    bool opBinary(string op: "==")(zz x)
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(this.ptr, x.ptr) == 0;
    }
    bool opEquals(Z* x)
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(&_z, x ) == 0;
    }
    char* strn () {
        auto buf = new char [_z._mp_alloc];
        __gmpz_get_str (&buf[0], 10, this.ptr );
        return  &buf[0];
    }
}
alias zz = GmpInt;
mixin template gmp_zz () {
    
}

unittest
{
    
    auto a = new GmpInt(9);
    a.prnt;
    auto b = a.dup;
    //auto c = GmpInt (101);
    auto c = b;
    auto d = 101.zz;
    d.prnt;
    a >>= 1;
    auto e = 101.zz;
   // e <<= 1_000; 
  //  __gmpz_pow_ui (e.ptr, e.ptr, 0);
   // writefln("size of e %d\nAlloc: %d\nval: %s", e.ptr._mp_size, e.ptr._mp_alloc, e.strn);
    __gmp_printf("print Z: %Zd %s", &a._z, e.strn );
    e.prnt;
    e.GMP_ver;
    
    ulong cnt = 0;
    while ( cnt < 50_555_001 ) {
        cnt ++;
    }
    zz tst_arr_2_mpz;
    uint size = 800_000_000;
    auto more_bytes = malloc(size);
    byte* ch = cast(byte*) more_bytes;
    //ch[0] = 1;
    for (uint i = 0; i < size; i++) {
        ch[i] = cast(byte)255;
    }
    //e <<= 10_000_000;
   writeln ("\n==================\n");
    if (more_bytes != null)
    {
        tst_arr_2_mpz._import(more_bytes, size );
        writefln("done realloc mpz");
    }
    tst_arr_2_mpz = 1.zz;
    tst_arr_2_mpz <<= 7_0_000;
    writefln("tst_arr_2_mpz size %d", tst_arr_2_mpz.ptr._mp_size);
    for (int i = 0; i < 1_000_000; i++) {
        tst_arr_2_mpz += tst_arr_2_mpz;
    }
    tst_arr_2_mpz.prnt;
    writefln ("tst_arr_2_mpz alloc %d", tst_arr_2_mpz.ptr._mp_alloc);
    auto _1 = new zz (1);
    auto _2 = new zz (2);
    auto res = _1+_2;
    auto _3 = new zz (3);
    auto cmp = (res == _3.ptr);
    res.prnt;
    writefln ("_1 + _2 == _3 = %d", cmp);
    auto sub = _3 - _1;
    sub.prnt;
    auto sub_op = ( sub == _2);
    assert(cmp == true);
    //assert(sub_op == true);
    assert(a == 4);
    assert(a != b);
    assert(c == b);
    assert(d == 101);
}