import menu
import utils

Class ProgressBar
	
	Field m_background	:Menu
	Field m_foreground	:Menu
	Field m_name		:String
	Field m_completion	:Float
	Field m_position	:Vec2Di
	Field m_size		:Vec2Di
	Field m_value 		:Float
	Field m_maxValue	:Float

	Method New( _name:String = "progressBar", _value:Float = 0, _maxValue:Float = 0, _position:Vec2Di, _size:Vec2Di, _bgColor:Float[], _fgColor:Float[])
		
		m_position 		= _position
		m_size 			= _size
		m_value 		= _value
		m_maxValue		= _maxValue

		m_background = New Menu( "", m_position.x, m_position.y, m_size.x, m_size.y, _bgColor )
		m_foreground = New Menu( "", m_position.x, m_position.y, 1, m_size.y, _fgColor )
		SetName( _name )
	End

	Method SetName( _name:String )
		m_name = _name

	End

	Method SetPosition( _pos:Vec2Di )
		m_position = _position
	End

	Method SetSize( _size:Vec2Di )
		m_size = _size
	End

	Method Draw()
		m_background.Draw()
		m_foreground.Draw()
		DrawText( m_name, m_background.m_position.x - (TextWidth(m_name) + 5), m_background.m_position.y)
	End

	Method Update(_progression:Float)
		m_value = _progression
		Local l_Ratio:Float = m_value / m_maxValue
		Local l_sizeX = m_background.m_size.x * l_Ratio
		m_foreground.m_size.x = l_sizeX
		m_foreground.m_position.x = m_background.m_position.x - (m_background.m_size.x / 2) + (l_sizeX/ 2 )
	End

End