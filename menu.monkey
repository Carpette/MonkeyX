import utils

Class Menu
	Field m_name:String

	Field m_position:Vec2Di
	Field m_size:Vec2Di

	'backGround color of the button'
	Field m_bgColor:Int

	'Method called when button is pressed'
	Field m_methodCalled

	Method New( _name:String = "Menu", x:Int = 0, y:Int = 0, _width:Int = 200, _height:Int = 50 )
		SetName( _name )
		m_position 	= new Vec2Di( x, y )
		m_size 		= new Vec2Di( _width, _height )
	End

	Method SetName( _name:String )
		Self.m_name = _name
	End

	Method SetPosition( x:int, y:int )
		Self.m_position.Set( x, y )
	End

	Method SetSize( x:int, y:int )
		Self.m_size.Set( x, y )
	End

	Method Update()

	End

	Method Draw()

	End

End