package zap;

enum ArgumentImpl {
    ABoolean(bool:Bool);
    AValue(val:String);
    AValues(vals:Array<String>);
}

abstract Argument(ArgumentImpl) from ArgumentImpl to ArgumentImpl {
    inline function new(a)
    {
        this = a;
    }

    @:to public inline function toBoolean()
    {
        switch (this) {
        case ABoolean(b):
            return b;
        case _:
            throw 'Unexpected boolean $this';
        }
    }

    @:to public inline function toString()
    {
        switch (this) {
        case AValue(val):
            return val;
        case _:
            throw 'Unexpected value $this';
        }
    }

    @:to public inline function toArray()
    {
        return switch (this) {
        case AValues(vals):
            vals;
        case _:
            throw 'Unexpected values $this';
        }
    }

    @:from public inline static function fromBoolean(bool:Bool)
    {
        return new Argument(ABoolean(bool));
    }

    @:from public inline static function fromValue(val:String)
    {
        return new Argument(AValue(val));
    }

    @:from public inline static function fromValues(vals:Array<String>)
    {
        return new Argument(AValues(vals));
    }

    // array interface

    public var length(get,never):Int;

    function get_length()
    {
        return toArray().length;
    }

    public function iterator()
    {
        return toArray().iterator();
    }

    public function push(val:String):Int
    {
        return toArray().push(val);
    }
}

