Class Vec2D
	Field x:Float
	Field y:Float

	Method New(x:Float = 0, y:Float = 0)
		Set(x, y)
	End

	Method Set(x:Float, y:Float)
		Self.x = x
		Self.y = y
	End
End

Class Vec2Di
	Field x:Int
	Field y:Int

	Method New(x:Int = 0, y:Int = 0)
		Set(x, y)
	End

	Method Set(x:Int, y:Int)
		Self.x = x
		Self.y = y
	End
End

Interface Callback
	Method Run:Void()
End