import core.stdc.stdio;
import std.file;
import srd.exception;
import gmp_z;
import std.stdio;
import std.string;
import std.uni;
extern (C) void EMP (
    ref string file_target,
    ref string Key,
    ref string extra_Key,
    int word_order = 1,
    int byte_order = 1
) {
    auto a = new zz (0);
    string* tst = null;
    try {
        if (exists (file_target) ) {
        }
    }
    catch (FileException e ) {
    }


}
