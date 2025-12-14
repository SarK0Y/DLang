module helpful;
import core.stdc.stdio;
import core.memory;
import std.algorithm;
import std.file;
import std.exception;
import gmp_z;
import std.stdio;
import std.string;
import std.uni;
import std.stdint;
import std.conv;
extern (C) immutable (char)* padding (uint16_t width, const char* str ) {
    string s = "";
    string append = to!string(str); 
    for (ushort x = 0; x < width; x++) {
        s ~= append;
    }
    s ~= '\0';
    return s.ptr;
}