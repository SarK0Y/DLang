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
    void __gmpz_setbit(Z* rop, ulong rhs);
    void __gmpz_clrbit(Z* rop, ulong rhs);
    bool __gmpz_tstbit(Z* rop, ulong rhs);
    int __gmpz_set_si(Z* rop, int rhs);
    int __gmpz_cmp(Z* rop, Z* rhs);
    int __gmpz_cmp_si(Z* rop, int rhs);
    void __gmpz_pow_ui (Z* rop, Z* rhs, uint shift );
    int __gmpz_realloc2 (Z* rop, uint new_sise);
    size_t __gmpz_sizeinbase (Z* op, int base);
    uint __gmpz_size (Z* rop );
    uint __gmpn_add_n(ulong* rop, ulong* op1, ulong* op2, ulong n);
    uint __gmpn_sub_n(ulong* rop, ulong* op1, ulong* op2, ulong n);
    char* __gmpz_get_str(char* buf, int base, Z* integer);
    int __gmp_printf (const (char* ) format, ...);
    void __gmpz_import(
        Z* rop,
        size_t count, //how many words to read
        int order, // endian of words
        size_t size, // size of word
        int endian, // endian within word
        size_t nails, // skip n most bits of word
        const void * buf 
    );
    void __gmpz_export(
        const void * buf,
        size_t* count, //how many words to read
        int order, // endian of words
        size_t size, // size of word
        int endian, // endian within word
        size_t nails, // skip n most bits of word
        Z* op
    );
    const(char)* __gmp_version;
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
const char [] Init_zz = "
    if (_z._mp_alloc > max_n) {
        max_n = _z._mp_alloc;
    }
    __init_funx;
";
const char[] Init_zz_for_mk = "
    if (_z._mp_alloc > max_n) {
        max_n = ret._z._mp_alloc;
    }
    __init_funx;
";
extern (C) class GmpInt
{
    private {
        Z _z;
        static ulong max_n =0;
        static void function(Z*, Z*, ulong) __add;
        static void function(Z*, Z*, ulong) __sub;
    }
    public {
        alias zz = GmpInt;
        static bool max_speed_ops = false;
        string name;
    } 
    static void _0_max_n () {
        max_n = 0;
    }
    static void __init_funx () {
        if (max_speed_ops) {
            __add = &fast_add;
            __sub = &fast_sub;
        } else {
            __add = &slow_add;
            __sub = &slow_sub;
        }
    }
    this()
    {
        __gmpz_init(&_z);
        mixin (Init_zz);
    }
    this( int x)
    {
        __gmpz_set_ui(&_z, x);
        mixin(Init_zz);
        this.name = "";
    }
    this(return scope GmpInt x)
    {
        __gmpz_init(&_z);
        __gmpz_set(&_z, x.ptr()  );
        mixin(Init_zz);
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
        mixin(Init_zz);
    }
    static zz mk () {
        const void [] __zz = __traits (initSymbol, zz);
        //auto size_zz = __traits (classInstanceSize, GmpInt);
        auto size_zz = __zz.length;
        auto _alloc_zz = malloc (size_zz);
        _alloc_zz[0..size_zz] = cast (void []) __zz[];
        zz ret = cast (zz) _alloc_zz;
        ret.name = "alloc_zz";
        ret.prnt;
        ret.prnt;
        return ret;
    }
    static zz _mk()
    {
        auto ret = new zz(0);
        return ret;
    }
    static zz mk0()
    {
        auto ret = new zz(0);
        return ret;
    }
    size_t msb () {
        ulong msb =  __gmpz_sizeinbase (&_z, 2);
        return msb;
    }
   void _import (void* buf, size_t buf_size)
    {
        printf ("entry _import\n");
        printf ("buf size for _import: %lld\n", buf_size);
        __gmpz_import(
            &_z,
            buf_size,
            BIG_WORD_1ST,
            1,
            BIG_BYTE_1ST,
            0,
            buf
        );
        if (buf_size > max_n) {
            max_n = buf_size / buf_size.sizeof;
        }
        printf("alloc for _import: %lld _size: %lld max_n %lld\n", _z._mp_alloc, __gmpz_size(&_z), max_n);
    }
    void* _export()
    {
        printf("entry _export\n");
        debug {printf ("entry _export\n");}
        size_t buf_size;
        auto _buf_size = this.len;
        auto buf = malloc (_buf_size);
        __gmpz_export(
            buf,
            &buf_size,
            BIG_WORD_1ST,
            1,
            BIG_BYTE_1ST,
            0,
            this.ptr
        );
        debug
        {
            printf("buf size for export: %lld\n", buf_size);
        }
        return buf;
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
        Z* ret = &_z;
        return ret;
    }
    void GMP_ver () {
        printf ("GMP ver: %s", __gmp_version );
    }
    GmpInt dup () {
        return new GmpInt ( this );
    }
    void set (zz* rhs) {
        __gmpz_set (this.ptr, rhs.ptr);
    }
    void set(int rhs)
    {
        printf ("set(int rhs)\n");
        __gmpz_set_si(this.ptr, rhs);
    }
    void set(uint rhs)
    {
        __gmpz_set_ui(this.ptr, rhs);
    }
    bool tstbit (ulong x) {
        return __gmpz_tstbit (&_z, x);
    }
    void setbit(ulong x)
    {

       __setbit (&_z, x);
    }
    void clrbit(ulong x)
    {
        __gmpz_clrbit(&_z, x);
        return;
    }
    void opAssign( string str)
    {
        writeln ("void opAssign(string op)( string str) if (op ==  = )");
        __gmpz_set_str( this.ptr, str.ptr, 10);
        return;
    }
    void opAssign(string op)(zz rhs)
    {
        writeln("void opAssign(string op)(GmpInt rhs) if (op == \" = \")");
        __gmpz_set(&_z, &rhs );
        return;
    }
    void opAssign(uint rhs)
    {   
        writeln ("void opAssign(uint rhs) if (op == \" = \")");
        __gmpz_init (&_z);
        __gmpz_set_ui(&_z, rhs);
    }
    GmpInt opAssign(int rhs)
    {
        writeln("void opAssign(string op)(int rhs) if (op == \" = \")");
        __gmpz_init (&_z);
        __gmpz_set_ui(&_z, rhs);
        return this;
    }
    static GmpInt opCall(int rhs)    {
        writeln("static gmp opcall(string op)(int rhs) if (op == \" = \")");
        
        return new GmpInt ( rhs );
    }
    void opAssign(string op)(uint rhs)
    {
        writeln("void opAssign(string op)(uint rhs) if (op == \" = \")");
        __gmpz_set_ui(&_z, rhs);
        return;
    }
    void opAssign(string op)(uint shift) if (op == ">>=")
    {
        if (this == 1) {
            
        }
        __gmpn_rshift (_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    void opOpAssign(string op)(uint shift) if (op == ">>")
    {
       // writeln(">>");
        __gmpn_rshift(_z._mp_d, _z._mp_d, _z._mp_size, shift);
    }
    void opOpAssign(string op: "+")(zz y) {
        __add (&_z, y.ptr, max_n);
    }
    void opOpAssign(string op : "-")(zz y)
    {
        __sub(&_z, y.ptr, max_n);
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
    uint len () {
        return __gmpz_size (&_z) * 8;
    }
    void prnt () {
        __gmp_printf ("Val: %Zd\n name: %s\nlen: %d\nmsb: %lld", this.ptr, name.ptr, this.len, this.msb );
    }
    zz opBinary(string op)(uint shift) if (op == "<<")
    {
        auto res = this.dup;
        auto ptr = this.ptr;
        __gmpn_lshift(ptr._mp_d, ptr._mp_d, ptr._mp_size, shift);
        return res;
    }
    zz opBinary(string op)(uint shift) if (op == ">>")
    {
        auto res = this.dup;
        auto ptr = res.ptr;
        __gmpn_rshift(ptr._mp_d, ptr._mp_d, ptr._mp_size, shift);
        return res;
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
    int opBinary(string op : "_>")(zz x) // useless
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(this.ptr, x.ptr) == 1;
    }
    bool opBinary(string op : "_<")(zz x) // useless
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(this.ptr, x.ptr) == -1;
    }
    bool opEquals(Z* x)
    {
        // auto g = new GmpInt(x);
        return __gmpz_cmp(&_z, x ) == 0;
    }
    bool opEquals(zz* x)
    {
        return __gmpz_cmp(&_z, x.ptr) == 0;
    }
    int opCmp(Z* x)
    {
        return __gmpz_cmp(&_z, x);
    }
    int opCmp(GmpInt* x)
    {
        return __gmpz_cmp(&_z, x.ptr);
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
import std.datetime;
import std.format;
extern (C) void simply_print_time (string s) {
    auto currentTime = Clock.currTime();
    auto dt = cast(DateTime) currentTime;

    // Control fractional precision
    enum precision = 6; // Number of fractional digits (microseconds)

    //double fractional = cast (double)currentTime.hnsecs / 10_000_000.0;
    //string fractionalStr = format("%.*f", precision, fractional);

    auto customTime = format("%04d-%02d-%02d %02d:%02d:%02d.",
        dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second); // dt.nsecs);

    writefln("%s: %s", s, customTime);
}
extern (C) void __setbit (Z* __z, ulong x) {
    __gmpz_setbit(__z, x);
    return;
}
extern (C) void slow_add (Z* rop, Z*op1, ulong n) {
    __gmpz_add(rop, rop, op1);
}
extern (C) void fast_add(Z* rop, Z* op1, ulong n) 
{
    __gmpn_add_n(cast (ulong*) rop._mp_d, cast(ulong*) rop._mp_d, cast(ulong*) op1._mp_d, n);
}
extern (C) void slow_sub(Z* rop, Z* op1, ulong n)
{
    __gmpz_sub(rop, rop, op1);
}

extern (C) void fast_sub(Z* rop, Z* op1, ulong n)
{
    __gmpn_sub_n(cast(ulong*) rop._mp_d, cast(ulong*) rop._mp_d, cast(ulong*) op1._mp_d, n);
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
    zz tst_arr_2_mpz = new zz ();
    uint size = 3_000_000;
    auto more_bytes = malloc(size);
    byte* ch = cast(byte*) more_bytes;
    //ch[0] = 1;
    /*for (uint i = 0; i < size; i++) {
        ch[i] = cast(byte)255;
    }*/
    ch[6] = cast(byte)255;
    //e <<= 10_000_000;
   writeln ("\n==================\n");
    if (more_bytes != null)
    {
        writefln("done alloc arr");
        tst_arr_2_mpz._import(more_bytes, size);
       // tst_arr_2_mpz.ptr._mp_alloc = size;
        //tst_arr_2_mpz.ptr._mp_d = more_bytes;
        writefln("done realloc mpz");
    }
    free (more_bytes);
   // tst_arr_2_mpz = 1.zz;
    //tst_arr_2_mpz <<= 7_0_000;
    writefln("tst_arr_2_mpz size %d", tst_arr_2_mpz.ptr._mp_size);
   // tst_arr_2_mpz.prnt;
    Z* _z = tst_arr_2_mpz.ptr;
    /*simply_print_time ("Start");
    auto dt = tst_arr_2_mpz.dup;
    auto _dt = dt.ptr;
    for (int i = 0; i < 1_000_000; i++) {
       // __gmpz_add (_z, _z, _dt);
        tst_arr_2_mpz += dt;
        dt >>= 1;
      // __gmpn_rshift(_dt._mp_d, _dt._mp_d, _dt._mp_size, 1);
    }
    simply_print_time ("End");
    writefln ("tst_arr_2_mpz alloc %d", tst_arr_2_mpz.ptr._mp_alloc);*/
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
    assert(_1 < _2.ptr);
    assert(_3 > &_2);
    assert(_3 == &_3);
    assert(_3 == _3);
    assert(a == 4);
    assert(a != b);
    assert(c == b);
    assert(d == 101);
}