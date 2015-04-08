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
        var commands = ["download", "analyze"];
        var args = Sys.args().copy();
        var positional = false;

        var res = new Map<String,Argument>();
        res["download"] = false;
        res["analyze"] = false;
        res["--data"] = "./";
        res["<loc>"] = [];

        while (args.length > 0) {
            switch (args.shift()) {
            case "--data" if (!positional):
                var data = args.shift();
                if (data == null)
                    throw "Argument required for --data";
                res["--data"] = data;
            case cmd if (!positional && Lambda.has(commands, cmd)):
                res[cmd] = true;
            case "--":
                positional = true;
            case loc if (!loc.startsWith("--") || positional):
                res["<loc>"].push(loc);
            case e:
                throw 'Unknown option $e';
            }
        }
        // trace(res);

        if (res["download"] == res["analyze"])
            throw "Missing command";

        if (res["<loc>"].length == 0)
            throw "Nothing to do";

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
                zap download [--data DIR] [--] <loc> [<loc> ...]
                zap analyze [--data DIR]

            Options:
                --data DIR    Storage folder
            ".longString());
            Sys.exit(1);
            throw null;
        }

        for (loc in args["<loc>"]) {
            trace('Working on $loc');
        }
    }
}

