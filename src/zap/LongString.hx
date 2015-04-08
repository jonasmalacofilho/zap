package zap;

using StringTools;

abstract LongString(String) to String {
    inline function new(s)
    {
        this = s;
    }

    @:from public static inline function longString(s:String)
    {
        // convert tabs to 8 spaces
        s = s.replace("\t", "".rpad(" ", 8));

        var lines = s.split("\n");

        // find the minimum indent
        var minIndent = -1;
        for (li in lines.slice(1)) {  // ignore indent on the first line
            if (li.length == 0)
                continue;
            var tr = li.ltrim();
            var indent = li.length - tr.length;
            if (minIndent == -1 || indent < minIndent)
                minIndent = indent;
        }
        if (minIndent == -1)
            minIndent = 0;
        
        // trim indent (first line is special)
        lines[0] = lines[0].ltrim();
        var trimmed = [for (li in lines) li.substr(minIndent)];

        // remove leading or trailing blank lines
        while (trimmed[0].length == 0)
            trimmed.shift();
        while (trimmed[trimmed.length - 1].length == 0)
            trimmed.pop();

        var res = trimmed.join("\n");
        return new LongString(res);
    }
}

