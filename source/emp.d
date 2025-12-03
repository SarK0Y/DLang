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
    ulong size;
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
            writeln ("Dear User, file to compress/decode doesn't exist.");
            return;
        }
        if (!exists(Key))
        {
            writeln("Dear User, Key file for compression/decoding doesn't exist.");
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
    ulong cnt = 0;
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