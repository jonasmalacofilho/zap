package zap;

class Dev {
    var dir:String;

    function new(dir:String)
    {
        this.dir = dir;
    }

    public function run()
    {
        trace(this);
        var s = new Search();
        s.execute();
    }

    public static function fromArgs(args:Map<String,Argument>)
    {
        var dir = (args["data"]:Null<String>);
        if (dir == null)
            dir = "./";
        return new Dev(dir);
    }
}

