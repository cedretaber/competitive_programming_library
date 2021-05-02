void read(TS...)(ref TS vars)
{
    import std.traits : isArray;

    static if (vars.length == 1) {
        static if (isArray!(TS[0])) {
            vars[0] = readln.split.to!(TS[0]);
        } else {
            vars[0] = readln.chomp.to!(TS[0]);
        }
    } else {
        auto line = readln.split;
        static foreach (i, T; TS) {
            vars[i] = line[i].to!T;
        }
    }
}

void read_lines(TS...)(size_t n, ref TS arrs)
{
    import std.traits : isArray;
    import std.typecons : isTuple;
    import std.range.primitives : ElementType;

    static foreach (T; TS) static assert(isArray!T, "read_lines requires arrays as it's arguments.");

    static foreach (arr; arrs) {
        if (arr.length < n) arr.length = n;
    }
    foreach (i; 0..n) {
        static if (arrs.length == 1) {
            alias E = ElementType!(TS[0]);
            static if (isTuple!E) {
                 auto line = readln.split;
                 E t;
                 static foreach (j, T; E.Types) {
                     t[j] = line[j].to!T;
                 }
                 arrs[0][i] = t;
            } else static if (isArray!E) {
                arrs[0][i] = readln.split.to!E;
            } else {
                arrs[0][i] = readln.chomp.to!E;
            }
        } else {
            auto line = readln.split;
            static foreach (j, T; TS) {
                arrs[j][i] = line[j].to!(ElementType!T);
            }
        }
    }
}