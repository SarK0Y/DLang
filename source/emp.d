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
        target = File (file_target, "rb");
        key = File (Key, "rb");
        fout = File (file_out, "w+");
        void [] target_arr =read(file_target);
        void [] key_arr = read (Key);
        zz target_zz, key_zz;
        target_zz._import (cast(void*)target_arr, target.size);
        key_zz._import (cast (void*)key_arr, key.size);
        auto map = __emp (&target_zz, &key_zz);
        auto dat = map.dat._export ();
        save_for_unitst (map);
        if (dat == null) {
            writeln ("Failed to gen map ", __FILE_FULL_PATH__, __LINE__);
            return;
        }
    }
    catch (FileException e ) {
        writeln ("Failed to prepare files.", e.msg);
    }


}
ret_emp __emp (zz* target, zz* key) {
    auto dt = key.dup >> 1;
    zz* map = zz.mk();
    size_t cnt = 0;
    while (*key != target) {
        if (*key > target) {
            *key -= dt;
            map.setbit (cnt);
        } else {
            *key += dt;
        }
        dt >>= 1;
        cnt++;
    }
    //GC.free (dt); // for void*
    dt.destroy;
    return ret_emp (map, cnt);
}
void __tstdecode_emp (ret_emp* take_emp, string key_file, string orig, string decoded ) {
    if (!exists(key_file))
    {
        writefln("Dear User, file to decompress/decode doesn't exist. %s %s", __FILE_FULL_PATH__, __LINE__);
        return;
    }
    try {
        auto key = File(key_file, "rb");
        key.close ();
    } catch (FileException e) {
        writefln("Dear User, i been failed to open \n%s. \n%s %s", e.msg, __FILE_FULL_PATH__, __LINE__);
    }
    void [] key_arr = read (key_file);
    auto key = new zz (key_arr.ptr, key_arr.length);
    key_arr.destroy;
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
   const char [] out0 = "writefln(\"%s %s %s\"," ~"\""~ msg ~"\""~", __FILE_FULL_PATH__, __LINE__);";
}
unittest
{
    writeln ("\n\ntst mod emp.d\n");
    mixin Msg!("tst mixin");
   // write (out0);
  mixin (out0);
  string tst_msg = "tst msg";
  msg_verbose (tst_msg);
}