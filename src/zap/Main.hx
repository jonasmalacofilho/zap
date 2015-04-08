package zap;

using StringTools;
using zap.LongString;

class Main {
    public static function err(s:String)
    {
        Sys.stderr().writeString(s);
    }

    public static function errln(s:String)
    {
        err(s + "\n");
    }

    static function setup()
    {
        haxe.Log.trace = function (msg, ?pos)
                errln('${pos.fileName}:${pos.lineNumber}: $msg');
    }

    static function parseArgs()
    {
        var res = new Map<String,Argument>();

        // index
        var commands = ["dev", "download", "analyze"];
        var options = ["--data"];
        var positionals = ["<loc>"];
        var rest = "<loc>";

        // defaults
        res["--data"] = "./";
        res["<loc>"] = [];

        // automatic defaults
        for (cmd in commands)
            res[cmd] = false;

        // parsing
        var args = Sys.args().copy();
        var p = 0;
        var positional = false;
        while (args.length > 0) {
            switch (args.shift()) {
            case opt if (!positional && Lambda.has(options, opt)):
                var val = args.shift();
                if (val == null)
                    throw 'Argument required for $opt';
                res[opt] = val;
            case cmd if (!positional && Lambda.has(commands, cmd)):
                res[cmd] = true;
            case "--":
                positional = true;
            case pos if (!pos.startsWith("--") || positional):
                var name = p < positionals.length ? positionals[p++] : rest;
                if (rest == null)
                    throw 'Unmatched positional argument $pos';
                if (!res.exists(name))
                    res[name] = [];
                res[name].push(pos);
            case e:
                throw 'Unknown option $e';
            }
        }
        // trace(res);

        // constraints
        // if (res["<loc>"].length == 0)
        //     throw "Nothing to do";

        return res;
    }

    public static function main()
    {
        setup();

        var args = try {
            parseArgs();
        } catch (e:String) {
            errln('ERROR $e\n');
            errln("
            Usage:
                zap dev [--data DIR]
                zap download [--data DIR] [--] <loc> [<loc> ...]
                zap analyze [--data DIR]

            Options:
                --data DIR    Storage folder
            ".longString());
            // neko.Lib.rethrow(e);
            Sys.exit(1);
            throw null;
        }

        if (args["dev"])
            Dev.fromArgs(args).run();
        
        // TODO download, analyze, etc.
    }
}

