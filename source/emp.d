import core.stdc.stdio;
import core.memory;
import std.file;
import std.exception;
import gmp_z;
import std.stdio;
import std.string;
import std.uni;
extern (C) struct ret_emp {
    zz* dat;
    size_t size;
    static ret_emp mk () {
        ret_emp re = ret_emp (null, 0);
        return re;        
    }
}
ret_emp* save_for_unitst (ret_emp x) {
    static ret_emp sav = ret_emp.mk();
    if (x.dat != null) {
        sav = x;
    } return &sav;
}
extern (C) void EMP_default(
    string file_target = "/tst/out.29.ՇࢥਫѼߑۙ.mp3",
    string Key = "/tst/out.30.ନŗةȎЩʄ.mp3",
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
    ); return;
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
        target = File (file_target, "r");
        key = File (Key, "r");
        scope (exit) {
            target.close;
            key.close;
        }
        fout = File (file_out, "w+");
        void [] target_arr =read(file_target);
        void [] key_arr = read (Key);
        printf ("len: %lld, size: %lld", target_arr.length, target.size);
        debug { import core.stdc.stdio : printf; printf("check read files\n"); }
        zz target_zz = new zz (0), key_zz = zz.mk0;
        target_zz._import (target_arr.ptr, target_arr.length);
        debug { import core.stdc.stdio : printf; printf("check target_zz\n"); }
        key_zz._import (key_arr.ptr, key_arr.length);
        debug { import core.stdc.stdio : printf; printf("check _import\n"); }
        auto map = __emp (&target_zz, &key_zz);
        debug { import core.stdc.stdio : printf; printf("check map\n"); }
        auto dat = map.dat._export ();
        if (dat == null) {
            writeln ("Failed to gen map ", __FILE_FULL_PATH__, __LINE__);
            return;
        }
        save_for_unitst(map);
    }
    catch (FileException e ) {
        writeln ("Failed to prepare files.", e.msg);
    }
}
ret_emp __emp (zz* target, zz* key) {
    auto dt = key.dup >> 1;
    zz* map = zz.mk();
    printf ("check map in __emp\n");
    size_t cnt = 0;
    if (*key == *target) {
        printf ("key == target, abort __emp(..)");
        goto end;
    }
    printf ("start while-loop\n");
    while (!(*key == target)) {
        if (*key > target) {
            *key -= dt;
            map.setbit (cnt);
            printf ("cnt: %lld\n", cnt);
        } else {
            printf ("no cnt\n");
            *key += dt;
        }
        dt >>= 1;
        cnt++;
    }
    //GC.free (dt); // for void*
end:
    dt.destroy;
    return ret_emp (map, cnt);
}
void __tstdecode_emp (ret_emp* take_emp, string key_file, string orig, string decoded ) {
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
    try {
        auto key = File(key_file, "rb");
        key.close ();
        auto key1 = File(orig, "rb");
        key1.close();
    } catch (FileException e) {
        writefln("Dear User, i been failed to open \n%s. \n%s %s", e.msg, __FILE_FULL_PATH__, __LINE__);
    }
    void [] key_arr = read (key_file);
    auto key = new zz (key_arr.ptr, key_arr.length);
    key_arr.destroy;
    void[] _orig = read(orig);
    auto __orig = new zz(_orig.ptr,_orig.length);
    _orig.destroy;
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
    if (__orig != key) {
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
    const char [] tst_mixin = "tst mixin";
    mixin Msg!(tst_mixin);
   // write (out0);
  mixin (out0);
  string tst_msg = "tst msg";
  msg_verbose (tst_msg);
  EMP_default;
}