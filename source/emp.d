import core.stdc.stdio;
import core.memory;
import std.algorithm;
import std.math;
import std.file: 
    write, read, exists, FileException, remove;
import std.exception;
import gmp_z;
import helpful;
import std.stdio;
import std.string;
import std.uni;
import std.conv;
extern (C) struct ret_emp {
    zz dat;
    size_t size;
    static ret_emp mk () {
        ret_emp re = ret_emp (null, 0);
        return re;        
    }
}
ret_emp save_for_unitst (ret_emp* x) {
    static ret_emp sav = ret_emp.mk();
    if (x is null) return sav;
    if (sav.dat is null || (*x).dat != sav.dat.ptr) {
        sav = *x;
    } return sav;
}
extern (C) void EMP_default(
    string file_target = "/tst/algo 30.png",
    string Key = "/tst/algo19.png",
    string extra_Key = "",
    string file_out = "/tst/out.emp",
    int word_order = 1,
    int byte_order = 1
) {
    string file_target0 = file_target.dup;
    EMP (
        file_target0,
        Key,
        extra_Key,
        file_out,
        word_order,
        byte_order
    );
    __tstdecode_emp (
        save_for_unitst (cast(ret_emp*)null ),
        Key,
        file_target0,
        ""
    ); 
    return;
}
extern (C) void EMP (
    ref string file_target,
    ref string Key,
    ref string extra_Key,
    ref string file_out,
    int word_order = 1,
    int byte_order = 1
) {
    auto a = new zz (0);
    string* tst = null;
    File target, key, fout;
    try {
        if (!exists (file_target) ) {
            writeln ("Dear User, file to compress/encode doesn't exist.");
            return;
        }
        if (!exists(Key))
        {
            writeln("Dear User, Key file for compression/encoding doesn't exist.");
            return;
        }
        try {
            remove (file_out);
        } catch (FileException e) {}
        target = File (file_target, "r");
        key = File (Key, "r");
        scope (exit) {
            target.close;
            key.close;
        }
        fout = File (file_out, "w+");
        void [] target_arr =read(file_target);
        void [] key_arr = read (Key);
        ushort w =15;
        auto pad = padding(w, cast(char * ) "@".ptr);
        printf ("check pad %s\n", pad);
        printf ("len: %lld, size: |%s%lld|", target_arr.length, pad, target.size);
        debug { import core.stdc.stdio : printf; printf("check read files\n"); }
        zz target_zz = new zz (0), key_zz = zz.mk0;
        target_zz.max_speed_ops = true;
        key_zz.max_speed_ops = true;
        zz._0_max_n;
        size_t max_size_for_num = max (target_arr.length, key_arr.length) + 1;
        target_zz._import (target_arr.ptr, max_size_for_num);
        debug { import core.stdc.stdio : printf; printf("check target_zz\n"); }
        key_zz._import (key_arr.ptr, max_size_for_num);
        debug { import core.stdc.stdio : printf; printf("check _import\n"); }
        auto map = __emp (target_zz, key_zz);
        debug { import core.stdc.stdio : printf; printf("check map pointer %p\n", map.dat); }
        void* dat = map.dat._export ();
        debug
        {
            import core.stdc.stdio : printf;

            printf("check export\n");
        }
        if (dat == null) {
            writeln ("Failed to gen map ", __FILE_FULL_PATH__, __LINE__);
            return;
        }
        save_for_unitst(&map);
        map.dat.name = "tst dat";
        map.dat.prnt_no_val;
        double dat_len = map.dat.msb / 8;
        printf ("dat len %f", dat_len);
        size_t _dat_len;
        if (dat_len > floor (dat_len) ) {
            _dat_len = cast(size_t)floor(dat_len) + 1;
        } else {
            _dat_len = cast(size_t) dat_len;
        }
        write (file_out, dat[0.._dat_len]);
        ulong [] size_map = [map.size];
        auto append = File (file_out, "a");
        append.write (file_out, size_map);
    }
    catch (FileException e ) {
        writeln ("Failed to prepare files.", e.msg);
    }
}
extern (C) ret_emp __emp (zz target, zz key) {
    auto dt = key.dup >> 1;
    zz map = zz._mk;
    printf ("check map in __emp pointer: %p\n", map);
    ulong cnt = 0;
    if (key == target) {
        printf ("key == target, abort __emp(..)");
        goto end;
    }
    if (key != target) {
        printf ("key != target\n");
    }
    assert(key != target.ptr);
    printf("start while-loop\n");
    while (0==0) {
        printf ("tst while loop");
        break;
    }
    map.name = "name1";
    //map.set (0);
    map = 0;
    map.prnt;
    simply_print_time ("start tst for __emp");
    for (;;) {
        if (key > target.ptr) {
            key -= dt;
            map.setbit (cnt);
       //     printf ("cnt: %lld\n", cnt);
        } else {
      //      printf ("no cnt\n");
            key += dt;
        }
        if (dt.msb == 0 || key == target.ptr ) { break; }
       // printf ("dt.msb == %lld, map.msb %lld, %s\n", dt.msb, map.msb, map.name.ptr);
        dt >>= 1;
        cnt++;
    }
    simply_print_time("end tst for __emp");
    //GC.free (dt); // for void*
end:
    assert(key == target.ptr);
    prnt ("check assert\n");
    map.name = "name";
    prnt("check assert\n");
    map.prnt_no_val;
    dt.destroy;
    printf ("cnt %lld", cnt);
    return ret_emp (map, cnt);
}
void __tstdecode_emp (ret_emp take_emp, string key_file, string orig, string decoded ) {
    if (!exists(key_file))
    {
        writefln("Dear User, file to decompress/decode doesn't exist. %s %s", __FILE_FULL_PATH__, __LINE__);
        return;
    }
    if (!exists(orig))
    {
        writefln("Dear User, orig file doesn't exist. %s %s", __FILE_FULL_PATH__, __LINE__);
        return;
    }
    void [] key_arr, orig_arr;
    try {
        auto key = File(key_file, "r");
        auto _key_arr = new void [key.size];
        key.rawRead (_key_arr);
        key_arr = _key_arr;
        key.close ();
        auto orig_file = File(orig, "r");
        auto _orig_arr = new void[orig_file.size];
        orig_file.rawRead(_orig_arr);
        orig_arr = _orig_arr;
        orig_file.close();
    } catch (FileException e) {
        writefln("Dear User, i been failed to open \n%s. \n%s %s", e.msg, __FILE_FULL_PATH__, __LINE__);
    }
    auto key = new zz (key_arr.ptr, key_arr.length);
    key_arr.destroy;
    auto _orig = new zz(orig_arr.ptr, orig_arr.length);
    size_t msb = take_emp.dat.msb;
    size_t cnt = 0;
    auto dat = take_emp.dat;
    size_t number_of_all_steps = take_emp.size;
    auto dt = key.dup >> 1;
    for (; cnt < msb; cnt++) {
        if ( dat.tstbit (cnt) ) {
            key -= dt;
        } else {
            key += dt;
        } dt >>= 1;
    }
    if (number_of_all_steps > msb) {number_of_all_steps -= msb; }
    for (; number_of_all_steps > 0; number_of_all_steps-- ){
        key += dt;
        dt >>= 1;
    }
    if (_orig != key) {
        mixin Msg! ("Failed to reproduce orig file");
        mixin (out0);
    }
}
pragma (inline, true );
 void msg_verbose (string msg) {
    writefln ("Msg: %s\nSource: %s\nLine: %s", msg, __FILE_FULL_PATH__, __LINE__);
}
void prnt (string g) {
    writeln (g.ptr,"\n");
}
string _Msg( string msg)
{
    string out0 = "writefln(\"%s \n%s. \n%s %s\","~msg~", __FILE_FULL_PATH__, __LINE__);";
    prnt (out0);
    return out0;
}
template Msg(const char [] msg )
{
   //string x = _Msg (msg);
   const char [] out0 = "writefln(\"Msg: %s\nSource %s\nLine: %s\"," ~"\""~ msg ~"\""~", __FILE_FULL_PATH__, __LINE__);";
}
unittest
{
    writeln ("\n\ntst mod emp.d\n");
    auto try_0 = zz.mk;
    assert (try_0 == 0);
    const char [] tst_mixin = "tst mixin";
    mixin Msg!(tst_mixin);
    auto _0 = new zz (3);
    _0.name = "_0";
    auto __0 = _0.dup;
    assert(__0 == 3);
    __0.name = "__0";
    __0.prnt;
    auto i0 = 3;
    __0 = i0;
    __0 = "5";
    _0 = 5;
   /* __0 >>= 40;
    _0 >>= 24;
    __0.prnt;
    assert(_0.msb == 0);
    assert(_0 == &__0);
    _0.prnt; */
   // write (out0);
  mixin (out0);
  string tst_msg = "tst msg";
  msg_verbose (tst_msg);
  EMP_default;
}