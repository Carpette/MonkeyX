import utils
import mojo

Class Menu
	Field m_name:String

	Field m_position:Vec2Di
	Field m_size:Vec2Di

	'backGround color of the button'
	Field m_bgColor:Float[3]

	'Method called when button is pressed'
	Field m_methodCalled

	Method New( _name:String = "Menu", x:Int = 0, y:Int = 0, _width:Int = 200, _height:Int = 50, _color:Float[] )
		SetName( _name )
		m_position 	= new Vec2Di( x, y )
		m_size 		= new Vec2Di( _width, _height )
		m_bgColor	= _color
	End

	Method SetName( _name:String )
		m_name = _name
	End

	Method SetPosition( x:int, y:int )
		m_position.Set( x, y )
	End

	Method SetSize( x:int, y:int )
		m_size.Set( x, y )
	End

	Method Update()

	End

	Method Draw()
		Local l_oldColor:Float[] = GetColor()

		SetColor(m_bgColor[0],m_bgColor[1],m_bgColor[2])
		DrawRect( m_position.x - m_size.x / 2, m_position.y - m_size.y / 2, m_size.x, m_size.y)
		SetColor(255 - m_bgColor[0],255 - m_bgColor[1],255 - m_bgColor[2])
		DrawText( m_name, m_position.x - TextWidth(m_name), m_position.y)

		SetColor(l_oldColor[0],l_oldColor[1],l_oldColor[2])
	End

End